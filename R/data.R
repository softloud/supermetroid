#' smdatasets
#'
#' smdata included in the supermetroid package.
#'
#' @family smdata

#' Splits.io data for segments
#'
#' Intermediary dataset from sio vignette.
#' Each row is a split time (segment) for a specific run, created in sio. Use
#' [sio_df] for analyses; this is the raw data before relabelling.
#' @family smdata
"sio_splits_df"

#' Splitsio smdata: time series observations
#'
#' See vignette splits
#'
#' @family smdata
"sio_df"
#' Splitsio smdata: anatomecha's splits
#'
#' See vignette splits
#'
#' @family smdata
"anatomecha_splits"

#' Speedrun.com leaderboard smdata
#'
#' Player and run data joined. See src vignette.
#'
#' @family smdata
"src_df"

#' Distinct routes
#'
#' Used in route-graph and route-matching vignettes
#'
#' @family smdata
"distinct_routes"

#' Wide array of runtime at segment by run
#'
#' @family smdata
"sio_routes_wide"

#' Dataframe for graphing routes
#'
#' @family smdata
"from_to_df"
