dofile("data/scripts/lib/mod_settings.lua")

local mod_id = "da_perk_manager"
mod_settings_version = 1
mod_settings = {
	{
		id = "sort_perks",
		ui_name = "Sort Perks by Name",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME
	},
	{
		ui_fn = mod_setting_vertical_spacing,
		not_setting = true,
	},
}


function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id )
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function HasSettingFlag(name)
    return ModSettingGet(name) or false
end

function AddSettingFlag(name)
    ModSettingSet(name, true)
end

function RemoveSettingFlag(name)
    ModSettingRemove(name)
end

function SortPerks(a,b)
	return GameTextGetTranslatedOrNot(a.ui_name) < GameTextGetTranslatedOrNot(b.ui_name)
end

function ModSettingsGui( gui, in_main_menu )
	screen_width, screen_height = GuiGetScreenDimensions(gui)

	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )

	local id = 356186
	local function new_id() id = id + 1; return id end

	GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween )

	if(in_main_menu) then
		GuiText( gui, 0, 0, "You must start the game to configure modded perks." )
	end
	perk_cache = dofile("mods/da_perk_manager/cache/perk_cache.lua") or {}

	GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )
	if GuiButton( gui, new_id(), 0, 0, "Enable All" )then
		for k, v in pairs(perk_cache) do
			RemoveSettingFlag(v.id .. "_dapm_disabled")
		end
	end
	GuiText( gui, 0, 0, " " )
	if GuiButton( gui, new_id(), 0, 0, "Disable All" )then
		for k, v in pairs(perk_cache) do
			AddSettingFlag(v.id .. "_dapm_disabled")
		end
	end
	GuiLayoutEnd(gui)
	
	GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )
	GuiText( gui, 0, 0, "$menu_modsettings_changes_restart" )
	GuiLayoutEnd(gui)

	local list_of_perks = perk_cache
	if ModSettingGet("da_perk_manager.sort_perks") then
		table.sort(list_of_perks, SortPerks)
	end

	for i = 0, 1 do
		GuiText( gui, 0, 3, "Perks"..(i == 1 and " not" or "").." in pool")
		GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )
		local j = 0
		for k, v in pairs(list_of_perks) do
			if ((i == 0 and not v.not_in_default_perk_pool) or (i == 1 and v.not_in_default_perk_pool)) then
				if (math.fmod(j,14) == 0) then
					GuiLayoutEnd(gui)
					GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )
				end
				j = j + 1

				local alpha = 1;
				local name = GameTextGetTranslatedOrNot(v.ui_name) .. "\n" .. GameTextGetTranslatedOrNot(v.ui_description)
				if (HasSettingFlag(v.id .. "_dapm_disabled")) then
					name = name .. "\nDisabled"
					alpha = 0.25
				end

				GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
				if (HasSettingFlag(v.id .. "_dapm_disabled")) then
					GuiImage( gui, new_id(), 2, -2, "data/ui_gfx/inventory/inventory_box_inactive_overlay.png", 1, 1, 0 )
				else
					GuiImage( gui, new_id(), 2, -2, "data/ui_gfx/inventory/full_inventory_box.png", 1, 1, 0 )
				end

				GuiZSetForNextWidget(gui, -100)
				GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
				GuiImage( gui, new_id(), -20, 0, v.perk_icon, alpha, 1, 0 )

				if GuiImageButton( gui, new_id(), -18, 0, "", "mods/da_perk_manager/files/ui_gfx/blank.png" ) then
					if (HasSettingFlag(v.id .. "_dapm_disabled")) then
						RemoveSettingFlag(v.id .. "_dapm_disabled")
					else
						AddSettingFlag(v.id .. "_dapm_disabled")
					end
				end

				if (HasSettingFlag(v.id .. "_dapm_disabled")) then
					GuiTooltip( gui, name, "Click to enable" );
					GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
					GuiZSetForNextWidget(gui, -101)
					GuiImage( gui, new_id(), -18, 0, "mods/da_perk_manager/files/ui_gfx/disabled.png", 1, 1, 0 )
				else
					GuiTooltip( gui, name, "Click to disable" );
				end
			end
		end
		GuiLayoutEnd(gui)
	end
	for i = 1, 5 do
		GuiText( gui, 0, 0, "" )
	end
end