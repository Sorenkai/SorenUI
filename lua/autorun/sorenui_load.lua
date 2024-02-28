SorenUI = SorenUI or {}
SorenUI.Dir = "sorenui"
SorenUI.UI = {}

function SorenUI:IncludeClient(path)
    local str = self.Dir .. "/" .. path .. ".lua"

    print("Including SorenUI file", str)

    if (CLIENT) then
        include(str)
    end
    if (SERVER) then
        AddCSLuaFile(str)
    end
end

-- IMPORTANT
SorenUI:IncludeClient("config/theme")
SorenUI:IncludeClient("config/lang")
-- Third Party
SorenUI:IncludeClient("thirdparty/bshadows")
-- Fonts
SorenUI:IncludeClient("misc/util")
-- Elements
SorenUI:IncludeClient("elements/frame")
SorenUI:IncludeClient("elements/navbar")
SorenUI:IncludeClient("elements/dropdown")
SorenUI:IncludeClient("elements/textfield")
SorenUI:IncludeClient("elements/ban")
SorenUI:IncludeClient("elements/unban")
SorenUI:IncludeClient("elements/sync")
SorenUI:IncludeClient("elements/checkbox")
-- UI
SorenUI:IncludeClient("ui/frame")
