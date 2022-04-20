--[[

        ______            __         ________               __ 
       / ____/_  ______  / /____  __/ ____/ /_  ____ ______/ /_
      / /_  / / / / __ \/ //_/ / / / /   / __ \/ __ `/ ___/ __/
     / __/ / /_/ / / / / ,< / /_/ / /___/ / / / /_/ / /  / /_  
    /_/    \__,_/_/ /_/_/|_|\__, /\____/_/ /_/\__,_/_/   \__/  
                           /____/
    v1.12
    Made with ♥ by accountrev          

    Thanks for downloading and using my script, if you're here to just use it once or plan to use it many times.
    I have put many hours into this as well as my YouTube channel with showcases and such. I don't really care about the views that much,
    but the amount of attention that those videos created have blown my mind. Thank you.

    If at some point you want to fork/modify and re-distribute this script, please give me credit.

    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!
    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!
    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!

    [VERSION 1.12]

    - Added underframes, the ability to load image backgrounds or play video backgrounds while you play
    - Underframe is currently a WIP feature, so things may break. If any problems, report them using the Issues? section on the GUI.
    - Added manual loading, load charts just by using a local direct link to the chart.
    - Added keybinds, currently there is one which is to hide the GUI

    I will be taking a break from the project to study for my finals, and will be updating this later this May. Thanks for using FunkyChart everyone!


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

chartList = {}

local errorLagBool, chartLink, currentlyloadedtext, status, errorDesc

local consoleEnabled = true

local RS = game:GetService("RunService")
local CAS = game:GetService("ContextActionService")
local TS = game:GetService("TweenService")

local saveDataVersion = "1"

data = {

    chartData = {
        chartNotes = {},
        chartName = "None",
        chartNameColor = "<font color='rgb(255, 255, 255)'>%s</font>",
        chartAuthor = "None",
        chartDifficulty = "None",
        chartConverter = game.Players.LocalPlayer.Name,
        loadedAudioID = "",
        additionalID = "",
        additionalIDType = "none"
    },

    options = {
        timeOffset = 0,
        side = "Left",
        executor = "",
        lastplayed = "",
        version = saveDataVersion
    },

    underframe = {
        enabled = false,
        override = false,
        overrideAdditionalID = "",
        overrideAdditionalIDType = "none",
        overrideVideoLoop = false
    },

    versions = {
        acceptedVersions = {
            "v1.12"
        },
        loadingVersion = ""
    }
}




function clearAllCurrentFCGuis()
    for _,v in pairs(game.CoreGui:GetChildren()) do
        if v:FindFirstChild("Main") then
            for __,vv in pairs(v.Main:GetChildren()) do
                if vv.Name == "MainCorner" then
                    v:Destroy()
                end
            end
        end
    end
end

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

function checkIfFileExists(link)
    if not isfile(link) then
        return false
    else
        return true
    end
end

function checkIfFolderExists(link)
    if not isfolder(link) then
        return false
    else
        return true
    end
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
end

function manageUnderframe(mode, typeOf, link, isVideoLooped, transparency)
    typeOf = typeOf or "none"
    link = link or ""
    isVideoLooped = isVideoLooped or false
    transparency = transparency or 0

    function createVideo(a1, a2, a3)
        video = Instance.new("VideoFrame")
        video.Name = "VideoFrame"
        video.AnchorPoint = Vector2.new(0.5, 0.5)
        video.Parent = screenGui
        video.Size = UDim2.new(1, 0, 1, 0)
        video.Position = UDim2.new(0.5, 0, 0.5, 0)
        video.ZIndex = 0
        video.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        video.BackgroundTransparency = 0
        video.BorderSizePixel = 0
        video.Video = a1
        video.Visible = true
        video.Volume = 0
        video.Looped = a2

        cover = Instance.new("Frame")
        cover.Name = "Cover"
        cover.AnchorPoint = Vector2.new(0.5, 0.5)
        cover.Parent = video
        cover.Size = UDim2.new(1, 0, 1, 0)
        cover.Position = UDim2.new(0.5, 0, 0.5, 0)
        cover.ZIndex = 0
        cover.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        cover.BackgroundTransparency = a3
        cover.BorderSizePixel = 0
        cover.Visible = true

        console("Underframe applied, not waiting")

        repeat wait() until game.SoundService.ClientMusic.IsPlaying

        cover.BackgroundTransparency = 1
        video:Play()
    end

    function createImage(a1, a2)
        image = Instance.new("ImageLabel")
        image.Name = "ImageUnderframe"
        image.AnchorPoint = Vector2.new(0.5, 0.5)
        image.Parent = screenGui
        image.Size = UDim2.new(1, 0, 1, 0)
        image.Position = UDim2.new(0.5, 0, 0.5, 0)
        image.ZIndex = 0
        image.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        image.BackgroundTransparency = a2
        image.BorderSizePixel = 0
        image.Visible = true
        image.Image = a1

        cover = Instance.new("Frame")
        cover.Name = "Cover"
        cover.AnchorPoint = Vector2.new(0.5, 0.5)
        cover.Parent = image
        cover.Size = UDim2.new(1, 0, 1, 0)
        cover.Position = UDim2.new(0.5, 0, 0.5, 0)
        cover.ZIndex = 0
        cover.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        cover.BackgroundTransparency = 1
        cover.BorderSizePixel = 0
        cover.Visible = true
    end

    function createBlack(a1)
        cover = Instance.new("Frame")
        cover.Name = "Cover"
        cover.AnchorPoint = Vector2.new(0.5, 0.5)
        cover.Parent = screenGui
        cover.Size = UDim2.new(1, 0, 1, 0)
        cover.Position = UDim2.new(0.5, 0, 0.5, 0)
        cover.ZIndex = 0
        cover.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        cover.BackgroundTransparency = a1
        cover.BorderSizePixel = 0
        cover.Visible = true
    end

    
    if mode == "create" then
        repeat wait(0.1) until game.Players.LocalPlayer.PlayerGui.GameUI.Arrows.Visible == true

        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Underframe"
        screenGui.DisplayOrder = -10
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = game.Players.LocalPlayer.PlayerGui
        screenGui.ResetOnSpawn = false        

        if typeOf == "image" then
            if data.underframe.override then
                createImage(data.underframe.overrideAdditionalID, transparency)
            else
                createImage(link, transparency)
            end

            console("Underframe (img) applied")
            return

        elseif typeOf == "video" then
            if data.underframe.override then
                createVideo(data.underframe.overrideAdditionalID, data.underframe.overrideVideoLoop, transparency)
            else
                createVideo(link, isVideoLooped, transparency)
            end

            console("Underframe (vid) applied")
            return


        elseif typeOf == "none" then
            if data.underframe.override then
                createVideo(transparency)
            else
                createVideo(transparency)
            end

            console("Underframe (black) applied")
            return
        else
            console("Nothing was given.")
        end


    elseif mode == "remove" then

        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Underframe") then
            game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Underframe"):Destroy()
        else
            console("No underframe available")
        end
    else
        console("Account (the developer) was on crack and this somehow happened.")
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

function dp(x)

    startgui = game:GetService("StarterGui")

    startgui:SetCore("SendNotification", {
        Title = "Debug";
        Text = tostring(x);
        Duration = 100;
        Button1 = "Close";
    })
end

function tweenMove(toPoint)
    local goal1 = {}
    goal1.CFrame = toPoint

	local tweenInfo = TweenInfo.new(0.5)

	local tween = TS:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, goal1)
	
	tween:Play()

    tween.Completed:Wait()
end


function loadChart(chart, silent, fromGUI)
    chart = chartLink or data.options.lastplayed
    silent = silent or false
    fromGUI = fromGUI or false

    console("[LOADING SONG " .. chart .. " WITH silent = " .. tostring(silent) .. "]", "\n\n")
    console("Checking if chart is nil (meaning if a chart is selected)")

    if chart == nil then
        console("ERROR - NO CHART WAS SELECTED, ignoring request...")
        Announce("No chart selected", "Select a chart from the list.", 10, "error")
        return
    end

    if checkIfFileExists(chart) then
        console("CHART WAS FOUND! Now reading chart...")
        loadstring(readfile(chart))()
    else
        if fromGUI then
            console("ERROR - " .. chart .. " does not exist in FunkyChart/Charts!")
            Announce("Error", chart .. " does not exist! Was it possibly removed or did the name change?", 10, "error")
        else
            console("ERROR - " .. chart .. " was not found after save in FunkyChart/Charts! Was it possibly removed or did the name change?")
            Announce("Saved Chart Missing", chart .. " was not found after last save! Was it possibly removed or did the name change?", 10, "error")
        end

        return
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
    end

    if checkIfFileExists(data.chartData.loadedAudioID) then
        if data.options.executor == "Synapse" then
            console("Synapse mode")
            data.chartData.loadedAudioID = getsynasset(data.chartData.loadedAudioID)
        elseif data.options.executor == "Krnl" then
            console("Krnl mode")
            data.chartData.loadedAudioID = getcustomasset(data.chartData.loadedAudioID)
        end

        game.SoundService.ClientMusic.SoundId = data.chartData.loadedAudioID
        data.options.lastplayed = chart
    else
        if fromGUI then
            console("ERROR - No Audio Found! " .. data.chartData.loadedAudioID .. " cannot be found for " .. chart .. ".")
            Announce("No Audio Found!", data.chartData.loadedAudioID .. " cannot be found for " .. chart .. ". Was it possibly removed or did the name change?", 10, "error")
            resetData("customChart")
            return
        else
            console("ERROR - No Audio Found from save! " .. data.chartData.loadedAudioID .. " cannot be found for " .. chart .. ".")
            Announce("No Audio Found!", data.chartData.loadedAudioID .. " cannot be found for " .. chart .. ". Was it possibly removed or did the name change after save?", 10, "error")
            resetData("customChart")
            return
        end
    end

    if data.underframe.enabled then
        if checkIfFileExists(data.chartData.additionalID) then
            if data.options.executor == "Synapse" then
                console("Synapse mode for additional ID")
                data.chartData.additionalID = getsynasset(data.chartData.additionalID)
            elseif data.options.executor == "Krnl" then
                console("Krnl mode for additional ID")
                data.chartData.additionalID = getcustomasset(data.chartData.additionalID)
            end
        else
            console("ERROR - Additional ID not Found! " .. data.chartData.additionalID .. " cannot be found.")
            Announce("Additional ID not Found!", data.chartData.additionalID .. " cannot be found and will be skipped to prevent errors", 10, "error")
            data.chartData.additionalIDType = "none"
        end
    end

    if not silent then
        Announce("Song Loaded", data.chartData.chartName .. " - " .. data.chartData.chartAuthor, 10, "loaded")
        functionHandler(Data, "s")
    end
    console("CHART SUCESSFULLY LOADED!")
end

function saveFile(saving, fileName)
    console("Saving data...")

    if (writefile) then
        local json = game:GetService("HttpService"):JSONEncode(saving)
        writefile(fileName, json)
        Announce("Save Data Saved", "Your options data has been saved!", 10, "main")
        console("Data saved.")
    else
        console("No save function found.")
    end
end

function loadData(fileName)
    console("Checking if data exists...")
    if (readfile and isfile and checkIfFileExists(fileName)) then
        console("FILE EXISTS! Now checking if save data is up to date...")
        data.options = game:GetService("HttpService"):JSONDecode(readfile(fileName))
        
        if data.options.version ~= saveDataVersion then
            console("Save data is not up to date and can cause problems. Forcing reset...")
            Announce("Old Save Data", "Your save data was not up to date. Resetting.", 1, "error")
            functionHandler(Data, "r")
            return
        else
            console("Save data is up to date.")
            Announce("Save Data Loaded", "Welcome back " .. game.Players.LocalPlayer.Name .. "!", 10, "main")
            functionHandler(loadChart, data.options.lastplayed, true, false)
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
        console("Could not find current data.")
        Announce("Save Data not found", "Load a song to create your save data.", 10, "main")
    end
end

function resetSave(filename)
    console("Deleting current data...")
    Announce("Deleting", "Deleting save data...", 10, "main")
    delfile(filename)
    --loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/funkychart/master/FunkyChartGUI.lua')))()
end

function Data(mode)
    local foldername = "FunkyChart"
    local datafilename = "FunkyChartVersion2.txt"
    local audiofoldername = foldername .. "/Audio"
    local chartfoldername = foldername .. "/Charts"
    local assetsfoldername = foldername .. "/Assets"

    if checkIfFolderExists(foldername) then

        if checkIfFolderExists(audiofoldername) then makefolder(foldername) end
        if checkIfFolderExists(chartfoldername) then makefolder(chartfoldername) end
        if checkIfFolderExists(assetsfoldername) then makefolder(assetsfoldername) end

        if mode == "s" then
            saveFile(data.options, datafilename)
        elseif mode == "l" then
            loadData(datafilename)
        elseif mode == "r" then
            resetSave(datafilename)
        end
    else
        makefolder(foldername)
        makefolder(audiofoldername)
        makefolder(chartfoldername)
        makefolder(assetsfoldername)

        Announce("First Time?", "Looks like you don't have any save data. Load a song to start!", 10, "main")
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

                    tweenMove(stagepos)
                end

                funky.SongPlayer:StartSong("FNF_Bopeebo", data.options.side, "Hard", {game.Players.LocalPlayer})

                if data.underframe.enabled then
                    task.spawn(function()
                        functionHandler(manageUnderframe, "create", data.chartData.additionalIDType, data.chartData.additionalID)
                    end)
                end
                

                funky.SongPlayer.CurrentSongData = data.chartData.chartNotes
                funky.Songs.FNF_Bopeebo.Title = data.chartData.chartName
                funky.Songs.FNF_Bopeebo.TitleFormat = data.chartData.chartNameColor
                funky.SongPlayer.TopbarAuthor = "By: " .. data.chartData.chartAuthor .. "\nConverted by: " .. data.chartData.chartConverter
                funky.SongPlayer.TopbarDifficulty = data.chartData.chartDifficulty
                funky.SongPlayer.CountDown = true

                
                game:GetService("SoundService").ClientMusic.SoundId = data.chartData.loadedAudioID
                funky.SongPlayer.CurrentlyPlaying = game:GetService("SoundService").ClientMusic
                funky.SongPlayer:Countdown()
                funky.SongPlayer.CurrentlyPlaying:Play()
                
                

                game.Players.LocalPlayer.Character.Torso.Anchored = true

                console("Playing successfully, now waiting for finish")
                
                repeat
                    wait()
                until game.SoundService.ClientMusic.IsPlaying == false or funky.SongPlayer.CurrentSongData == nil


                if game.SoundService.ClientMusic.IsPlaying == false then
                    funky.SongPlayer:StopSong()
                end

                if data.underframe.enabled then
                    task.spawn(function()
                        functionHandler(manageUnderframe, "remove")
                    end)
                end

                game.SoundService.ClientMusic.Playing = false
                game.SoundService.ClientMusic.TimePosition = 0
                game.Players.LocalPlayer.Character.Torso.Anchored = false

                

                console("Song done")
            end 
        end
    end
end

function functionHandler(func, a1, a2, a3, a4, a5)
    
    a1 = a1 or nil
    a2 = a2 or nil
    a3 = a3 or nil
    a4 = a4 or nil
    a5 = a5 or nil


    local erroredFunction
    local additionalInfo = "Please report this!"

    if func == loadChart then
        status, errorDesc = pcall(func, a1, a2, a3)
        erroredFunction = "Chart file (loadChart)"
        additionalInfo = "Is this an older chart?"
    elseif func == Chart then
        status, errorDesc = pcall(func, a1)
        erroredFunction = "Chart"
    elseif func == Data then 
        status, errorDesc = pcall(func, a1)
        erroredFunction = "Data"
    elseif func == manageUnderframe then 
        status, errorDesc = pcall(func, a1, a2, a3, a4)
        erroredFunction = "manageUnderframe" 
    end

    if not status then
        Announce("A critical error occured!", errorDesc .. "\nIn function: ".. erroredFunction .. "\n" .. additionalInfo, 100, "error")
        console("[CRITICAL ERROR] " .. errorDesc .. "\nIn function: ".. erroredFunction .. additionalInfo, "\n\n\n")
    end

    
end


function loadGUI()
    local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/gui-libraries/main/kavo.lua')))()

    local Window = Library.CreateLib("FunkyChart - v1.12", "GrapeTheme")

    local Main = Window:NewTab("Main")
    local CurrentyLoadedSec = Main:NewSection("Currently Loaded: None - None")

    local ChartLoading = Window:NewTab("Chart Loading")
    local ChartSec = ChartLoading:NewSection("Chart Loading")
    local ChartOverrideSec = ChartLoading:NewSection("Manual Override")

    local Options = Window:NewTab("Options")
    local GeneralSec = Options:NewSection("General")
    local GUISec = Options:NewSection("GUI")
    local OtherSec = Options:NewSection("Other")

    local UnderframeTab = Window:NewTab("Underframe (WIP)")
    local UnderframeSec = UnderframeTab:NewSection("Underframe")

    local KeyBinds = Window:NewTab("Keybinds")
    local KeyBindsSec = KeyBinds:NewSection("Keybinds")
    
    local ToggleUIKeybind = KeyBindsSec:NewKeybind("Toggle UI", "Hides and unhides the UI.", Enum.KeyCode.RightAlt, function()
        Library:ToggleUI()
    end)

    local Credits = Window:NewTab("Credits")

    local Issues = Window:NewTab("Issues?")

    local PlayChartButton = CurrentyLoadedSec:NewButton("Play Chart", "Plays the chart you converted.", function()
        functionHandler(Chart, errorLagBool)
    end)

    local Test1 = CurrentyLoadedSec:NewButton("Test", "lol", function()
        for i,v in pairs(data.chartData) do
            print(i,v)
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
        functionHandler(loadChart, chartLink, false, true)
    end)


    local ChartTextbox = ChartOverrideSec:NewTextBox("File Location", "Use this if your executor doesn't properly list charts.", function(txt)
        chartLink = txt
    end)

    local LoadChartOverride = ChartOverrideSec:NewButton("Load Chart", "Loads chart into your save data.", function()
        functionHandler(loadChart, chartLink, false, true)
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
        functionHandler(loadChart, chartLink, true, true)
        console("Changes have been applied with time offset of " .. tostring(data.options.timeOffset) .. "and player side of " .. tostring(data.options.side))
        Announce("Changes Applied", "Time Offset: " .. tostring(data.options.timeOffset) .. "\nPlayer Side: " .. tostring(data.options.side), 10, "loaded")
    end)

    local ResetGeneralButton = GeneralSec:NewButton("Reset to Default", "Resets your player side and offset to default.", function()
        resetData("sideandoffset")
        functionHandler(loadChart, chartLink, true, true)
        console("Changes have been applied with time offset of " .. tostring(data.options.timeOffset) .. "and player side of " .. tostring(data.options.side))
        Announce("Changes Applied", "Time Offset: " .. tostring(data.options.timeOffset) .. "\nPlayer Side: " .. tostring(data.options.side), 10, "loaded")
    end)

    local TitleSizeSlide = GUISec:NewSlider("Title Size", "Adjusts the size of the title while in-game.", 500, 0, function(s)
        game.Players.LocalPlayer.PlayerGui.GameUI.TopbarLabel.Size = UDim2.new(0.4, 0, 0, s)
    end)

    local PreventSickToggle = GUISec:NewToggle("Disable Sick! Judgement", "Hides the Sick! judgement.", function(state)
        if state then
            game:GetService("ReplicatedStorage").Assets.UI.Templates.Hits.Sick.Image = " "
        else
            game:GetService("ReplicatedStorage").Assets.UI.Templates.Hits.Sick.Image = "rbxassetid://6450258128"
        end
    end)
    
    local DeleteSaveButton = OtherSec:NewButton("DELETE SAVE", "Use this as a last resort.", function()
        functionHandler(Data, "r")
    end)

    local SetEnabled = UnderframeSec:NewToggle("Enable Underframes", "Enables the underframe feature.", function(state)
        data.underframe.enabled = state
    end)

    local SetOverride = UnderframeSec:NewToggle("Override Underframes", "Overrides every underframe when loading.", function(state)
        data.underframe.override = state
    end)

    local UnderframeSelection = UnderframeSec:NewDropdown("Select Asset", "Assets go into workspace/FunkyChart/Assets.", {""}, function(selectedOpt)
        data.underframe.overrideAdditionalID = getsynasset(selectedOpt)
    end)

    local UnderframeTypeSelection = UnderframeSec:NewDropdown("Select Type", "Select between type image or video.", {"image", "video", "none"}, function(selectedOpt)
        data.underframe.overrideAdditionalIDType = selectedOpt
    end)

    local VideoLoopToggle = UnderframeSec:NewToggle("Video Looping?", "Loops overriden video.", function(state)
        data.underframe.overrideVideoLoop = state
    end)

    local TransparencySlide = UnderframeSec:NewSlider("Transparency (WIP)", "", 1, 0, function(s)
        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Underframe") then
            --game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Underframe").
            return
        end
    end)

    local refreshAssetsButton = UnderframeSec:NewButton("Refresh Assets", "Refreshes the asset list.", function()
        UnderframeSelection:Refresh(listfiles("FunkyChart/Assets/"))
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
    UnderframeSelection:Refresh(listfiles("FunkyChart/Assets/"))

    RS.Heartbeat:Connect(function()
        CurrentyLoadedSec:UpdateSection("Currently Loaded: " .. data.chartData.chartName .. " - " .. data.chartData.chartAuthor)

        if data.underframe.enabled then
            UnderframeSec:UpdateSection("Underframe (Enabled)")
        else
            UnderframeSec:UpdateSection("Underframe (Disabled)")
        end
    end)

end

function Init()
    clearAllCurrentFCGuis()
    loadSetup()


    functionHandler(Data, "l")
    loadGUI()

    Announce("Script Loaded", "Welcome to FunkyChart!", 10, "main")
end

Init()