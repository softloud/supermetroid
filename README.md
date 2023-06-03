
- <a href="#supermetroid" id="toc-supermetroid">supermetroid</a>
- <a href="#at-what-times-do-super-metroid-100-speed-runs-get-competitive"
  id="toc-at-what-times-do-super-metroid-100-speed-runs-get-competitive">At
  what times do Super Metroid 100% speed runs get competitive?</a>
- <a href="#what-is-super-metroid" id="toc-what-is-super-metroid">What is
  Super Metroid?</a>
- <a href="#analyses-work-in-progress"
  id="toc-analyses-work-in-progress">Analyses (work in progress)</a>
  - <a href="#speed-run-times-from-speedrumcom"
    id="toc-speed-run-times-from-speedrumcom">Speed run times from
    speedrum.com</a>
- <a href="#getting-the-data" id="toc-getting-the-data">Getting the
  data</a>
  - <a href="#sources" id="toc-sources">Sources</a>
  - <a href="#desired-output-ggplot-friendlytidy-data"
    id="toc-desired-output-ggplot-friendlytidy-data">Desired output:
    <code>ggplot</code>-friendly/tidy data</a>
    - <a href="#runs" id="toc-runs">Runs</a>
    - <a href="#location-of-players-on-speedruncom"
      id="toc-location-of-players-on-speedruncom">Location of players on
      speedrun.com</a>
    - <a href="#segments-for-each-run-from-splitsio"
      id="toc-segments-for-each-run-from-splitsio">Segments for each run from
      splitsio</a>
- <a href="#import-pkg--helper-functions"
  id="toc-import-pkg--helper-functions">Import pkg &amp; helper
  functions</a>
  - <a href="#last-updated" id="toc-last-updated">Last updated</a>
- <a href="#get-data-from-speedruncom"
  id="toc-get-data-from-speedruncom">Get data from speedrun.com</a>
  - <a href="#load-runs-from-100-leaderboard"
    id="toc-load-runs-from-100-leaderboard">Load runs from 100%
    leaderboard</a>
  - <a href="#run-dataframe" id="toc-run-dataframe">Run dataframe</a>
  - <a href="#write-speedruncom-data-to-package"
    id="toc-write-speedruncom-data-to-package">Write speedrun.com data to
    package</a>
- <a href="#visualise-runs" id="toc-visualise-runs">Visualise runs</a>
  - <a href="#raincloud" id="toc-raincloud">Raincloud</a>
- <a href="#getting-the-data-from-splitsio"
  id="toc-getting-the-data-from-splitsio">Getting the data from
  splitsio</a>
  - <a href="#load-runs-and-runners" id="toc-load-runs-and-runners">Load
    runs and runners</a>
  - <a href="#inspect-data" id="toc-inspect-data">Inspect data</a>
  - <a href="#run-dataframe-1" id="toc-run-dataframe-1">Run dataframe</a>
  - <a href="#srdc-ids-and-player-ids" id="toc-srdc-ids-and-player-ids">srdc
    ids and player ids?</a>
    - <a href="#ids-in-speedruncom" id="toc-ids-in-speedruncom">ids in
      speedrun.com</a>
    - <a href="#10-ids-in-splitsio" id="toc-10-ids-in-splitsio">~10% ids in
      splits.io</a>
  - <a href="#create-segments-dataframe"
    id="toc-create-segments-dataframe">create segments dataframe</a>
- <a href="#deertier" id="toc-deertier">deertier</a>
- <a href="#speedrunslive" id="toc-speedrunslive">speedrunslive</a>
- <a href="#wikipedia" id="toc-wikipedia">wikipedia</a>
- <a href="#later" id="toc-later">later</a>

<!-- README.md is generated from README.Rmd. Please edit that file -->

# supermetroid

<!-- badges: start -->
<!-- badges: end -->

# At what times do Super Metroid 100% speed runs get competitive?

# What is Super Metroid?

