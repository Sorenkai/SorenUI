local PANEL = {}

function PANEL:Init()
    self.navbar = self:Add("SorenUI.Navbar")
    self.navbar:Dock(TOP)
    self.navbar:SetBody(self)
    self.navbar:AddTab(SorenUI.Config.Lang.ban, "SorenUI.Ban")
    self.navbar:AddTab(SorenUI.Config.Lang.unban, "SorenUI.Unban")
    self.navbar:AddTab(SorenUI.Config.Lang.sync, "SorenUI.Sync")

    self.navbar:SetActive(1)
end

function PANEL:PerformLayout(w, h)
    self.BaseClass.PerformLayout(self,w,h)

    self.navbar:SetTall(SorenUI.UISizes.Navbar.height)    
end

vgui.Register("SorenUI.Menu", PANEL, "SorenUI.Frame")

SorenUI.UI.Frame = function()
    local frame = vgui.Create("SorenUI.Menu")
    frame:SetTitle(SorenUI.Config.Lang.title)
    frame:SetSize(0 ,0)
    frame:Center()
    local isAnimating = true
    frame:SizeTo(500, 400, 1.8, 0, 0.1, function()
        isAnimating = false
    end)
    frame.OnSizeChanged = function(me, w, h)
        if isAnimating then
            me:Center()
        end
    end
    frame:MakePopup()
end

concommand.Add("ember_ui", SorenUI.UI.Frame)