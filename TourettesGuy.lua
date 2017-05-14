SLASH_TourettesGuy1 = '/tg'
SLASH_TourettesGuy2 = '/tourettesguy'

TG_ENABLED = true;
local castingSpell = "";

function TGOrangeText(message)
	return "|cFFFF6600" .. message .. "|r";
end

function TGGreenText(message)
	return "|cFF00CC00" .. message .. "|r";
end

function TGRedText(message)
	return "|cFFFF0000" .. message .. "|r";
end

function TGPrint(message)
		print(TGOrangeText("[TourettesGuy]") .. " " .. message);
end

function TGEnable()
	if not TG_ENABLED then
		TG_ENABLED = true;
		TGPrint("Sounds have been " .. TGGreenText("enabled") .. ".");
		TGPlay("yes");
	else
		TGPrint("Sounds are already enabled.");
		TGPlay("damnit");
  end
end

function TGDisable()
	if TG_ENABLED then
		TG_ENABLED = false;
		TGPrint("TourettesGuy sounds have been " .. TGRedText("disabled") .. ".");
	else
		print("TourettesGuy sounds are already disabled.");
	end
end

function TGSlashCmd(cmd, self)
	if cmd == "on" then
    	TGEnable();
	elseif cmd == "off" then
			TGDisable();
	elseif cmd == "toggle" then
			if TG_ENABLED then
				TGDisable();
			else
				TGEnable();
			end
	elseif cmd == "help" then
		TGPrint("/tg on  - Enables sounds.");
		TGPrint("/tg off  - Disables sounds.");
		TGPrint("/tg toggle  - Enables or disables sounds depending on previous state.");
		TGPrint("/tg help  - Prints a list of valid commands.")
	else
		TGPrint("Unknown command: " .. cmd .. ". Enter " .. TGOrangeText("/tg help") .. " for a list of commands.");
	end
end

SlashCmdList["TourettesGuy"] = TGSlashCmd

-- Helper function to play sounds from TourettesGuy AddOn directory
function TGPlay(file)
	if TG_ENABLED then
		PlaySoundFile("Interface\\AddOns\\TourettesGuy\\sounds\\" .. file .. ".ogg", "Master");
	end
end

local function TGPlayRandomCuss()
	local rnd = math.random(1,8);

	if rnd == 1 then
		TGPlay("piss");
	elseif rnd == 2 then
		TGPlay("ass");
	elseif rnd == 3 then
		TGPlay("bitch");
	elseif rnd == 4 then
		TGPlay("bitch2");
	elseif rnd == 5 then
		TGPlay("biitch");
	elseif rnd == 6 then
		TGPlay("damnit");
	elseif rnd == 7 then
		TGPlay("fuckyou");
	elseif rnd == 8 then
		TGPlay("shit");
	end
end

function TGPlayerHealthPercentage()
	return (UnitHealth("Player") / UnitHealthMax("Player")) * 100;
end

local function TGCombatLogEventUnfiltered(timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceRaidFlags,destGUID,destFlags,destRaidFlags,...)
  -- Keep track of damage multipliers on the target
  if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" then
    local _,spellId,spellName = ...

  end
end

local function TGDidEnterCombat()

end

local function TGDidLeaveCombat()
	if TGPlayerHealthPercentage() <= 20 then
		TGPlay("thatsmyass");
	end
end

local function TGPlayerDead()
	local rnd = math.random(1,5);

	if rnd == 1 then
		TGPlay("bobsaget");
	elseif rnd == 2 then
		TGPlay("wasteofshit");
	elseif rnd == 3 then
		TGPlay("holyshit");
	elseif rnd == 4 then
		TGPlay("holyfuck");
	elseif rnd == 5 then
		TGPlay("fuuck");
	end
end

local function TGUnitCombat(uid, action, blow, damage, school)
end

local function TGSpellCastStart(unit, name)
	if unit == "player" then
		local name, subText, text, texture, startTime, endTime = UnitCastingInfo("player")
		local castTime = (endTime - startTime) / 1000;

		if castTime >= 2.5 then
			castingSpell = name;
			TGPlay("youu");
		end
	end
end

local function TGSpellCastSucceeded(unit, name)
	if unit == "player" and castingSpell == name then
		isCasting = false;
		local rnd = math.random(1,2)

		if rnd == 1 then
			TGPlay("bitch2");
		elseif rnd == 2 then
			TGPlay("faggot");
		end
	end
end

local function TGChatMessageReceived(message, ...)
	if string.find(message, "total") then
		TGPlay("total");
	end
end