> While the exploration-focused platformers known as Metroidvanias
> derive their genre name from two different series, there’s one game
> they’re all judged by. Super Metroid wasn’t the first Metroidvania,
> the first Metroid game also had the focus on exploring a large
> interconnected map and using new abilities to open up new areas, but
> its polish, visual direction, and atmosphere all created a more
> involved experience than its predecessors. Released in 1994, Super
> Metroid’s shadow looms over every game in the genre since… -
> [thegamehoard
> 2022](https://thegamehoard.com/2022/04/24/50-years-of-video-games-super-metroid-snes/)

``` r
# source: wikipedia
knitr::include_graphics("img/Smetroidbox-wiki.png")
```

<img src="img/Smetroidbox-wiki.png" width="50%" style="display: block; margin: auto;" />

# Analyses (work in progress)

## Speed run times from speedrum.com

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

# Getting the data

## Sources

There are several sites where players upload Super Metroid speed running
data.

| site                                                               | api                                                                                                                                           | description (why we’re interested, these assumptions should be checked)              |
|--------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| [speedrun](https://www.speedrun.com/supermetroid?h=Any&x=9d8v96lk) | [python](https://github.com/blha303/srcomapi)(how to get historical?) & [curl](https://github.com/glacials/splits-io/blob/master/docs/api.md) | most complete list of speed runs                                                     |
| [splitio](https://splits.io/)                                      | [python](https://github.com/splitio/python-api)                                                                                               | by-segment times for each run, but for a smaller number of runners than speedrun.com |
| [deertier](https://deertier.com/)                                  | there is an api, but I think we can get everything we need with `rvest`                                                                       | super metroid game-specific speed running site                                       |

## Desired output: `ggplot`-friendly/tidy data

Dataframes that describe runs, runners, and, eventually, categories.
Ideally, aggregated across the datasets.

However, this will results in missing data, so specific analyses need to
take that into account, or use source-specific datasets from the
aggregated set with caveats. Linking ids are in italics.

Either way, we need to know what we have in each dataset, and have a
universal schema across datasets.

### Runs

Each row describes one speed run; a player may have multiple runs in a
database.

| run_df      | description                  |
|-------------|------------------------------|
| date        | timestamp of run upload      |
| *run_id*    | unique identifier of run     |
| run_time    | total time of run in s or ms |
| *player_id* | unique identifier of player  |
| rank        | rank of player               |

To build a speed run leaderboard across datasets, we’d need to do some
fancy engineering, so we will focus on source-specific analyses for now.
Each leaderboard comprises runs.

| run_df        | description                                                                                                              |
|---------------|--------------------------------------------------------------------------------------------------------------------------|
| date          | timestamp of run upload                                                                                                  |
| *run_id*      | unique identifier of run                                                                                                 |
| run_time      | total time of run in s or ms                                                                                             |
| *player_id*   | unique identifier of player                                                                                              |
| rank          | rank of player                                                                                                           |
| *src_id*      | speedrun.com id                                                                                                          |
| *sio_id*      | splits.io id                                                                                                             |
| *deertier_id* | deertier id                                                                                                              |
| historical    | if a historical ranking, need to inspect data to see how this should be recorded, possibly a bool, or putting NA in rank |

### Location of players on speedrun.com

| player_df     | description                   |
|---------------|-------------------------------|
| *player_id*   | unique identifier of player   |
| player_handle | human-readable **unique** tag |
| location      | geographic location of player |

### Segments for each run from splitsio

| segment_df | description                                        |
|------------|----------------------------------------------------|
| *run_id*   | unique identifier of run                           |
| segment_id | unique identifier of segment                       |
| t_s        | time in seconds, measured to millisecond precision |

# Import pkg & helper functions

``` python
import srcomapi, srcomapi.datatypes as dt
import pandas as pd
import pickle
import splitsio
```

``` r
library(tidyverse)
library(tidyquant)
library(ggdist)
library(reticulate)

# load r functions for this analysis
library(supermetroid)
```

``` python
# helper function: saving an anonymous object in python 
# https://stackoverflow.com/questions/4529815/saving-an-object-data-persistence

def save_object(obj, filename):
    with open(filename, 'wb') as outp:  # Overwrites any existing file.
        pickle.dump(obj, outp, pickle.HIGHEST_PROTOCOL)
```

## Last updated

``` r
# this chunk is evaluated when data is updated

write_rds(today(), "data-raw/readme-updated.rds")
```

``` r
# get last updated

update_date <- read_rds("data-raw/readme-updated.rds")
```

This read me was last updated: 2023-06-03.

# Get data from speedrun.com

## Load runs from 100% leaderboard

The game object was too nested to pickle, so runs have been extracted
and saved.

``` python
# get the runs object wrangled above

# data extracted in data-raw/get-src.py

with open('data-raw/src_runs.pkl', 'rb') as inp:
    src_runs = pickle.load(inp)
```

``` python
# inspect runs object
type(src_runs)
#> <class 'list'>
len(src_runs)
#> 596
```

``` python

# inspect one element
src_runs[0] 
#> {'place': 1, 'run': {'id': 'z5do82dm', 'weblink': 'https://www.speedrun.com/supermetroid/run/z5do82dm', 'game': 'm1zoemd0', 'level': None, 'category': 'xd1mpewd', 'videos': {'links': [{'uri': 'https://www.youtube.com/watch?v=vBdHFz9gTtM'}]}, 'comment': 'Oats raids always bring me the best luck. YES!!!!', 'status': {'status': 'verified', 'examiner': 'zxzno3ex', 'verify-date': '2021-07-31T17:57:05Z'}, 'players': [{'rel': 'user', 'id': 'zxzno3ex', 'uri': 'https://www.speedrun.com/api/v1/users/zxzno3ex'}], 'date': '2021-07-31', 'submitted': '2021-07-31T17:57:05Z', 'times': {'primary': 'PT1H12M53S', 'primary_t': 4373, 'realtime': 'PT1H12M53S', 'realtime_t': 4373, 'realtime_noloads': None, 'realtime_noloads_t': 0, 'ingame': 'PT42M', 'ingame_t': 2520}, 'system': {'platform': '83exk6l5', 'emulated': False, 'region': None}, 'splits': None, 'values': {'wle6dpr8': '21gezkxl', 'wl3dqoo8': 'jq6eyx3l'}}}
type(src_runs[0])
#> <class 'dict'>
src_runs[0].keys()

# run element is a nested dictionary
#> dict_keys(['place', 'run'])
type(src_runs[0]['run'])
#> <class 'dict'>
src_runs[0]['run'].keys()

#> dict_keys(['id', 'weblink', 'game', 'level', 'category', 'videos', 'comment', 'status', 'players', 'date', 'submitted', 'times', 'system', 'splits', 'values'])
```

``` python

# inspect a few elements
src_runs[0:3] 
#> [{'place': 1, 'run': {'id': 'z5do82dm', 'weblink': 'https://www.speedrun.com/supermetroid/run/z5do82dm', 'game': 'm1zoemd0', 'level': None, 'category': 'xd1mpewd', 'videos': {'links': [{'uri': 'https://www.youtube.com/watch?v=vBdHFz9gTtM'}]}, 'comment': 'Oats raids always bring me the best luck. YES!!!!', 'status': {'status': 'verified', 'examiner': 'zxzno3ex', 'verify-date': '2021-07-31T17:57:05Z'}, 'players': [{'rel': 'user', 'id': 'zxzno3ex', 'uri': 'https://www.speedrun.com/api/v1/users/zxzno3ex'}], 'date': '2021-07-31', 'submitted': '2021-07-31T17:57:05Z', 'times': {'primary': 'PT1H12M53S', 'primary_t': 4373, 'realtime': 'PT1H12M53S', 'realtime_t': 4373, 'realtime_noloads': None, 'realtime_noloads_t': 0, 'ingame': 'PT42M', 'ingame_t': 2520}, 'system': {'platform': '83exk6l5', 'emulated': False, 'region': None}, 'splits': None, 'values': {'wle6dpr8': '21gezkxl', 'wl3dqoo8': 'jq6eyx3l'}}}, {'place': 2, 'run': {'id': 'yo75d4dm', 'weblink': 'https://www.speedrun.com/supermetroid/run/yo75d4dm', 'game': 'm1zoemd0', 'level': None, 'category': 'xd1mpewd', 'videos': None, 'comment': 'video at\r\ndeertier.com\r\nor\r\nyoutube.com/zoasty', 'status': {'status': 'verified', 'examiner': '18v6k4nx', 'verify-date': '2021-07-02T12:31:43Z'}, 'players': [{'rel': 'user', 'id': '18v6k4nx', 'uri': 'https://www.speedrun.com/api/v1/users/18v6k4nx'}], 'date': '2021-02-24', 'submitted': '2021-07-02T12:31:43Z', 'times': {'primary': 'PT1H12M55S', 'primary_t': 4375, 'realtime': 'PT1H12M55S', 'realtime_t': 4375, 'realtime_noloads': None, 'realtime_noloads_t': 0, 'ingame': 'PT42M', 'ingame_t': 2520}, 'system': {'platform': '83exk6l5', 'emulated': False, 'region': None}, 'splits': None, 'values': {'wle6dpr8': '21gezkxl', 'wl3dqoo8': 'jq6eyx3l'}}}, {'place': 3, 'run': {'id': 'm36d0q6m', 'weblink': 'https://www.speedrun.com/supermetroid/run/m36d0q6m', 'game': 'm1zoemd0', 'level': None, 'category': 'xd1mpewd', 'videos': {'links': [{'uri': 'https://www.youtube.com/watch?v=7pqyw6eO5Gc'}]}, 'comment': 'wun twulf', 'status': {'status': 'verified', 'examiner': 'zxz2wy4x', 'verify-date': '2021-12-09T16:05:14Z'}, 'players': [{'rel': 'user', 'id': 'zxz2wy4x', 'uri': 'https://www.speedrun.com/api/v1/users/zxz2wy4x'}], 'date': '2021-12-08', 'submitted': '2021-12-09T16:05:14Z', 'times': {'primary': 'PT1H12M55.930S', 'primary_t': 4375.93, 'realtime': 'PT1H12M55.930S', 'realtime_t': 4375.93, 'realtime_noloads': None, 'realtime_noloads_t': 0, 'ingame': 'PT42M', 'ingame_t': 2520}, 'system': {'platform': '83exk6l5', 'emulated': False, 'region': None}, 'splits': None, 'values': {'wle6dpr8': '21gezkxl', 'wl3dqoo8': 'jq6eyx3l'}}}]
```

## Run dataframe

| src_run_df  | description                                                    | from                                        |
|-------------|----------------------------------------------------------------|---------------------------------------------|
| date        | timestamp of run upload                                        | `runs[index]['run']['date']`                |
| *run_id*    | unique identifier of run                                       | `runs[index]['run']['date']`                |
| run_time    | total time of run in s or ms                                   | `runs[index]['run']['times']['realtime_t']` |
| *player_id* | unique identifier of player                                    | player id == run id, debug extraction       |
| rank        | rank, empty if historical, currently don’t have historical obs | `src_runs[x]['place']`                      |

``` python
print("Hello world")
#> Hello world
```

``` python

n_obs = len(src_runs)

# how to get splits? [src_runs][x]['run']['splits']

# extract elements with list comprehension
src_run_df = pd.DataFrame({
  'run_id' : [src_runs[x]['run']['id'] for x in range(n_obs)],
  # need to inspect what happens to historical ranking
  'rank' : [src_runs[x]['place'] for x in range(n_obs)], 
  't_s' : [src_runs[x]['run']['times']['realtime_t'] for x in range(n_obs)],
  'date' : [src_runs[x]['run']['date'] for x in range(n_obs)]
})

# inspect runs dataframe
src_run_df.head()
#>      run_id  rank      t_s        date
#> 0  z5do82dm     1  4373.00  2021-07-31
#> 1  yo75d4dm     2  4375.00  2021-02-24
#> 2  m36d0q6m     3  4375.93  2021-12-08
#> 3  m3qo724y     4  4392.00  2023-05-08
#> 4  y4g31v3y     5  4442.00  2022-12-10
```

``` python
# number of unique values
```

## Write speedrun.com data to package

``` r
# this chunk is evaluated when data is updated

src_run_raw <- py$src_run_df

usethis::use_data(src_run_df, overwrite=TRUE)
#> ✔ Setting active project to '/home/cantabile/Documents/GitHub/supermetroid'
#> ✔ Saving 'src_run_df' to 'data/src_run_df.rda'
#> • Document your data (see 'https://r-pkgs.org/data.html')
```

# Visualise runs

Now we have the data from speedrun.com leaderboard, we can plot the
distribution of runs.

``` r
all_run_raincloud(src_run_df)
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%" />

There are some odd values near 0, which suggest that we need to
investigate if there are unfinished runs logged on speedrun.com.

If there *are* unfinished runs, this density is spurious, includes
unfinished runs even after filtering out near-zero entries, we need to
find a way to label rows that are unfinished, or identify the weird
entries with the page.

We have a handful of 0 entries, we’ll filter these.

``` r
# how many runs are really low?
src_run_df %>% 
  filter(t_s < 4000)
#>     run_id rank t_s       date
#> 1 y20nprwm  591   0 2022-02-23
#> 2 znp3nvvm  592   0 2022-05-07
#> 3 ywp6dqnz  593   0 2018-11-06
#> 4 y21k26wz  594   0 2019-12-06
#> 5 yv8peoxm  595   0 2023-02-19
#> 6 yl9oenxy  596   0 2017-08-02
```

## Raincloud

``` r
src_run_df %>%
  filter(# remove 0 length runs
    t_s > 0,
    # remove runs that are greater than 4 hours
    t_s < 4 * 60 * 60) %>%
  all_run_raincloud()
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" />

# Getting the data from splitsio

## Load runs and runners

``` python
# this chunk is not evaluated 
# to minimise api calls

# get 100% Category Super Metroid game data  
hun_cat = splitsio.Category.from_id("279", historic=True)
save_object(hun_cat, "data-raw/sio_hun_cat.pkl")
```

``` python
# load sio data
with open('data-raw/sio_hun_cat.pkl', 'rb') as inp:
    hun_cat = pickle.load(inp)

# extract runners and run from category
sio_runners = hun_cat.runners()

sio_runs = hun_cat.runs()
```

## Inspect data

``` python
# take a look at a run
sio_runs[0]

# can we call nested elements by index and key?
#> Run(id='asmc', srdc_id=None, realtime_duration_ms=6543298, realtime_sum_of_best_ms=6388932, gametime_duration_ms=4631917, gametime_sum_of_best_ms=4242831, default_timing='real', program='livesplit', attempts=183, image_url=None, parsed_at='2023-05-26T13:55:36.932Z', created_at='2023-05-26T13:55:02.091Z', updated_at='2023-05-26T13:55:36.984Z', video_url=None, game=Game(id='50', name='Super Metroid', shortname='supermetroid'), category=Category(id='279', name='100%'), runners=[Runner(id='89051', twitch_id='452077937', twitch_name='juniorr300', display_name='juniorr300', name='juniorr300')])
type(sio_runs[0])
# I think this is a series object?
#> <class 'splitsio.api.Run'>
print(pd.DataFrame(sio_runs[1:3]))
#>      id srdc_id  ...                                           segments  histories
#> 0  amuv    None  ...  [{'id': 'f847b639-9003-480e-9c5c-51d25e247df5'...       None
#> 1  amcl    None  ...  [{'id': '56c3ce3f-5fa5-4ba6-a8c4-75613cac6c3c'...       None
#> 
#> [2 rows x 19 columns]
print(pd.DataFrame(sio_runs[1:3]).columns)
#> Index(['id', 'srdc_id', 'realtime_duration_ms', 'realtime_sum_of_best_ms',
#>        'gametime_duration_ms', 'gametime_sum_of_best_ms', 'default_timing',
#>        'program', 'attempts', 'image_url', 'parsed_at', 'created_at',
#>        'updated_at', 'video_url', 'game', 'category', 'runners', 'segments',
#>        'histories'],
#>       dtype='object')
```

``` python
# take a look at a runner
sio_runners[0]
#> Runner(id='284', twitch_id='37537140', twitch_name='dyceron', display_name='Dyceron', name='Dyceron')
```

## Run dataframe

Objective: to wrangle a data frame with run data

| sio_run_df    | description                                                                                                | splitsio                                    |
|---------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| *run_id*      | splits.io id                                                                                               | `id`                                        |
| date          | timestamp of run upload                                                                                    | ? `'created_at', 'parsed_at', 'updated_at'` |
| run_time      | total time of run in s or ms                                                                               | `realtime_duration_ms`                      |
| rank          | “historical” if from previous record (nb only applies to speedrun.com); otherwise rank as int, list column | ?                                           |
| src_player_id | speedrun.com player id                                                                                     | `srdc_id`                                   |

``` python
# this chunk isn't evaluated

# this dataframe takes too long to create for knitting, save object
sio_df = pd.DataFrame(sio_runs)

save_object(sio_df, "data-raw/sio_df.pkl")
```

``` python

# load runs df
with open('data-raw/sio_df.pkl', 'rb') as inp:
    sio_df = pickle.load(inp)
```

``` python
sio_df.columns

#> Index(['id', 'srdc_id', 'realtime_duration_ms', 'realtime_sum_of_best_ms',
#>        'gametime_duration_ms', 'gametime_sum_of_best_ms', 'default_timing',
#>        'program', 'attempts', 'image_url', 'parsed_at', 'created_at',
#>        'updated_at', 'video_url', 'game', 'category', 'runners', 'segments',
#>        'histories'],
#>       dtype='object')
```

``` python

# three fields that look like dates
# which should we intepret as the "date" of the run?
sio_df[['created_at', 'parsed_at', 'updated_at']]
#>                  created_at               parsed_at              updated_at
#> 0   2023-05-26 13:55:02.091 2023-05-26 13:55:36.932 2023-05-26 13:55:36.984
#> 1   2023-04-07 19:16:29.375 2023-05-14 15:29:09.869 2023-05-14 15:29:09.881
#> 2   2023-04-03 14:09:56.151 2023-05-14 10:34:06.391 2023-05-14 10:34:06.575
#> 3   2023-03-10 23:30:26.626 2023-05-13 07:44:20.405 2023-05-13 07:44:20.415
#> 4   2023-05-12 01:30:18.683 2023-05-12 01:30:34.126 2023-05-12 01:30:34.131
#> ..                      ...                     ...                     ...
#> 579 2018-01-01 03:41:01.212 2018-01-01 03:41:19.538 2019-03-16 08:06:41.469
#> 580 2017-12-16 01:49:19.032 2017-12-16 01:49:21.724 2019-03-16 08:05:25.117
#> 581 2017-11-29 03:23:35.645 2017-11-29 03:23:39.638 2019-03-16 08:03:58.329
#> 582 2017-11-29 03:22:44.063 2017-11-29 03:22:47.135 2019-03-16 08:03:58.305
#> 583 2015-06-16 04:51:19.260 2018-12-06 22:42:01.089 2019-03-16 07:26:30.176
#> 
#> [584 rows x 3 columns]
```

``` python
# id is hopefully the run id

# there should be the same number of unique run 
# ids as there are rows in the dataframe
sio_df[['id']].drop_duplicates().shape[0] == sio_df.shape[0]

#> True
```

``` python
# it would be super useful to have the srcom ids match

# this many are not empty

sio_df[['srdc_id']].dropna() 

# but that means we can only match this proportion of records
#>       srdc_id
#> 20   yd19vdqy
#> 29   yol1r0jy
#> 30   meerjw8m
#> 31   yolww15y
#> 32   z1qee4wy
#> ..        ...
#> 527  zpqrl4gy
#> 529  zq6gx85y
#> 530  zpqrl4gy
#> 531  zpqrl4gy
#> 541  zpqrl4gy
#> 
#> [62 rows x 1 columns]
src_splits_prop = sio_df[['id','srdc_id']].dropna().shape[0] / sio_df.shape[0]


# why are some srdc ids duplicated? because historic=TRUE for these data
```

Only 10% of records match:

``` python
round(src_splits_prop, 2)
#> 0.11
```

## srdc ids and player ids?

### ids in speedrun.com

``` python
src_run_df[['run_id', 'play_id']]
#> Error: KeyError: "['play_id'] not in index"
```

### \~10% ids in splits.io

``` python
sio_df[['srdc_id']].dropna() 
#>       srdc_id
#> 20   yd19vdqy
#> 29   yol1r0jy
#> 30   meerjw8m
#> 31   yolww15y
#> 32   z1qee4wy
#> ..        ...
#> 527  zpqrl4gy
#> 529  zq6gx85y
#> 530  zpqrl4gy
#> 531  zpqrl4gy
#> 541  zpqrl4gy
#> 
#> [62 rows x 1 columns]
```

## create segments dataframe

| segment_df | description                                        |
|------------|----------------------------------------------------|
| *run_id*   | unique identifier of run                           |
| segment_id | unique identifier of segment                       |
| t_s        | time in seconds, measured to millisecond precision |

``` python
# first level of segments
type(sio_df['segments'][0])
#> <class 'list'>
len(sio_df['segments'][0])

# second level of segments
#> 15
type(sio_df['segments'][0][0])
#> <class 'dict'>
sio_df['segments'][0][2].keys()

#> dict_keys(['id', 'name', 'display_name', 'segment_number', 'realtime_start_ms', 'realtime_duration_ms', 'realtime_end_ms', 'realtime_shortest_duration_ms', 'realtime_gold', 'realtime_skipped', 'realtime_reduced', 'gametime_start_ms', 'gametime_duration_ms', 'gametime_end_ms', 'gametime_shortest_duration_ms', 'gametime_gold', 'gametime_skipped', 'gametime_reduced', 'histories'])
segments_list = [pd.DataFrame(sio_df.segments[x]).assign(run_id = sio_df.id[x]) for x in range(sio_df.shape[0]) ]

segment_raw = pd.concat(segments_list)

segment_raw.columns
#> Index(['id', 'name', 'display_name', 'segment_number', 'realtime_start_ms',
#>        'realtime_duration_ms', 'realtime_end_ms',
#>        'realtime_shortest_duration_ms', 'realtime_gold', 'realtime_skipped',
#>        'realtime_reduced', 'gametime_start_ms', 'gametime_duration_ms',
#>        'gametime_end_ms', 'gametime_shortest_duration_ms', 'gametime_gold',
#>        'gametime_skipped', 'gametime_reduced', 'histories', 'run_id'],
#>       dtype='object')
```

# deertier

# speedrunslive

# wikipedia

# later

- [ ] You’ll still need to render `README.Rmd` regularly, to keep
  `README.md` up-to-date. `devtools::build_readme()` is handy for this.
  You could also use GitHub Actions to re-render `README.Rmd` every time
  you push. An example workflow can be found here:
  <https://github.com/r-lib/actions/tree/v1/examples>.
