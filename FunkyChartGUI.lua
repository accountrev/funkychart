--[[

        ______            __         ________               __ 
       / ____/_  ______  / /____  __/ ____/ /_  ____ ______/ /_
      / /_  / / / / __ \/ //_/ / / / /   / __ \/ __ `/ ___/ __/
     / __/ / /_/ / / / / ,< / /_/ / /___/ / / / /_/ / /  / /_  
    /_/    \__,_/_/ /_/_/|_|\__, /\____/_/ /_/\__,_/_/   \__/  
                           /____/
    v1.11
    Made with ♥ by accountrev          

    Thanks for downloading and using my script, if you're here to just use it once or plan to use it many times.
    I have put many hours into this as well as my YouTube channel with showcases and such. I don't really care about the views that much,
    but the amount of attention that those videos created have blown my mind. Thank you.

    If at some point you want to fork/modify and re-distribute this script, please give me credit.

    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!
    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!
    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!

    [VERSION 1.11]

    - Added more checks to minimize errors
    - Save data now gets reset every time an update changes it (to reduce errors)
    - Charts that were converted from an update in the past will now not play and requires re-converting (to reduce errors)
    - Added a time offset for notes (positive number = later, negative numbers = earlier)
    - Fixed a bug where refreshing the list won't actually refresh unless you re-execute
    - Fixed some Krnl-exclusive and Synapse-exclusive bugs
    - Your player will not move anymore when using WASD or arrow keys while playing
    - More optimizations


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

for _,v in pairs(game.CoreGui:GetChildren()) do
    if v:FindFirstChild("Main") then
        for __,vv in pairs(v.Main:GetChildren()) do
            if vv.Name == "MainCorner" then
                v:Destroy()
            end
        end
    end
end


saveDataVersion = "1"

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
        lastplayed = "",
        version = saveDataVersion
    },

    versions = {
        acceptedVersions = {
            "v1.11"
        },
        loadingVersion = ""
    }
}

chartList = {}

local errorLagBool, chartLink, currentlyloadedtext, status, errorDesc

local consoleEnabled = true

local RS = game:GetService("RunService")
local CAS = game:GetService("ContextActionService")

function console(message, before)
    if consoleEnabled then
        before = before or ""
        rconsoleprint(before .. "[FunkyChart] " .. message .. "\n")
    end
end

function versionCheck(versionString)
    for _,v in ipairs(data.versions.acceptedVersions) do
        if versionString == v then
            return true
        end
    end
    return false
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

Announce("Script Loaded", "Welcome to FunkyChart!", 10, "main")

function errorHandler(errorMessage)
    Announce("A critical error occured!", errorMessage .. "\nPlease report this!", 100, "error")
    console("[CRITICAL ERROR] " .. errorMessage .. "\nPlease report this!", "\n\n\n")
end

