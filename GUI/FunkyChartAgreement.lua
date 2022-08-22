accept = false

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/gui-libraries/main/venyx.lua')))()
local START = game:GetService("StarterGui")

local venyx = library.new({
    title = "FunkyChart Agreement"
})

local pageEULA = venyx:addPage({
    title = "Agreement"
})

local secEULA = pageEULA:addSection({
    title = "Read the message that was sent in chat."
})

local agree = secEULA:addButton({
    title = "ACCEPT",
    callback = function()
        accept = true

        if (writefile) then
            local json = game:GetService("HttpService"):JSONEncode(accept)
            writefile("FunkyChartAgreement.txt", json)
        else
            print("No save function found. Could not accept.")
        end

        coreGui[_G.venyxID]:Destroy()
    end
})

venyx:SelectPage({
    page = venyx.pages[1], 
    toggle = true
})

START:SetCore("ChatMakeSystemMessage", {
    Text = "[FunkyChart] You are responsible for your own actions. Exploiting violates Roblox's Community Standards. By using FunkyChart or any of my scripts, you agree that you are responsible for any punishments that can be held on your account, which includes bans (platform or in-game), account terminations, data wipes, etc. Use FunkyChart in a private environment and on a seperate Roblox account.\n\nPress 'ACCEPT' to accept.",
    Color = Color3.fromRGB(255, 0, 0),
    TextSize = 16
})

venyx:Notify({
    title = "Accept",
    text = "Read the message that was sent in chat."
})

