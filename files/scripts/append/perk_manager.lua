function HasSettingFlag(name)
    return ModSettingGet(name) or false
end

-- Prevent disabled perks from spawning

local _perk_get_spawn_order = perk_get_spawn_order
function perk_get_spawn_order(ignore_these_)
    for k, v in pairs(perk_list) do
        if (HasSettingFlag(v.id .. "_dapm_disabled")) then
            if (ignore_these_ == nil) then ignore_these_ = {} end
            table.insert(ignore_these_, v.id)
        end
    end
    return _perk_get_spawn_order(ignore_these_)
end

local _perk_spawn = perk_spawn
function perk_spawn( x, y, perk_id, dont_remove_other_perks_ )
    if (HasSettingFlag(perk_id .. "_dapm_disabled")) then
        print("Tried to spawn disabled perk " .. perk_id)
        return
    end
    return _perk_spawn(x, y, perk_id, dont_remove_other_perks_)
end