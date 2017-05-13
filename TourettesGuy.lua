SLASH_TourettesGuy1 = '/tg'
SLASH_TourettesGuy2 = '/tourettesguy'


function TGEnable()
	enabled = true;
	print("TourettesGuy sounds have been enabled.");
end

function TGDisable()
	enabled = false;
	print("TourettesGuy sounds have been disabled.");
end

function SlashCmd(cmd, self)
	if (cmd == "on") then
    	TGEnable();
	elseif (cmd == "off") then
			TGDisable();
	elseif (cmd == "toggle") then
			if enabled == true then
				TGDisable();
			else
				TGEnable();
			end
	end
end

SlashCmdList["TourettesGuy"] = SlashCmd

-- Helper function to play sounds from TourettesGuy AddOn directory
function TGPlay(file)
	PlaySoundFile("Interface\\AddOns\\TourettesGuy\\sounds\\" .. file .. ".ogg", "Master");
end

local function TGCombatLogEventUnfiltered(timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceRaidFlags,destGUID,destFlags,destRaidFlags,...)
  -- Keep track of damage multipliers on the target
  if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" then
    local _,spellId,spellName = ...
    -- do things
  end
end

local function TGDidLeaveCombat()

end

local function TGOnLoad(self)
	TGPlay("yes");
end

local function TGOnEvent(self, event, ...)
  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    TGCombatLogEventUnfiltered(...)
  elseif event == "PLAYER_REGEN_ENABLED" then
    TGDidLeaveCombat()
	elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		TGPlay("cantdoshit");
  end
end

-- Frame
local TG_FRAME = CreateFrame("frame")
TG_FRAME:SetScript("OnLoad", TGOnLoad)
TG_FRAME:SetScript("OnEvent", TGOnEvent)
TG_FRAME:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
TG_FRAME:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
TG_FRAME:RegisterEvent("PLAYER_REGEN_ENABLED")

print("TourettesGuy loaded.")
