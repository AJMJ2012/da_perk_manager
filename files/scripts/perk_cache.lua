dofile("data/scripts/lib/utilities.lua")
dofile("mods/da_perk_manager/lib/lib.lua")
dofile("data/scripts/perks/perk.lua")

-- Quick and dirty cache
perk_cache = {}
-- Remove duplicates
for k, v in pairs(perk_list) do
    if (not GetTableIndex(perk_cache, v.id)) then
        table.insert(perk_cache, v)
    end
end
ModTextFileSetContent("mods/da_perk_manager/cache/perk_cache.lua", "return " .. SerializeTable(perk_cache))