#' partyscape: Diversity Profiles, Crossings, and Beta Diversity for Party Systems
#'
#' Three analytical tools for describing party-system fragmentation from
#' compositions of seat or vote shares: diversity profiles (Hill numbers
#' over an order-`q` grid), profile crossings (structural incomparability
#' between two systems), and multiplicative beta diversity (Jost 2007)
#' for change over time. Also a small accessor layer for ParlGov.
#'
#' @section Core entry points:
#' - [diversity_profile()], [evenness_profile()], [hill_number()]
#' - [crossings()]
#' - [alpha_beta_gamma()], [collapse_to_elections()]
#' - scalar summaries: [hhi()], [rae()], [enp()], [dominance_gap()], [top_two()]
#' - null model: [taagepera_allik_shares()]
#' - ParlGov: [fetch_parlgov()], [parlgov_seat_shares()]
#'
#' @keywords internal
#' @importFrom stats setNames
#' @importFrom utils head
#' @importFrom ggplot2 .data
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
