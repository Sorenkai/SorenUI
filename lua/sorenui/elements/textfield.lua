local PANEL = {}

AccessorFunc(PANEL, "m_backgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "m_rounded", "Rounded")
AccessorFunc(PANEL, "m_placeholder", "Placeholder")
AccessorFunc(PANEL, "m_textColor", "TextColor")
AccessorFunc(PANEL, "m_placeholderColor", "PlaceholderColor")
AccessorFunc(PANEL, "m_iconColor", "IconColor")

SorenUI:CreateFont("TextEntry", 20)

function PANEL:Init()
	self:SetBackgroundColor(SorenUI.Theme.primary)
	self:SetRounded(6)
	self:SetPlaceholder("")
	self:SetTextColor(SorenUI.Theme.button)
	self:SetPlaceholderColor(SorenUI.Theme.placeholder)
	self:SetIconColor(self:GetTextColor())


    self.textentry = self:Add("DTextEntry")
    self.textentry:Dock(FILL)
    self.textentry:DockMargin(8, 8, 8, 8)
	self.textentry:SetFont("SorenUI.TextEntry")

    self.textentry.Paint = function(pnl, w, h)
        local col = self:GetTextColor()

        pnl:DrawTextEntryText(col, col, col)
        if (#pnl:GetText() == 0) then
			draw.SimpleText(self:GetPlaceholder() or "", pnl:GetFont(), 0, pnl:IsMultiline() and 8 or h / 2, self:GetPlaceholderColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

    end

end


function PANEL:SetMultiLine(state)
	self:SetMultiline(state)
	self.textentry:SetMultiline(state)
end

function PANEL:SetFont(str)
	self.textentry:SetFont(str)
end

function PANEL:GetText()
	return self.textentry:GetText()
end

function PANEL:SetText(str)
	self.textentry:SetText(str)
end

function PANEL:OnMousePressed()
	self.textentry:RequestFocus()
end

function PANEL:SetNumeric()
	self.textentry:SetNumeric(true)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(self:GetRounded(), 0, 0, w, h, self:GetBackgroundColor())
end


vgui.Register("SorenUI.Textfield", PANEL)