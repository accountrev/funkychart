--[[

        ______            __         ________               __ 
       / ____/_  ______  / /____  __/ ____/ /_  ____ ______/ /_
      / /_  / / / / __ \/ //_/ / / / /   / __ \/ __ `/ ___/ __/
     / __/ / /_/ / / / / ,< / /_/ / /___/ / / / /_/ / /  / /_  
    /_/    \__,_/_/ /_/_/|_|\__, /\____/_/ /_/\__,_/_/   \__/  
                           /____/
    v1.1
    Made with ♥ by accountrev          

    Thanks for downloading and using my script, if you're here to just use it once or plan to use it many times.
    I have put many hours into this as well as my YouTube channel with showcases and such. I don't really care about the views that much,
    but the amount of attention that those videos created have blown my mind. Thank you.

    If at some point you want to fork/modify and re-distribute this script, please give me credit.

    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!
    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!
    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!

    [VERSION 1.1]

    - New cleaner GUI Interface (Kavo by xHeptc), purple theme matching w/ Funky Friday
    - Made it easier to select a chart by using a dropdown menu instead of typing
    - Removed chart save data feature (no longer uses _G, now only saves options + recent chart link)
    - Added a Issues tab where you can get all contact details
    - Optimized and reworked all code
    - Fixed many bugs with Syanpse and Krnl (thanks for reporting btw!)
    - Debug console (for error reporting)
    - Reworked some notifications

    Thanks for waiting everyone!


-----------------------------------------------------

    [VERSION 1.051]

    -   Added selection for executors

    [VERSION 1.05]

    -   Added checks for any missing audio
    -   Added error handler

    [VERSION 1.04]

    -   Testing support for the Krnl executor.

    [VERSION 1.03]

    -   Fixed version number.

    [VERSION 1.02]

    -   No changes

    [VERSION 1.01 - DELAYED]

    -   Delayed released due to Roblox's audio privacy update.
    -   Removed functionality of online mode, making this script Synapse X exclusive :(
    -   Added new features and organized sections
    -   Bug fixes

    [VERSION 1.0 - INITIAL RELEASE]

    -   Initial release
    -   Fixed many bugs with the 4v4 update on FF before release.

--]]

data = {
    chartData = {
        chartNotes = {},
        chartName = "None",
        chartNameColor = "<font color='rgb(255, 255, 255)'>%s</font>",
        chartAuthor = "None",
        chartDifficulty = "None",
        chartConverter = game.Players.LocalPlayer.Name,
        loadedAudioID = ""
    },

    options = {
        timeOffset = 0,
        side = "Left",
        executor = "",
        lastplayed = ""
    }
}

chartList = {}

local errorLagBool
local chartLink
local currentlyloadedtext

local RS = game:GetService("RunService")

function console(message)
    rconsoleprint("[FunkyChart] " .. message .. "\n")
end

function loadSetup()
    if not game.SoundService:FindFirstChild("NotifAudio") then
        clientMusicInstance = Instance.new("Sound")
        clientMusicInstance.Parent = game.SoundService
        clientMusicInstance.Name = "NotifAudio"
        clientMusicInstance.SoundId = 0
        clientMusicInstance.TimePosition = 0
    else
        console("NotifAudio Instance already created.")
    end

    if not game.SoundService:FindFirstChild("ClientMusic") then
        clientMusicInstance = Instance.new("Sound")
        clientMusicInstance.Parent = game.SoundService
        clientMusicInstance.Name = "ClientMusic"
        clientMusicInstance.SoundId = data.chartData.loadedAudioID
        clientMusicInstance.TimePosition = 0
    else
        console("ClientMusic Instance already created.")
    end

    if not game.Players.LocalPlayer.PlayerGui.GameUI.Arrows:FindFirstChild("ExtraUnderlay") then
        underlay1 = Instance.new("Frame")
        underlay1.Name = "ExtraUnderlay"
        underlay1.AnchorPoint = Vector2.new(0.5, 0.5)
        underlay1.Parent = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Arrows
        underlay1.Size = UDim2.new(2, 0, 2, 0)
        underlay1.Position = UDim2.new(0.5, 0, 0.5, 0)
        underlay1.ZIndex = 0
        underlay1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        underlay1.BackgroundTransparency = 0
        underlay1.Visible = false
    else
        console("Underlay already created")
    end
end

function Announce(messagetitle, messagebody, duration, type)

    console("Announcement - " .. messagetitle .. ": " .. messagebody .. " (" .. tostring(duration) .. " sec as " .. type .. ")")

    startgui = game:GetService("StarterGui")

    typeSounds = {
        ["main"] = 12221967,
        ["error"] = 12221944,
        ["loaded"] = 12222152
    }

    startgui:SetCore("SendNotification", {
        Title = messagetitle;
        Text = messagebody;
        Duration = duration;
        Button1 = "Close";
    })

    local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. typeSounds[type]
    sound.Parent = game.SoundService
	sound:Play()
	sound.Ended:Wait()
	sound:Destroy()
end

function errorHandler(errorMessage)
    Announce("An Oopsie Occurred!", errorMessage .. "\nPlease report this!", 100, "error")
    console("An Oopsie Occurred!", errorMessage .. "\nPlease report this!")
end

function loadChart(chart, silent)
    
    if chart == nil then
        console("No chart was selected, ignoring...")
        Announce("No chart selected", "Select a chart from the list.", 10, "error")
        return
    end

    console("Loading chart " .. chart .. ", silent = " .. tostring(silent))

    silent = silent or false

    if data.options.executor == "" then
        console("Executor missing")
        Announce("No executor selected", "Select an executor to load a song.", 10, "error")
        return
    end

    if not isfile(chart) then
        console("Error", chart .. " does not exist!")
        Announce("Error", chart .. " does not exist!", 10, "error")
        return
    else
        data.options.lastplayed = chart
        console("Recognized chart, now loadstring")
        loadstring(readfile(chart))()
    end

    if not isfile(data.chartData.loadedAudioID) then
        console("No Audio Found!", data.chartData.loadedAudioID .. " cannot be found for " .. chart .. ".")
        Announce("No Audio Found!", data.chartData.loadedAudioID .. " cannot be found for " .. chart .. ".", 10, "error")
        resetData("customChart")
        return
    else
        if data.options.executor == "Synapse" then
            console("Synapse mode")
            data.chartData.loadedAudioID = getsynasset(data.chartData.loadedAudioID)
        elseif data.options.executor == "Krnl" then
            console("Krnl mode")
            data.chartData.loadedAudioID = getcustomasset(data.chartData.loadedAudioID)
        end

        game.SoundService.ClientMusic.SoundId = data.chartData.loadedAudioID
        if not silent then
            Announce("Song Loaded", data.chartData.chartName .. " - " .. data.chartData.chartAuthor, 10, "loaded")
            Data("s")
        end

        console("Chart successfully loaded")
    end
end

function Data(mode)

    local foldername = "FunkyChart"
    local datafilename = "FunkyChartVersion2.txt"
    local audiofoldername = foldername .. "/Audio"
    local chartfoldername = foldername .. "/Charts"

    if not isfolder(foldername) then
        makefolder(foldername)
        makefolder(audiofoldername)
        makefolder(chartfoldername)
    else
        if mode == "s" then
            console("Saving data...")
            local json
            if (writefile) then
                json = game:GetService("HttpService"):JSONEncode(data.options)
                writefile(datafilename, json)
                Announce("Save Data Saved", "Your options data has been saved!", 10, "main")
            end
            console("Data saved.")
        elseif mode == "l" then
            console("Loading data...")
            if (readfile and isfile and isfile(datafilename)) then
                data.options = game:GetService("HttpService"):JSONDecode(readfile(datafilename))
                Announce("Save Data Loaded", "Welcome back " .. game.Players.LocalPlayer.Name .. "!", 10, "main")
                loadChart(data.options.lastplayed, true)
                Announce("Loaded Last Played Chart", data.chartData.chartName .. " - " .. data.chartData.chartAuthor, 10, "loaded")
                console("Data and chart loaded.")
                
                for _,v in pairs(data.chartData) do
                    console(tostring(v))
                end

                for _,v in pairs(data.options) do
                    console(tostring(v))
                end

            else
                console("Could not find current data. New user?")
                Announce("First Time?", "Looks like you don't have any save data. Load a song to start!", 10, "main")
            end
        elseif mode == "w" then
            console("Deleting current data...")
            Announce("Deleting", "Deleting save data...", 10, "main")
            delfile(datafilename)
        end
    end
end

function resetData(choice)
    console("Full data reset initialized for " .. choice)
    if choice == "customChart" then
        data.chartData = {
            chartNotes = {},
            chartName = "",
            chartNameColor = "<font color='rgb(255, 255, 255)'>%s</font>",
            chartAuthor = "",
            chartDifficulty = "",
            chartConverter = game.Players.LocalPlayer.Name,
            loadedAudioID = ""
        }
    elseif choice == "options" then
        data.options = {
            timeOffset = 0,
            side = "Left",
            executor = "",
            lastplayed = ""
        }
    end
end


function Chart(preventErrorLag)
    preventErrorLag = preventErrorLag or false

    console("Playing a chart with preventerrorlag " .. tostring(preventErrorLag))
    if data.chartData.loadedAudioID == "" then
        console("No audio found")
        Announce("Load a song", "Load a song first you dummy!", 10, "error")
        return
    else
        for _, funky in next, getgc(true) do
            if type(funky) == 'table' and rawget(funky, 'GameUI') then
                
                Announce("Now Loading", data.chartData.chartName .. " - " .. data.chartData.chartAuthor, 1, "loaded")

                if preventErrorLag then
                    local currentpos = game.Players.LocalPlayer.Character.HumanoidRootPart
                    local stagepos = game:GetService("Workspace").Map.Stages.WoodStage.Zone.CFrame
                    currentpos.CFrame = stagepos
                end
                
                funky.SongPlayer:StartSong("FNF_Bopeebo", data.options.side, "Hard", {game.Players.LocalPlayer})

                print(data.options.side)

                funky.SongPlayer.CurrentSongData = data.chartData.chartNotes
                funky.Songs.FNF_Bopeebo.Title = data.chartData.chartName
                funky.Songs.FNF_Bopeebo.TitleFormat = data.chartData.chartNameColor
                funky.SongPlayer.TopbarAuthor = "By: " .. data.chartData.chartAuthor .. "\nConverted by: " .. data.chartData.chartConverter
                funky.SongPlayer.TopbarDifficulty = data.chartData.chartDifficulty
                funky.SongPlayer.CountDown = true
                
                game:GetService("SoundService").ClientMusic.SoundId = data.chartData.loadedAudioID
                funky.SongPlayer.CurrentlyPlaying = game:GetService("SoundService").ClientMusic
                funky.SongPlayer:Countdown()
                funky.SongPlayer.CurrentlyPlaying.Playing = true

                console("Playing successfully, now waiting for finish")
                
                repeat
                    wait()
                until game.SoundService.ClientMusic.IsPlaying == false or funky.SongPlayer.CurrentSongData == nil
                
                if game.SoundService.ClientMusic.IsPlaying == false then
                    funky.SongPlayer:StopSong()
                end

                game.SoundService.ClientMusic.Playing = false
                game.SoundService.ClientMusic.TimePosition = 0

                console("Song done")
            end 
        end
    end
end


function loadGUI()
    chartList = listfiles("FunkyChart/Charts/")

    local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/gui-libraries/main/kavo.lua')))()

    local Window = Library.CreateLib("FunkyChart - v1.1", "GrapeTheme")

    local Main = Window:NewTab("Main")
    local CurrentyLoadedSec = Main:NewSection("Currently Loaded: None")

    local ChartLoading = Window:NewTab("Chart Loading")
    local ChartSec = ChartLoading:NewSection("Chart Loading")

    local Options = Window:NewTab("Options")
    local GeneralSec = Options:NewSection("General")
    local GUISec = Options:NewSection("GUI")
    local OtherSec = Options:NewSection("Other")

    local Credits = Window:NewTab("Credits")

    local Issues = Window:NewTab("Issues?")

    local PlayChartButton = CurrentyLoadedSec:NewButton("Play Chart", "Plays the chart you converted.", function()
        Chart(errorLagBool)
    end)

    local AutoplayerButton = CurrentyLoadedSec:NewButton("wally-rblx's AutoPlayer", "https://github.com/wally-rblx/funky-friday-autoplay", function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/wally-rblx/funky-friday-autoplay/main/main.lua')))()
    end)

    local ExecutorDropdown = ChartSec:NewDropdown("Executor", "Select between Synapse X and Krnl.", {"Synapse", "Krnl"}, function(selectedOpt)
        data.options.executor = selectedOpt
    end)

    local ChartDropdown = ChartSec:NewDropdown("Charts Available", "Charts go into workspace/FunkyChart/Charts.", {""}, function(selectedOpt)
        chartLink = selectedOpt
    end)

    local refreshChartButton = ChartSec:NewButton("Refresh Charts", "Refreshes the chart list.", function()
        ChartDropdown:Refresh(chartList)
    end)

    local LoadChartButton = ChartSec:NewButton("Load Chart", "Loads chart into your save data.", function()
        loadChart(chartLink, false)
    end)

    local PreventErrorLagToggle = GeneralSec:NewToggle("Prevent Error Lag", "Prevents massive lagspikes from errors.", function(state)
        errorLagBool = state
    end)

    local PlayerSideDropdown = GeneralSec:NewDropdown("Player Side", "Select between left side and right side.", {"Left", "Right"}, function(selectedOpt)
        data.options.side = mob
        Data("s")
    end)

    local TitleSizeSlide = GUISec:NewSlider("Title Size", "Adjust the size of the title while in-game.", 500, 0, function(s)
        game.Players.LocalPlayer.PlayerGui.GameUI.TopbarLabel.Size = UDim2.new(0.4, 0, 0, s)
    end)

    local ExtraUnderlayToggle = GUISec:NewToggle("Full Underlay", "Mimics osu!'s 100% Background Dim.", function(state)
        game.Players.LocalPlayer.PlayerGui.GameUI.Arrows.ExtraUnderlay.Visible = state
    end)

    local PreventSickToggle = GUISec:NewToggle("Disable Sick! Judgement", "Hides the Sick! judgement.", function(state)
        if state then
            game:GetService("ReplicatedStorage").Assets.UI.Templates.Hits.Sick.Image = " "
        else
            game:GetService("ReplicatedStorage").Assets.UI.Templates.Hits.Sick.Image = "rbxassetid://6450258128"
        end
    end)
    --[[
    local ConsoleToggle = GUISec:NewToggle("Enable Debug Console", "Opens a console with more info.", function(state)
        consoleEnabled = state
    end)
    --]]
    local DeleteSaveButton = OtherSec:NewButton("DELETE SAVE", "Use this as a last resort.", function()
        Data("w")
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/funkychart/master/FunkyChartGUI.lua')))()
    end)

    local Credits1 = Credits:NewSection("Credits to:")
    local Credits2 = Credits:NewSection("wally-rblx: AutoPlayer and inspiration")
    local Credits3 = Credits:NewSection("Aika: Old GUI")
    local Credits4 = Credits:NewSection("xHeptc: New GUI (Kavo)")
    local Credits5 = Credits:NewSection("Myself: having the motivation to finish this")
    local Credits6 = Credits:NewSection("Roblox: Killing audios and fucking up release")

    local Issues1 = Issues:NewSection("Having issues with FunkyChart?")
    local Issues2 = Issues:NewSection("1. Visit the official Wiki for more info.")
    local Issues3 = Issues:NewSection("2. Report the issue in the Issues tab on GitHub.")
    local Issues4 = Issues:NewSection("3. Contact me on Discord (accountrevived#0686)")
    
    local CopyWikiLink = Issues4:NewButton("Copy Wiki Link", "", function()
        setclipboard("https://github.com/accountrev/funkychart/wiki")
    end)

    local CopyGitHubIssue = Issues4:NewButton("Copy Issues Link", "", function()
        setclipboard("https://github.com/accountrev/funkychart/issues")
    end)

    local CopyGitHubIssue = Issues4:NewButton("Copy Discord Tag", "", function()
        setclipboard("accountrevived#0686")
    end)

    
    ChartDropdown:Refresh(chartList)

    RS.Heartbeat:Connect(function()
        CurrentyLoadedSec:UpdateSection("Currently Loaded: " .. data.chartData.chartName .. " - " .. data.chartData.chartAuthor)
    end)

end

function Init()
    loadSetup()
    Data("l")

    loadGUI()
    Announce("Script Loaded", "Welcome to FunkyChart!", 10, "main")
end

local errorLagBool
local chartListName
local chartLink

Init()