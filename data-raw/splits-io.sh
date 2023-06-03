# replace :game with shortname, i.e. :supermetroid

curl https://splits.io/api/v4/categories/279 -o data-raw/splits-io-category.json
curl https://splits.io/api/v4/categories/279/runners -o data-raw/splits-io-runners.json
curl https://splits.io/api/v4/categories/279/runs -o data-raw/splits-io-runs.json

#
curl https://splits.io/api/v4/games/supermetroid/runs -o data-raw/splits-io-game-runs.json