function loadChart(chart, silent)
    chart = chartLink or data.options.lastplayed
    silent = silent or false

    console("[LOADING SONG " .. chart .. " WITH silent = " .. tostring(silent) .. "]", "\n\n")
    console("Checking if chart is nil (meaning if a chart is selected)")

    if chart == nil then
        console("ERROR - NO CHART WAS SELECTED, ignoring request...")
        Announce("No chart selected", "Select a chart from the list.", 10, "error")
        return
    elseif not isfile(chart) then
        console("ERROR - " .. chart .. " does not exist in FunkyChart/Charts!")
        Announce("Error", chart .. " does not exist!", 10, "error")
        return
    else
        console("CHART WAS FOUND! Now reading chart...")
        loadstring(readfile(chart))()
    end

    console("CHART READ! Now validating chart...")

    if not versionCheck(data.versions.loadingVersion) then
        console("ERROR - " .. chart .. " was created using an unaccepted version! Version used: " .. data.versions.loadingVersion)
        Announce("Invalid Version of Chart", chart .. " must be reconverted to a newer version of FunkyChart.", 10, "error")
        resetData("customChart")
        return
    elseif data.options.executor == "" then
        console("ERROR - Executor was not selected. Ignoring request...")
        Announce("No executor selected", "Select an executor to load a song.", 10, "error")
        resetData("customChart")
        return
    elseif not isfile(data.chartData.loadedAudioID) then
        console("ERROR - No Audio Found! " .. data.chartData.loadedAudioID .. " cannot be found for " .. chart .. ".")
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
        data.options.lastplayed = chart

        if not silent then
            Announce("Song Loaded", data.chartData.chartName .. " - " .. data.chartData.chartAuthor, 10, "loaded")
            Data("s")
        end

        console("CHART SUCESSFULLY LOADED!")
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
            console("Checking if data exists...")
            if (readfile and isfile and isfile(datafilename)) then
                console("FILE EXISTS! Now checking if save data is up to date...")
                data.options = game:GetService("HttpService"):JSONDecode(readfile(datafilename))
                
                if data.options.version ~= saveDataVersion then
                    console("Save data is not up to date and can cause problems. Forcing reset...")
                    Announce("Old Save Data", "Your save data was not up to date. Resetting.", 1, "error")
                    Data("r")
                    return
                else
                    console("Save data is up to date.")
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
                end
            else
                console("Could not find current data. New user or reset?")
                Announce("First Time?", "Looks like you don't have any save data. Load a song to start!", 10, "main")
            end
        elseif mode == "r" then
            console("Deleting current data...")
            Announce("Deleting", "Deleting save data...", 10, "main")
            delfile(datafilename)
            loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/funkychart/master/FunkyChartGUI.lua')))()
        end
    end
end

