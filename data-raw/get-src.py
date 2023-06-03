import srcomapi, srcomapi.datatypes as dt
import pickle


# call api

api = srcomapi.SpeedrunCom(); api.debug = 1

# It's recommended to cache the game ID and use it for future requests.
# Data is cached for the current session by classname/id so future
# requests for the same game are instantaneous.

api.search(srcomapi.datatypes.Game, {"name": "super metroid"})

# can we add a historical == true to this?

game = _[0]

# Unfortunately, couldn't save game object with pickle, was too nested, 
# had to move the save object down to where the many-level-deep dictionary was

# https://github.com/blha303/srcomapi#getting-a-dict-containing-all-runs-from-a-game

sms_runs = {}
for category in game.categories:
  if not category.name in sms_runs:
    sms_runs[category.name] = {}
  if category.type == 'per-level':
    for level in game.levels:
      sms_runs[category.name][level.name] = dt.Leaderboard(api, data=api.get("leaderboards/{}/level/{}/{}?embed=variables".format(game.id, level.id, category.id)))
  else:
    sms_runs[category.name] = dt.Leaderboard(api, data=api.get("leaderboards/{}/category/{}?embed=variables".format(game.id, category.id)))

### 100% Super Metroid leaderbaord

leaderboard = sms_runs['100%']

# display keys of dictionary
leaderboard.__dict__.keys()

# get the data as a nested dictionary
leaderboard_data = leaderboard.__dict__['data']

type(leaderboard_data)

# keys for the leaderboard 
leaderboard_data.keys()

# A little quality assurance

# Can we disregard some of these fields?

# Can we disregard category, should all be 100%. 
leaderboard_data['category']
leaderboard_data['region']
leaderboard_data['game']
leaderboard_data['timing']
leaderboard_data['values']

# that is not the runs-level dataframe
runs = leaderboard_data['runs']

# extracting specific values
runs[0]['run'].keys()

runs[0]['run']['times']['realtime_t']

# okay to save runs, not too nested
save_object(runs,'data-raw/src_runs.pkl')

