-- Combo Points for Tukui 14+

local T, C, L = unpack(select(2, ...))
local parent = TukuiTarget
local stick

if T.myclass ~= "ROGUE" and T.myclass ~= "DRUID" then return end

if T.myclass == "ROGUE" and C.unitframes.movecombobar then
	parent = TukuiPlayer
	stick = true
end

if not parent or C.unitframes.classiccombo then return end

local shadow = parent.shadow
local buffs = parent.Buffs
local MAX_COMBO_POINTS = MAX_COMBO_POINTS

local Colors = { 
	[1] = {.69, .31, .31, 1},
	[2] = {.65, .42, .31, 1},
	[3] = {.65, .63, .35, 1},
	[4] = {.46, .63, .35, 1},
	[5] = {.33, .63, .33, 1},
}

local function UpdateBuffs(self, points)
	if stick then return end
	
	if points and points > 0 then
		self:Show()
		
		-- update player frame shadow
		if shadow then
			shadow:Point("TOPLEFT", -4, 12)
		end
		
		-- update Y position of buffs
		if buffs then 
			buffs:ClearAllPoints() 
			buffs:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", -2, 9)
		end
	else
		self:Hide()
		
		-- update player frame shadow
		if shadow then
			shadow:Point("TOPLEFT", -4, 4)
		end
		
		-- update Y position of buffs
		if buffs then 
			buffs:ClearAllPoints() 
			buffs:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", -2, 5)
		end
	end
end

local function OnUpdate(self)
	local points
	
	if UnitHasVehicleUI("player") then
		points = GetComboPoints("vehicle", "target")
	else
		points = GetComboPoints("player", "target")
	end

	if points then
		-- update combos display
		for i = 1, MAX_COMBO_POINTS do
			if i <= points then
				self[i]:SetAlpha(1)
			else
				self[i]:SetAlpha(.2)
			end
		end
	end

	UpdateBuffs(self, points)
end

-- create the bar
local TukuiCombo = CreateFrame("Frame", nil, parent)
TukuiCombo:CreatePanel("Default", parent:GetWidth() - 20, 9, "LEFT", parent.Health, "TOPLEFT", 10, 1)
if T.lowversion then
	TukuiCombo:Width(150)
end
TukuiCombo:SetFrameLevel(parent:GetFrameLevel() + 2)
TukuiCombo:SetFrameStrata(parent:GetFrameStrata())
TukuiCombo.shadow:SetFrameStrata("BACKGROUND")

TukuiCombo:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiCombo:RegisterEvent("UNIT_COMBO_POINTS")
TukuiCombo:RegisterEvent("PLAYER_TARGET_CHANGED")
TukuiCombo:SetScript("OnEvent", OnUpdate)
TukuiCombo:Show()

-- create combos
for i = 1, 5 do
	TukuiCombo[i] = CreateFrame("StatusBar", "TukuiComboBar"..i, TukuiCombo)
	TukuiCombo[i]:Height(TukuiCombo:GetHeight() - 4)
	TukuiCombo[i]:SetStatusBarTexture(unpack(T.Textures.statusBars))
	TukuiCombo[i]:GetStatusBarTexture():SetHorizTile(false)
	TukuiCombo[i]:SetFrameLevel(TukuiCombo:GetFrameLevel())
	TukuiCombo[i]:SetFrameStrata(TukuiCombo:GetFrameStrata())
	TukuiCombo[i].bg = TukuiCombo[i]:CreateTexture(nil, 'BORDER')
	TukuiCombo[i].bg:SetAllPoints(TukuiCombo[i])
	TukuiCombo[i].bg:SetTexture(unpack(T.Textures.statusBars))					
	TukuiCombo[i].bg:SetAlpha(.15)
	TukuiCombo[i]:SetStatusBarColor(unpack(Colors[i]))
	TukuiCombo[i].bg:SetTexture(unpack(Colors[i]))
	
	if i == 1 then
		TukuiCombo[i]:Point("TOPLEFT", TukuiCombo, 2, -2)
		TukuiCombo[i]:Width(TukuiCombo:GetWidth() / 5)
	else
		TukuiCombo[i]:Point("LEFT", TukuiCombo[i-1], "RIGHT", 1, 0)
		TukuiCombo[i]:Width(TukuiCombo:GetWidth() / 5 - 2)
	end
end