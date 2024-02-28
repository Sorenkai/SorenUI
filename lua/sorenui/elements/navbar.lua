local PANEL = {}

AccessorFunc(PANEL, "m_body", "Body")

SorenUI:CreateFont("Button", 24)

function PANEL:Init()
    self.buttons = {}
    self.panels = {}

end

function PANEL:AddTab(name, panel)
    local i = table.Count(self.buttons) + 1 // index of the tab to insert
    self.buttons[i] = self:Add("DButton")
    local btn = self.buttons[i]
    btn.id = i
    
    btn:Dock(LEFT)
    btn:SetText(name)
    btn:SetFont("SorenUI.Button")
    btn:SetTextColor(SorenUI.Theme.button)
    local animSpeed = 4
    local animStatus = 0
    local center = 0
    btn.Paint = function(pnl, w, h)
        center = w/2
        if (self.active == pnl.id) then
            surface.SetDrawColor(SorenUI.Theme.selected)
            surface.DrawRect(0, h-2, w, 2)
        else
            if(pnl:IsHovered() and self.active != pnl.id) then
                pnl:SetTextColor(SorenUI.Theme.highlighted)
            else
                pnl:SetTextColor(SorenUI.Theme.button)
            end
        end

        if (pnl:IsHovered() and self.active != pnl.id) then
            animStatus = math.Clamp(animStatus + animSpeed * FrameTime(), 0, 1)
        else
            animStatus = math.Clamp(animStatus - animSpeed * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(SorenUI.Theme.selected)
        surface.DrawRect(center - (w * animStatus) / 2, h-2, w * animStatus, 2)

    end

    btn:SizeToContentsX(48)
    btn.DoClick = function(pnl)
        self:SetActive(pnl.id)
    end

    self.panels[i] = self:GetBody():Add(panel or "EditablePanel")
    panel = self.panels[i]
    panel:Dock(FILL)
    panel:SetVisible(false)

end

function PANEL:SetActive(id)
    local btn = self.buttons[id]
    if (!IsValid(btn)) then return end
    local activeBtn = self.buttons[self.active]
    if( IsValid(activeBtn)) then 
        activeBtn:SetTextColor(SorenUI.Theme.button)    
        
        local activePnl = self.panels[self.active]
        if(IsValid(activePnl)) then
            activePnl:SetVisible(false)
        end
    end

    self.active = id

    btn:SetTextColor(SorenUI.Theme.selected)
    local panel = self.panels[id]
    panel:SetVisible(true)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(SorenUI.Theme.secondary)
    surface.DrawRect(0 ,0 ,w ,h )
end

vgui.Register("SorenUI.Navbar", PANEL)