local function TGPrintWelcomeMessage()
	local TG_STATUS = "";
	if TG_ENABLED then
		TG_STATUS = TGGreenText("enabled");
	else
		TG_STATUS = TGRedText("disabled");
	end
	TGPrint("Loaded with sounds " .. TG_STATUS .. ". Enter " .. TGOrangeText("/tg help") .. " for a list of commands.");
end

local function TGAddonLoaded(name)
	if name == "TourettesGuy" then
		TGPrintWelcomeMessage();
	end
end

local function TGReadyCheckConfirm(uid, ready)
	if ready == 0 then
		TGPlayRandomCuss();
	end
end

local function TGOnEvent(self, event, ...)
  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    TGCombatLogEventUnfiltered(...)
	elseif event == "PLAYER_REGEN_DISABLED" then
		TGDidEnterCombat()
  elseif event == "PLAYER_REGEN_ENABLED" then
    TGDidLeaveCombat()
	elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		TGPlay("cantdoshit");
	elseif event == "PLAYER_DEAD" then
		TGPlayerDead();
	elseif event == "UNIT_COMBAT" then
		-- print(...);
		TGUnitCombat(...);
	elseif event == "PLAYER_CONTROL_GAINED" then
		-- TODO: Play something else here
		-- TGPlay("yes");
	elseif event == "PLAYER_CONTROL_LOST" then
		TGPlay("duhh");
	elseif event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM" or event == "CHAT_MSG_YELL" or event == "CHAT_MSG_SAY" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_GUILD" then
		TGChatMessageReceived(...)
	elseif event == "ADDON_LOADED" then
		TGAddonLoaded(...)
	elseif event == "LFG_PROPOSAL_FAILED" then
		TGPlayRandomCuss();
	elseif event == "LFG_PROPOSAL_SHOW" then
		TGPlay("hurryup");
	elseif event == "DELETE_ITEM_CONFIRM" then
		TGPlay("youpieceofshit");
	elseif event == "READY_CHECK_CONFIRM" then
		TGReadyCheckConfirm(uid, ready);
	elseif event == "PLAYER_LEVEL_UP" then
		TGPlay("ahwoahshit");
	elseif event == "MINIMAP_PING" then
		TGPlayRandomCuss();
	elseif event == "PLAYER_LOGOUT" then
		--TGPlay("toopissedtogiveashit");
	elseif event == "RESURRECT_REQUEST" then
		TGPlay("bitchiloveyou");
	elseif event == "UNIT_SPELLCAST_START" then
		TGSpellCastStart(...);
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		TGSpellCastSucceeded(...);
  end
end

-- Main Frame
local TG_FRAME = CreateFrame("frame")
TG_FRAME:SetScript("OnEvent", TGOnEvent)
TG_FRAME:RegisterEvent("ADDON_LOADED")
TG_FRAME:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
TG_FRAME:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
TG_FRAME:RegisterEvent("PLAYER_REGEN_ENABLED")
TG_FRAME:RegisterEvent("PLAYER_DEAD")
TG_FRAME:RegisterEvent("UNIT_COMBAT")
TG_FRAME:RegisterEvent("PLAYER_CONTROL_GAINED")
TG_FRAME:RegisterEvent("PLAYER_CONTROL_LOST")
TG_FRAME:RegisterEvent("CHAT_MSG_CHANNEL")
TG_FRAME:RegisterEvent("CHAT_MSG_WHISPER")
TG_FRAME:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
TG_FRAME:RegisterEvent("CHAT_MSG_YELL")
TG_FRAME:RegisterEvent("CHAT_MSG_SAY")
TG_FRAME:RegisterEvent("CHAT_MSG_RAID")
TG_FRAME:RegisterEvent("CHAT_MSG_PARTY")
TG_FRAME:RegisterEvent("CHAT_MSG_GUILD")
TG_FRAME:RegisterEvent("LFG_PROPOSAL_SHOW")
TG_FRAME:RegisterEvent("LFG_PROPOSAL_FAILED")
TG_FRAME:RegisterEvent("DELETE_ITEM_CONFIRM")
TG_FRAME:RegisterEvent("READY_CHECK_CONFIRM")
TG_FRAME:RegisterEvent("PLAYER_LEVEL_UP")
TG_FRAME:RegisterEvent("MINIMAP_PING")
TG_FRAME:RegisterEvent("PLAYER_LOGOUT")
TG_FRAME:RegisterEvent("RESURRECT_REQUEST")
TG_FRAME:RegisterEvent("UNIT_SPELLCAST_START")
TG_FRAME:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
