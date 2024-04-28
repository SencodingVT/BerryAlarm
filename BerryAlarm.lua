-- This is a template for a custom code extension for the Ironmon Tracker.
-- To use, first rename both this top-most function and the return value at the bottom: "CodeExtensionTemplate" -> "YourFileNameHere"
-- Then fill in each function you want to use with the code you want executed during Tracker runtime.
-- The name, author, and description attribute fields are used by the Tracker to identify this extension, please always include them.
-- You can safely remove unused functions; they won't be called.

local function BerryAlarm()
	local self = {}

	-- Define descriptive attributes of the custom extension that are displayed on the Tracker settings
	self.name = "Berry Alarm"
	self.author = "Sencoding"
	self.description = "This tells you if you're holding a berry questionably."
	self.version = "1.0"
	--self.url = "https://github.com/MyUsername/ExtensionRepo" -- Remove or set to nil if no host website available for this extension

	function contains(list, x)
		for k, v in pairs(list) do
			if v == x then return true end
		end
		return false
	end

	function containsKey(list, x)
		for k, v in pairs(list) do
			if k == x then return true end
		end
		return false
	end

	-- Executed when the user clicks the "Options" button while viewing the extension details within the Tracker's UI
	-- Remove this function if you choose not to include a way for the user to configure options for your extension
	-- NOTE: You'll need to implement a way to save & load changes for your extension options, similar to Tracker's Settings.ini file
	function self.configureOptions()
		-- [ADD CODE HERE]
	end

	-- Executed when the user clicks the "Check for Updates" button while viewing the extension details within the Tracker's UI
	-- Returns [true, downloadUrl] if an update is available (downloadUrl auto opens in browser for user); otherwise returns [false, downloadUrl]
	-- Remove this function if you choose not to implement a version update check for your extension
	-- function self.checkForUpdates()
	-- 	-- Replace "MyUsername" and "ExtensionRepo" in the below URL to match your repo url
	-- 	local versionCheckUrl = "https://api.github.com/repos/MyUsername/ExtensionRepo/releases/latest"
	-- 	-- Update the pattern below to match your version. You can check what this looks like by visiting the above url
	-- 	local versionResponsePattern = '"tag_name":%s+"%w+(%d+%.%d+)"'
	-- 	-- Replace "MyUsername" and "ExtensionRepo" in the below URL to match your repo url
	-- 	local downloadUrl = "https://github.com/MyUsername/ExtensionRepo/releases/latest"

	-- 	local isUpdateAvailable = Utils.checkForVersionUpdate(versionCheckUrl, self.version, versionResponsePattern, nil)
	-- 	return isUpdateAvailable, downloadUrl
	-- end

	-- Executed only once: When the extension is enabled by the user, and/or when the Tracker first starts up, after it loads all other required files and code
	function self.startup()
		-- set up the table for what maps/item should trigger the alarm based on the game

		if GameSettings.game == 3 then
			-- FRLG Settings
			self.mapIdMusicTable = {
				[110] = "viridian_rival_map",
				[81] = "cerulean_rival_map",
				[117] = "viridian_forest",
				[114] = "mt_moon",
				[115] = "mt_moon",
				[116] = "mt_moon",
				[119] = "ss_anne",
				[120] = "ss_anne",
				[121] = "ss_anne",
				[122] = "ss_anne",
				[123] = "ss_anne",
				[170] = "ss_anne",
				[171] = "ss_anne",
				[177] = "ss_anne",
				[178] = "ss_anne",
				[188] = "ss_anne",
				[154] = "rock_tunnel",
				[155] = "rock_tunnel",
				[128] = "rocket_hideout",
				[129] = "rocket_hideout",
				[130] = "rocket_hideout",
				[131] = "rocket_hideout",
				[225] = "rocket_elevator",
				[27] = "rocket_hideout",
				[161] = "pokemon_tower",
				[162] = "pokemon_tower",
				[163] = "pokemon_tower",
				[164] = "pokemon_tower",
				[165] = "pokemon_tower",
				[166] = "pokemon_tower",
				[167] = "pokemon_tower",
				[132] = "silph_co",
				[133] = "silph_co",
				[134] = "silph_co",
				[135] = "silph_co",
				[136] = "silph_co",
				[137] = "silph_co",
				[137] = "silph_co",
				[138] = "silph_co",
				[139] = "silph_co",
				[140] = "silph_co",
				[141] = "silph_co",
				[142] = "silph_co",
				[229] = "silph_elevator",
				[143] = "pokemon_mansion",
				[144] = "pokemon_mansion",
				[145] = "pokemon_mansion",
				[146] = "pokemon_mansion",
				[228] = "dojo",
				[28] = "pewter_gym",
				[12] = "cerulean_gym",
				[25] = "vermilion_gym",
				[15] = "celadon_gym",
				[20] = "fuschia_gym",
				[34] = "saffron_gym",
				[36] = "cinnabar_gym",
				[37] = "viridian_gym",
				[125] = "victory_road",
				[126] = "victory_road",
				[127] = "victory_road",
				[212] = "indigo_pokemon_center",
				[213] = "lorelei_room",
				[214] = "bruno_room",
				[215] = "agatha_room",
				[216] = "lance_room",
				[217] = "champ_room",
				[218] = "hof_room",
			}

			self.goodHeldItems = {
				"White Herb",
				"Cheri Berry",
				"Chesto Berry",
				"Pecha Berry",
				"Rawst Berry",
				"Persim Berry",
				"Lum Berry",
				"Sitrus Berry",
			}
		
		elseif GameSettings.game == 2 then 
			-- Emerald settings, needs to be filled out
			self.mapIdMusicTable = {}
			self.goodHeldItems = {}
		-- Ruby/Sapphire
		elseif GameSettings.game == 1 then 
			-- Ruby/Sapphire settings, needs to be filled out
			self.mapIdMusicTable = {}
			self.goodHeldItems = {}
		end
	end

	-- Executed only once: When the extension is disabled by the user, necessary to undo any customizations, if able
	function self.unload()
		-- [ADD CODE HERE]
	end

	-- Executed once every 30 frames, after most data from game memory is read in
	function self.afterProgramDataUpdate()
		-- [ADD CODE HERE]
	end

	-- Executed once every 30 frames, after any battle related data from game memory is read in
	function self.afterBattleDataUpdate()
		-- [ADD CODE HERE]
	end

	-- Executed once every 30 frames or after any redraw event is scheduled (i.e. most button presses)
	function self.afterRedraw()
		if Battle.inBattle then return end

		local mapId = TrackerAPI.getMapId()
		local onHeldItemMap = containsKey(self.mapIdMusicTable, mapId)

		if not onHeldItemMap then 
			local ownPokemon = Tracker.getPokemon(1, true)
			if ownPokemon ~= nil and ownPokemon.heldItem ~= nil then
				local heldItem = MiscData.Items[ownPokemon.heldItem]
				if contains(self.goodHeldItems, heldItem) then
					Drawing.drawText(2,2, 'Probably take off your ' .. heldItem .. '.', Theme.COLORS["Negative text"], Utils.calcShadowColor(Theme.COLORS["Lower box background"]))
				end
			end
		end
	end

	-- Executed before a button's onClick() is processed, and only once per click per button
	-- Param: button: the button object being clicked
	function self.onButtonClicked(button)
		-- [ADD CODE HERE]
	end

	-- Executed after a new battle begins (wild or trainer), and only once per battle
	function self.afterBattleBegins()
		-- [ADD CODE HERE]
	end

	-- Executed after a battle ends, and only once per battle
	function self.afterBattleEnds()
		-- [ADD CODE HERE]
	end

	-- [Bizhawk only] Executed each frame (60 frames per second)
	-- CAUTION: Avoid unnecessary calculations here, as this can easily affect performance.
	function self.inputCheckBizhawk()
		-- Uncomment to use, otherwise leave commented out
			-- local mouseInput = input.getmouse() -- lowercase 'input' pulls directly from Bizhawk API
			-- local joypadButtons = Input.getJoypadInputFormatted() -- uppercase 'Input' uses Tracker formatted input
		-- [ADD CODE HERE]
	end

	-- [MGBA only] Executed each frame (60 frames per second)
	-- CAUTION: Avoid unnecessary calculations here, as this can easily affect performance.
	function self.inputCheckMGBA()
		-- Uncomment to use, otherwise leave commented out
			-- local joypadButtons = Input.getJoypadInputFormatted()
		-- [ADD CODE HERE]
	end

	

	-- Executed each frame of the game loop, after most data from game memory is read in but before any natural redraw events occur
	-- CAUTION: Avoid code here if possible, as this can easily affect performance. Most Tracker updates occur at 30-frame intervals, some at 10-frame.
	function self.afterEachFrame()
		
	end

	return self
end
return BerryAlarm