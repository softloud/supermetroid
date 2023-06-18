% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all_run_raincloud.R
\name{all_run_raincloud}
\alias{all_run_raincloud}
\title{Raincloud plot of speedrun.com run times}
\usage{
all_run_raincloud(
  run_df = src_run_df,
  xmin = min(src_run_df$t_s),
  xmax = max(src_run_df$t_s),
  base_size = 15,
  source = "speedrun.com"
)
}
\arguments{
\item{run_df}{Dataframe of column of run times \code{t_s} in seconds}

\item{xmin}{Set limits of x axis (for shiny slider input)}

\item{xmax}{Set max of x axis (shiny slider)}

\item{base_size}{For theme_minimal}

\item{source}{Caption provenance}
}
\description{
Raincloud plot of speedrun.com run times
}