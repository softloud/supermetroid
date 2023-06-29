#' Splits.io data for segments
#'
#' Intermediary dataset from sio vignette.
#' Each row is a split time (segment) for a specific run, created in sio. Use
#' sio_df for analyses; this is the raw data before relabelling.
"sio_splits_df"

#' Splitsio smdata: time series observations
#'
#' See vignette splits; use [splits_df] for analysis.
"sio_df"

#' Most recorded splits
#'
#' See vignette splits; splits the most runners have recorded.
"common_splits"

#' Speedrun.com leaderboard smdata
#'
#' Player and run data joined. See src vignette; use [splits_df] for analysis.
"src_df"

#' Distinct routes
#'
#' Used in route-graph and route-matching vignettes
"distinct_routes"

#' Wide array of runtime at segment by run
#'
#' splits.io routes
"sio_routes_wide"

#' Dataframe for graphing routes
#'
#' splits.io routes in tidygraph form
"from_to_df"

#' Splits df with src info
#'
#' Use this dataset for analysis
"splits_df"

#' Top games from speedrun.com
#'
#' Hand transcribed top five from each category across games
#' and for SNES.
"src_top_df"
