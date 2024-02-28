local PANEL = {}

    /*Create a vgui that serves as a dropdown menu that accepts a table and lists that table in the style of the rest of the UI*/
    function PANEL:Init()
        self.tbl = {}


    end

    function PANEL:PerformLayout(w, h)
        //go through the self.tbl and create a new list for every element in the table
        for k, v in pairs(self.tbl) do
            local list = vgui.Create("DLabel", self)
            list:SetText(v)
            list:SetFont("SorenUI.MenuButton")
            list:SetTextColor(SorenUI.Colors.White)
            list:SizeToContents()
            list:SetPos(0, 0 + (k * 20))
        end  
    end

    function PANEL:SetTable(tbl)
        self.tbl = tbl
    end

vgui.Register("SorenUI.Dropdown", PANEL)