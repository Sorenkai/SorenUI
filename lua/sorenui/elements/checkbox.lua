local PANEL = {}

local matTick = Material("materials/sorenui/tick.png", "smooth")



function PANEL:Init()
	self:SetText("")

	self.State = false
	self.AnimationController = 0
	self.Color = SorenUI.Theme.button
	self.Background = SorenUI.Theme.primary
	self.Font = "SorenUI.TextEntry"
    self.LabelText = "Global Ban"

    self.Label = self:Add("DLabel")
    self.Label:SetFont(self.Font)
    self.Label:SetText(self.LabelText)
    self.Label:Dock(LEFT)
    self.Label:DockMargin((self:GetWide()/2)+8, 0, 0, 0)
    self.Label:SizeToContents()
end

SorenUI:CreateFont("Checkbox", 10)
SorenUI:CreateFont("TextEntry", 20)

function PANEL:Paint(w, h)
	SorenUI:MaskInverse(function()
		surface.SetDrawColor(color_white)
		local x = h * (math.Clamp((self.AnimationController - 0.5) * 2, 0, 1))
		surface.DrawRect(h - x, 0, h, h)
	end, function()
		SorenUI:DrawRoundedBoxEx(6, 0, 0, h, h * 0.5, self.Color, true, true, false, false)
	end)
	SorenUI:MaskInverse(function()
		surface.SetDrawColor(color_white)
		local width = h * (math.Clamp(self.AnimationController * 2, 0, 1))
		surface.DrawRect(0, 0, width, h)
	end, function()
		SorenUI:DrawRoundedBoxEx(6, 0, h * 0.5, h, h * 0.5, self.Color, false, false, true, true)
	end)
	SorenUI:DrawRoundedBox(4, 2, 2, h - 4, h - 4, self.Background)

	SorenUI:MaskInverse(function()
		surface.SetDrawColor(color_white)
		local x = h * (math.Clamp((self.AnimationController - 1) * 2, 0, 1))
		surface.DrawRect(x, 0, h, h)
	end, function()
		surface.SetMaterial(matTick)
		surface.SetDrawColor(self.Color)
		surface.DrawTexturedRect(0, 0, h, h)
	end)

	if (self.Text) then
		local x = h + 5
		SorenUI:DrawShadowText(self.Text, self.Font, x, h / 2 - 1, self.TextColor or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, 125)
	end
end

function PANEL:SizeToContentsX()
	surface.SetFont(self.Font)
	local tw = surface.GetTextSize(self.Text or (self.LabelText) or "")

	self:SetWide(self:GetTall() + 5 + tw + self:GetWide())
end

function PANEL:SetState(state, instant)
	self.State = state

	if (state) then
		if (instant) then
			self:EndAnimations()
			self.AnimationController = 1.5
		else
			self:Lerp("AnimationController", 1.5, 0.4)
		end
	else
		self:EndAnimations()
		self.AnimationController = 0
	end
end

function PANEL:GetChecked()
	return self.State
end

function PANEL:OnStateChanged()
	-- for overwriting
end

function PANEL:SetFont(font)
    self.Font = font
end

function PANEL:SetLabelText(text)
    self.LabelText = text
end

function PANEL:Toggle()
	self:SetState(!self.State)
	self:OnStateChanged(self.State)
end

vgui.Register("SorenUI.Checkbox", PANEL, "DButton")
