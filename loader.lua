local SCRIPTS = {
    [2682938349] = "https://api.luarmor.net/files/v4/loaders/457b74fb02beafe37cb808f6fa2be7f8.lua" -- Wild Horse Islands
}

local GAME_ID = game.GameId
local SCRIPT_URL = SCRIPTS[GAME_ID]

loadstring(game:HttpGet(SCRIPT_URL))()
