#' Fetch ParlGov election-results view
#'
#' Downloads and caches the ParlGov `view_election` CSV. Subsequent calls
#' return the cached copy unless `refresh = TRUE`. Network access is
#' required on the first call; `curl` is a soft dependency.
#'
#' @param refresh logical; if `TRUE`, re-downloads even when a cache exists.
#' @param cache_dir directory for the cached CSV. Defaults to
#'   `tools::R_user_dir("partyscape", "cache")`.
#' @param url source URL. Defaults to the live ParlGov endpoint.
#'
#' @return A data.frame of ParlGov rows (country, date, type, party, seats,
#'   vote_share, votes, election_id, party_id, ...).
#' @references Döring, H., & Manow, P. (2024). *ParlGov: Parliaments and
#'   governments database.* Harvard Dataverse. DOI:
#'   \doi{10.7910/DVN/2VZ5ZC}.
#' @export
fetch_parlgov <- function(refresh = FALSE,
                          cache_dir = tools::R_user_dir("partyscape", "cache"),
                          url = "https://parlgov.fly.dev/data-csv/view_election/") {
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
  }
  dest <- file.path(cache_dir, "parlgov_view_election.csv")

  if (isTRUE(refresh) || !file.exists(dest)) {
    if (!requireNamespace("curl", quietly = TRUE)) {
      # Fall back to utils::download.file when curl is not available.
      utils::download.file(url, dest, mode = "wb", quiet = FALSE)
    } else {
      curl::curl_download(url, dest, quiet = FALSE, mode = "wb")
    }
  }

  read_csv_fast(dest)
}

read_csv_fast <- function(path) {
  if (requireNamespace("readr", quietly = TRUE)) {
    as.data.frame(readr::read_csv(path, show_col_types = FALSE))
  } else {
    utils::read.csv(path, stringsAsFactors = FALSE)
  }
}

#' Reshape ParlGov output to a seat-share matrix
#'
#' Takes the long ParlGov `view_election` output and pivots it to a wide
#' matrix (one row per country-year election, one column per party) of
#' seat shares in \[0, 1\]. Handy as direct input to [diversity_profile()]
#' or [alpha_beta_gamma()].
#'
#' @param parlgov data.frame returned by [fetch_parlgov()].
#' @param countries optional character vector of country names to keep.
#' @param years optional integer vector; if supplied, only elections whose
#'   year lies in the vector are kept.
#' @param type election type to keep. Default `"parliament"`.
#' @param min_share drop parties whose share is below this threshold
#'   (keeps a sensible column count). Default `0` (keep all).
#'
#' @return A numeric matrix (rows = `country_year`, cols = party names).
#'   Attributes `country` and `year` are attached for convenience.
#' @export
parlgov_seat_shares <- function(parlgov,
                                countries = NULL,
                                years = NULL,
                                type = "parliament",
                                min_share = 0) {
  stopifnot(is.data.frame(parlgov))
  required <- c("country", "date", "type", "party", "seats", "votes")
  missing_cols <- setdiff(required, names(parlgov))
  if (length(missing_cols)) {
    stop("parlgov_seat_shares(): missing columns: ",
         paste(missing_cols, collapse = ", "), call. = FALSE)
  }

  df <- parlgov
  df <- df[!is.na(df$type) & df$type == type, , drop = FALSE]
  df$year <- as.integer(substr(df$date, 1, 4))
  if (!is.null(countries)) df <- df[df$country %in% countries, , drop = FALSE]
  if (!is.null(years))     df <- df[df$year %in% years,       , drop = FALSE]

  # Compute per-election seat shares from `seats`; fall back to `votes` when
  # seats is entirely missing for an election (rare).
  df$country_year <- paste(df$country, df$year, sep = "_")
  df$seats[is.na(df$seats)] <- 0

  totals <- tapply(df$seats, df$country_year, sum)
  bad_elections <- names(totals)[totals == 0]
  if (length(bad_elections)) {
    # Use votes as fallback for those elections.
    keep <- df$country_year %in% bad_elections
    v_totals <- tapply(df$votes[keep], df$country_year[keep], sum, na.rm = TRUE)
    df$share <- ifelse(df$country_year %in% bad_elections,
                       df$votes / v_totals[df$country_year],
                       df$seats / totals[df$country_year])
  } else {
    df$share <- df$seats / totals[df$country_year]
  }
  df$share[is.na(df$share)] <- 0

  if (min_share > 0) {
    df <- df[df$share >= min_share, , drop = FALSE]
  }

  # Party labels must be unique per election but can repeat across countries.
  wide <- pivot_to_wide(df, id = "country_year",
                        party = "party", share = "share")

  # Order rows by country then year.
  keys <- rownames(wide)
  meta_country <- vapply(strsplit(keys, "_", fixed = TRUE),
                         function(s) paste(s[-length(s)], collapse = "_"),
                         character(1))
  meta_year <- as.integer(vapply(strsplit(keys, "_", fixed = TRUE),
                                 function(s) s[length(s)], character(1)))
  ord <- order(meta_country, meta_year)
  wide <- wide[ord, , drop = FALSE]

  structure(wide,
            country = meta_country[ord],
            year    = meta_year[ord])
}
