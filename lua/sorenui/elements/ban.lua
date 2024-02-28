local PANEL = {}


function PANEL:Init()
    
    self.playerText = self:Add("SorenUI.Textfield")
    self.playerText:Dock(TOP)
    self.playerText:DockMargin(40, 40, 40, 0)
    self.playerText:SetTall(40)
    self.playerText:SetWide(150)
    self.playerText:SetPlaceholder(SorenUI.Config.Lang.enterPlayer)


    self.reasonText = self:Add("SorenUI.Textfield")
    self.reasonText:Dock(TOP)
    self.reasonText:DockMargin(40, 20, 40, 0)
    self.reasonText:SetTall(40)
    self.reasonText:SetWide(150)
    self.reasonText:SetPlaceholder(SorenUI.Config.Lang.enterReason)

    self.button = self:Add("DButton")
    self.button:Dock(BOTTOM)
    self.button:DockMargin(150, 40, 150, 20)
    self.button:SetTall(40)
    self.button:SetWide(50)
    self.button:SetText(SorenUI.Config.Lang.ban)
    self.button:SetFont("SorenUI.Button")
    self.button:SetTextColor(SorenUI.Theme.button)


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
        
        local plyName = self.playerText:GetText()
        local reason = self.reasonText:GetText()
        local duration = self.durationText:GetText()
        local globalBan = self.globalBan:GetChecked()
        if plyName == "" then return end
        
        if duration == "" then
            duration = 0
        end
        
        ply = SorenUI:FindPly(plyName)
        if(!IsValid(ply)) then
            LocalPlayer():ChatPrint("Player not found")
            return
        end

        self:GetParent():Remove()

        local confirmPanel = vgui.Create("SorenUI.Frame")
        confirmPanel:SetSize(300, 300)
        confirmPanel:SetTitle(SorenUI.Config.Lang.confirmBanTitle)
        confirmPanel:Center()
        confirmPanel:MakePopup()
        confirmPanel.Paint = function(pnl, w, h)
            
            Derma_DrawBackgroundBlur(pnl, pnl.m_fCreateTime)
            draw.RoundedBoxEx(6, 0, 0, w, h, SorenUI.Theme.primary, true, true, true, true)
            draw.RoundedBoxEx(6, 0, 24, w, h, SorenUI.Theme.background, false, false, true, true)     
        end
        
        local confirmUserText = vgui.Create("DLabel", confirmPanel)
        confirmUserText:SetFont("SorenUI.TextEntry")
        confirmUserText:SetText("Are you sure you want to ban: \n" .. ply:Nick())
        confirmUserText:SetWrap(true) -- Enable text wrapping
        confirmUserText:SetAutoStretchVertical(true) -- Enable vertical stretching
        confirmUserText:Dock(TOP)
        confirmUserText:DockMargin(10, 20, 10, 0)

        local confirmReasonText = vgui.Create("DLabel", confirmPanel)
        confirmReasonText:SetFont("SorenUI.TextEntry")
        confirmReasonText:SetText("For reason: \n" .. reason)
        confirmReasonText:SetWrap(true) -- Enable text wrapping
        confirmReasonText:SetAutoStretchVertical(true) -- Enable vertical stretching
        confirmReasonText:Dock(TOP)
        confirmReasonText:DockMargin(10, 20, 10, 0)

        local confirmDurationText = vgui.Create("DLabel", confirmPanel)
        confirmDurationText:SetFont("SorenUI.TextEntry")
        if duration == 0 then
            confirmDurationText:SetText("Permanently?")
        else
            confirmDurationText:SetText("For a duration of: \n" .. duration .. " minutes")
        end
        confirmDurationText:SetWrap(true) -- Enable text wrapping
        confirmDurationText:SetAutoStretchVertical(true) -- Enable vertical stretching
        confirmDurationText:Dock(TOP)
        confirmDurationText:DockMargin(10, 20, 10, 0)

        local confirmButton = vgui.Create("DButton", confirmPanel)
        confirmButton:Dock(BOTTOM)
        confirmButton:DockMargin(10, 0, 10, 10)
        confirmButton:SetTall(40)
        confirmButton:SetText(SorenUI.Config.Lang.confirmText)
        confirmButton:SetFont("SorenUI.Button")
        confirmButton:SetTextColor(SorenUI.Theme.button)

        
        confirmButton.Paint = function(pnl, w, h)
            draw.RoundedBox(2, 0, 0, w, h, SorenUI.Theme.confirm)
        end
        if globalBan then globalBan = "true" else globalBan = nil end
        confirmButton.DoClick = function()
            RunConsoleCommand("ember_ban", ply:SteamID64(), duration, reason, globalBan)
            confirmPanel:Remove()
        end
    end


    self.durationText = self:Add("SorenUI.Textfield")
    self.durationText:SetPos(40, 160)
    self.durationText:SetTall(40)
    self.durationText:SetWide(170)
    self.durationText:SetPlaceholder(SorenUI.Config.Lang.enterDuration)
    self.durationText:SetNumeric(true)

    self.globalBan = self:Add("SorenUI.Checkbox") 
    self.globalBan:SetSize(32,32)
    self.globalBan:SetFont("SorenUI.TextEntry")
    self.globalBan:SetLabelText("Global 2??")
    self.globalBan:SizeToContentsX()
    self.globalBan:SetPos( 500-40-154, 164)
    self.globalBan.DoClick = function()
        self.globalBan:Toggle()
    end

end

vgui.Register("SorenUI.Ban", PANEL)