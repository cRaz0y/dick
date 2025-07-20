local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
api.script_id = "61756ef94fe11f607bfaee00ea1ebf66"

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local key = ""

local Window = Fluent:CreateWindow({
    Title = "Anime Guardians Key System",
    SubTitle = "By CrazyXkazounXretardSlowXkvvisgay 🤦‍♀️",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 340),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    KeySys = Window:AddTab({ Title = "Key System", Icon = "key" }),
}

local Entkey = Tabs.KeySys:AddInput("Input", {
    Title = "Enter Key",
    Description = "Enter Key Here",
    Default = "",
    Placeholder = "Enter key…",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        key = Value
    end
})

local Checkkey = Tabs.KeySys:AddButton({
    Title = "Check Key",
    Description = "Enter Key before pressing this button",
    Callback = function()
        if key == "" then
            Fluent:Notify({
                Title = "Error",
                Content = "Please enter a key first!",
                Duration = 3
            })
            return
        end
        
        local status = api.check_key(key)
        print(status)
        
        if (status.code == "KEY_VALID") then
            Fluent:Notify({
                Title = "Success",
                Content = "Key is valid! Welcome. Seconds left: " .. (status.data.auth_expire - os.time()),
                Duration = 5
            })
            
            print("Total executions: " .. status.data.total_executions)
            print("Is key from ad system? " .. (status.data.note == "Ad Reward" and "YES" or "NO"))
            
            script_key = key
            api.load_script()
            Window:Destroy()
            return
            
        elseif (status.code == "KEY_HWID_LOCKED") then
            Fluent:Notify({
                Title = "Error",
                Content = "Key linked to a different HWID. Please reset it using our bot",
                Duration = 5
            })
            return
            
        elseif (status.code == "KEY_INCORRECT") then
            Fluent:Notify({
                Title = "Error",
                Content = "Key is wrong or deleted!",
                Duration = 5
            })
            return
        else
            -- fallback to anything else e.g blacklisted, key empty/too short:
            game.Players.LocalPlayer:Kick("Key check failed: " .. status.message .. " Code: " .. status.code)
        end
    end
})

local Getkey = Tabs.KeySys:AddButton({
    Title = "Get Key",
    Description = "Get Key here",
    Callback = function()
        setclipboard("https://ads.luarmor.net/v/cb/mZDblbclJyVr/YFtdOBQNxTWxKVmp")
        Fluent:Notify({
            Title = "Get Key",
            Content = "Key link copied to clipboard!",
            Duration = 3
        })
    end
})

Window:SelectTab(1)