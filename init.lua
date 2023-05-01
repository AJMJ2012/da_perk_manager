ModLuaFileAppend("data/scripts/perks/perk.lua", "mods/da_perk_manager/files/scripts/append/perk_manager.lua")

function OnModPostInit() -- Called after mod content is added
    dofile("mods/da_perk_manager/files/scripts/perk_cache.lua")
end