function resetData(choice)
    console("Full data reset initialized for " .. choice)
    if choice == "customChart" then
        data.chartData = {
            chartNotes = {},
            chartName = "None",
            chartNameColor = "<font color='rgb(255, 255, 255)'>%s</font>",
            chartAuthor = "None",
            chartDifficulty = "None",
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
    elseif choice == "sideandoffset" then
        data.options.timeOffset = 0
        data.options.side = "Left"
    end
end


function Chart(preventErrorLag)
    preventErrorLag = preventErrorLag or false

    console("[NOW PLAYING CHART - " .. data.options.lastplayed .. "WITH preventErrorLag = " .. tostring(preventErrorLag) .. "]", "\n\n")
    if data.chartData.loadedAudioID == "" then
        console("No chart has been loaded!")
        Announce("Load a song", "Load a song first you dummy!", 10, "error")
        return
    else
        for _, funky in next, getgc(true) do
            if type(funky) == 'table' and rawget(funky, 'GameUI') then
                
                Announce("Now Loading", data.chartData.chartName .. " - " .. data.chartData.chartAuthor, 1, "loaded")

                if preventErrorLag then
                    stagesArray = {}

                    for _,v in pairs(game:GetService("Workspace").Map.Stages:GetChildren()) do
                        table.insert(stagesArray, v)
                    end

                    local stagepos = stagesArray[math.random(#stagesArray)].Zone.CFrame
                    local currentpos = game.Players.LocalPlayer.Character.HumanoidRootPart
                    
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

                game.Players.LocalPlayer.Character.Torso.Anchored = true

                console("Playing successfully, now waiting for finish")
                
                repeat
                    wait()
                until game.SoundService.ClientMusic.IsPlaying == false or funky.SongPlayer.CurrentSongData == nil
                
                if game.SoundService.ClientMusic.IsPlaying == false then
                    funky.SongPlayer:StopSong()
                end

                game.SoundService.ClientMusic.Playing = false
                game.SoundService.ClientMusic.TimePosition = 0
                game.Players.LocalPlayer.Character.Torso.Anchored = false

                console("Song done")
            end 
        end
    end
end


function loadGUI()
    local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/gui-libraries/main/kavo.lua')))()

    local Window = Library.CreateLib("FunkyChart - v1.11", "GrapeTheme")

    local Main = Window:NewTab("Main")
    local CurrentyLoadedSec = Main:NewSection("Currently Loaded: None - None")

    local ChartLoading = Window:NewTab("Chart Loading")
    local ChartSec = ChartLoading:NewSection("Chart Loading")

    local Options = Window:NewTab("Options")
    local GeneralSec = Options:NewSection("General")
    local GUISec = Options:NewSection("GUI")
    local OtherSec = Options:NewSection("Other")

    local Credits = Window:NewTab("Credits")

    local Issues = Window:NewTab("Issues?")

    local PlayChartButton = CurrentyLoadedSec:NewButton("Play Chart", "Plays the chart you converted.", function()
        status, errorDesc = pcall(Chart, errorLagBool)
        if not status then
            errorHandler(errorDesc)
            game.Players.LocalPlayer.Character.Torso.Anchored = false
        end
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
        ChartDropdown:Refresh(listfiles("FunkyChart/Charts/"))
    end)

    local LoadChartButton = ChartSec:NewButton("Load Chart", "Loads chart into your save data.", function()
        status, errorDesc = pcall(loadChart, chartLink)
        if not status then
            errorHandler(errorDesc)
        end
    end)

    local PreventErrorLagToggle = GeneralSec:NewToggle("Prevent Error Lag", "Prevents massive lagspikes from errors.", function(state)
        errorLagBool = state
    end)

    local PlayerSideDropdown = GeneralSec:NewDropdown("Player Side", "Select between left side and right side.", {"Left", "Right"}, function(selectedOpt)
        data.options.side = selectedOpt
    end)

    local TimeOffsetSlide = GeneralSec:NewSlider("Time Offset", "Milliseconds. Postive = Late, Negative = Early", 500, -500, function(s)
        data.options.timeOffset = s / 1000
        print(data.options.timeOffset, s)
    end)

    local ApplyGeneralButton = GeneralSec:NewButton("Apply Changes", "Applies your player side and offset changes.", function()
        status, errorDesc = pcall(function()
            loadChart(chartLink, true)
        end)
        if not status then
            errorHandler(errorDesc)
        end
        console("Changes have been applied with time offset of " .. tostring(data.options.timeOffset) .. "and player side of " .. tostring(data.options.side))
        Announce("Changes Applied", "Time Offset: " .. tostring(data.options.timeOffset) .. "\nPlayer Side: " .. tostring(data.options.side), 10, "loaded")
    end)

    local ResetGeneralButton = GeneralSec:NewButton("Reset to Default", "Resets your player side and offset to default.", function()
        status, errorDesc = pcall(function()
            resetData("sideandoffset")
            loadChart(chartLink, true)
        end)
        if not status then
            errorHandler(errorDesc)
        end
        console("Changes have been applied with time offset of " .. tostring(data.options.timeOffset) .. "and player side of " .. tostring(data.options.side))
        Announce("Changes Applied", "Time Offset: " .. tostring(data.options.timeOffset) .. "\nPlayer Side: " .. tostring(data.options.side), 10, "loaded")
    end)

    local TitleSizeSlide = GUISec:NewSlider("Title Size", "Adjusts the size of the title while in-game.", 500, 0, function(s)
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
    local ConsoleToggle = GUISec:NewToggle("Enable Debug Console", "Opens a console with more info.", function(state)
        consoleEnabled = state
    end)
    local DeleteSaveButton = OtherSec:NewButton("DELETE SAVE", "Use this as a last resort.", function()
        Data("w")
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

    
    ChartDropdown:Refresh(listfiles("FunkyChart/Charts/"))

    RS.Heartbeat:Connect(function()
        CurrentyLoadedSec:UpdateSection("Currently Loaded: " .. data.chartData.chartName .. " - " .. data.chartData.chartAuthor)
    end)

end

function Init()
    loadSetup()
    Data("l")

    loadGUI()
end

Init()