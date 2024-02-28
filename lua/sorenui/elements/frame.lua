local PANEL = {}
local matCloseBtn = Material("sorenui/closebutton.png")
SorenUI:CreateFont("Title", 28)

function PANEL:Init()
    self.header = self:Add("Panel")
    self.header:Dock(TOP)
    self.header.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, SorenUI.Theme.primary, true, true, false ,false)
    end

    self.header.closeBtn = self.header:Add("DButton")
    self.header.closeBtn:Dock(RIGHT)
    self.header.closeBtn:SetText("")
    self.header.closeBtn.DoClick = function(pnl)
        self:Remove()
    end
    self.header.closeBtn.margin = 16
    self.header.closeBtn.Paint = function(pnl, w, h)
        local margin = self.header.closeBtn.margin
        surface.SetDrawColor(SorenUI.Theme.close)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(SorenUI.Theme.button)
        surface.SetMaterial(matCloseBtn)
        surface.DrawTexturedRect(margin, margin, w - (margin*2), h - (margin*2))
    end


    self.header.title = self.header:Add("DLabel")
    self.header.title:SetFont("SorenUI.Title")
    self.header.title:SetTextColor(SorenUI.Theme.selected)
    self.header.title:Dock(LEFT)
    self.header.title:SetTextInset(16,0)
    
end

function PANEL:SetTitle(title)
    self.header.title:SetText(title)
    self.header.title:SizeToContents()
end

function PANEL:PerformLayout(w, h)
    self.header:SetTall(SorenUI.UISizes.Header.height)
    self.header.closeBtn:SetWide(self.header:GetTall())
end

function PANEL:Paint(w, h)
    local aX, aY = self:LocalToScreen()

    BSHADOWS.BeginShadow()
        draw.RoundedBox(6, aX, aY, w, h, SorenUI.Theme.background) 
    BSHADOWS.EndShadow(1, 2, 2)
end

vgui.Register("SorenUI.Frame", PANEL, "EditablePanel")