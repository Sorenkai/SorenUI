local PANEL = {}

function PANEL:Init()
    self.button = self:Add("DButton")
    self.button:Dock(BOTTOM)
    self.button:DockMargin(150, 40, 150, 20)
    self.button:SetTall(40)
    self.button:SetWide(80)
    self.button:SetText(SorenUI.Config.Lang.sync)
    self.button:SetFont("SorenUI.Button")
    self.button:SetTextColor(SorenUI.Theme.button)
    
    local animSpeed = 2
    local animStatus = 0
    local animSpeed = 4
    local animStatus = 0
    local center = 0
    self.button.Paint = function(pnl, w, h)
        draw.RoundedBox(2, 0, 0, w, h, SorenUI.Theme.secondary)
        draw.RoundedBox(2, 2, 2, w-4, h-4, SorenUI.Theme.primary)        
        center = w/2
        if pnl:IsHovered() then
            animStatus = math.Clamp(animStatus + animSpeed * FrameTime(), 0, 1)
        else
            animStatus = math.Clamp(animStatus - animSpeed * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(SorenUI.Theme.selected)
        surface.DrawRect(center - (w * animStatus) / 2, h-2, w * animStatus, 2)
    end
    self.button.DoClick = function()
        draw.RoundedBox(2, 0, 0, self:GetWide(), self:GetTall(), color_white)
        RunConsoleCommand("ember_sync")
    end
end

vgui.Register("SorenUI.Sync", PANEL)