MinimapAPI = require("rune_rooms_scripts.lib.minimapapi.minimapapi")
MinimapAPI.isRepentance = REPENTANCE -- REPENTANCE variable can be altered by any mod, so we save it early so later changes dont affect it

require("rune_rooms_scripts.lib.minimapapi.version")

require("rune_rooms_scripts.lib.minimapapi.data")
require("rune_rooms_scripts.lib.minimapapi.config")
require("rune_rooms_scripts.lib.minimapapi.main")
require("rune_rooms_scripts.lib.minimapapi.noalign")
if MinimapAPI.isRepentance then
    require("rune_rooms_scripts.lib.minimapapi.custom_icons")
end
require("rune_rooms_scripts.lib.minimapapi.custom_mapflags")
require("rune_rooms_scripts.lib.minimapapi.nicejourney")
require("rune_rooms_scripts.lib.minimapapi.config_menu")
require("rune_rooms_scripts.lib.minimapapi.dsscompat")
require("rune_rooms_scripts.lib.minimapapi.testfunctions")


Isaac.ConsoleOutput("MinimapAPI "..MinimapAPI.MajorVersion.."."..MinimapAPI.MinorVersion.." ("..MinimapAPI.BranchVersion..") loaded.\n")

return MinimapAPI
