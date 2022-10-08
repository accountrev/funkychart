--[[

    ██   ██ ███████ ██    ██ ██ 
    ██   ██ ██       ██  ██  ██ 
    ███████ █████     ████   ██ 
    ██   ██ ██         ██       
    ██   ██ ███████    ██    ██ 
                                
    If you downloaded this but don't know what to do, you might've downloaded the wrong zip file!

    THIS IS THE SOURCE CODE! THIS IS NOT THE ACTUAL RUNNABLE PROGRAM ITSELF!

    The actual download is on this link:
    https://github.com/accountrev/funkychart/releases/latest

    Click on the zip file that corresponds with the release version. It should be named like "FunkyChart_vX.X.zip"

    Enjoy!


























        ______            __         ________               __ 
       / ____/_  ______  / /____  __/ ____/ /_  ____ ______/ /_
      / /_  / / / / __ \/ //_/ / / / /   / __ \/ __ `/ ___/ __/
     / __/ / /_/ / / / / ,< / /_/ / /___/ / / / /_/ / /  / /_  
    /_/    \__,_/_/ /_/_/|_|\__, /\____/_/ /_/\__,_/_/   \__/  
                           /____/
    v1.22
    Made with ♥ by accountrevived          

    Hello again, and thanks for waiting. I just want to say that the amount of feedback that I've gotten over the past 6+
    months has been incredible. Thank you for using my script and I hope you have fun using it.

    As usual, if at some point you want to fork/modify and re-distribute this script, I would appreciate the credit.


    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!\
    






--]]

-- Agreement variable
accept = false

-- Services
local RS, CAS, TS, START, PLYRS, SS = game:GetService("RunService"), game:GetService("ContextActionService"), game:GetService("TweenService"), game:GetService("StarterGui"), game:GetService("Players"), game:GetService("SoundService")

-- Player variables
local player = PLYRS.LocalPlayer
local playerGui = player.PlayerGui
local coreGui = game.CoreGui

-- Sound variables
local clientMusic

-- Workspace variables
local stages = workspace.Map.Stages:GetChildren()

-- libraries
local GUILib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/gui-libraries/main/venyx.lua')))()
local consoleLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/simpleconsole-rbx/main/simpleconsole.lua')))()

local venyx = GUILib.new({
    title = "Loading FunkyChart, please wait..."
})

local consoleWindow = consoleLib.new({
    title = "FunkyChart Console",
    titleAlt = "FunkyChart",
    visibleOnStart = false
})

-- Misc. variables
local getlocalasset, framework




-- Checks if functions exists within executor, fails to load if function is not found.
function executorFunctionManager()
    if not identifyexecutor then
        START:SetCore("SendNotification", {Title = "Executor Not Supported", Text = "Your executor is not supported due to a missing function (identifyexecutor)."})
        return false
    elseif not (readfile and writefile and isfile and isfolder and makefolder and listfiles and delfile) then
        START:SetCore("SendNotification", {Title = "Executor Not Supported", Text = "Your executor is not supported due to a missing function (readfile/writefile/isfile/isfolder/makefolder/listfiles/delfile)."})
        return false
    elseif not getgc then
        START:SetCore("SendNotification", {Title = "Executor Not Supported", Text = "Your executor is not supported due to a missing function (getgc)."})
        return false
    elseif not hookfunction then
        START:SetCore("SendNotification", {Title = "Executor Not Supported", Text = "Your executor is not supported due to a missing function (hookfunction)."})
        return false
    elseif not (getsynasset or getcustomasset)  then
        START:SetCore("SendNotification", {Title = "Executor Not Supported", Text = "Your executor is not supported due to a missing function (getsynasset/getcustomasset)."})
        return false
    elseif not setclipboard  then
        START:SetCore("SendNotification", {Title = "Executor Not Supported", Text = "Your executor is not supported due to a missing function (setclipboard)."})
        return false
    else
        getlocalasset = getsynasset or getcustomasset
        return true
    end
end


-- FunkyChart data. This data array holds chart data, version data, option data, and underframe data.
-- When making changes, make sure to reflect on resetData() as well.
-- Remember to keep data.options.version and data.versions.saveDataVersion the same
data = {
    versions = {
        acceptingVersions = {
            "v1.22"
        },
        receivingVersion = "",
        saveDataVersion = "3"
    },

    chartData = {
        chartLoaded = false,
        chartNotes = {},
		chartKeys = 4,
        chartName = "None",
        chartNameColor = "<font color='rgb(255, 255, 255)'>%s</font>",
        chartAuthor = "None",
        chartDifficulty = "None",
        chartConverter = "None",
        loadedAudioID = ""
    },

	-- This portion is used for save data.
    options = {
        timeOffset = 0.1,
        playerRight = false,
        side = "Left",
        version = "3"
    },

    underframe = {
        enabled = false,
        additionalID = "",
        additionalIDType = "none",
        videoLoop = false,
        transparency = 0,
        color = Color3.fromRGB(0, 0, 0)
    }
}








-- Exits FunkyChart, and destroys the console
function Exit()
    consoleWindow:Kill()
	venyx.container:Destroy()
end



-- Checks if the agreement was accepted. I don't want to get blamed by someone who doesn't know how to exploit because they got banned for showing off.
function checkForAgreement()
     if checkIfFileExists("FunkyChartAgreement.txt") then
        consoleWindow:Print("Agreement found. True?")
        accept = game:GetService("HttpService"):JSONDecode(readfile("FunkyChartAgreement.txt"))
        
        if accept then
            return
        else
            venyx.container:Destroy()
            loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/funkychart/main/GUI/FunkyChartAgreement.lua')))()
            return
        end
    else
        venyx.container:Destroy()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/funkychart/main/GUI/FunkyChartAgreement.lua')))()
        return
    end
end


-- Checks if the chart version matches with the current version of FunkyChart.
function versionCheck(versionString)
    for _,v in ipairs(data.versions.acceptingVersions) do
        if versionString == v then
            return true
        end
    end
    return false
end

-- Checks if a file exists, returns bool
function checkIfFileExists(link)
    if isfile(link) then
        return true
    else
        return false
    end
end

-- Checks if a folder exists, returns bool
function checkIfFolderExists(link)
    if isfolder(link) then
        return true
    else
        return false
    end
end

-- Gets the Funky Friday framework
function getGameFramework()
    for _, v in next, getgc(true) do
        if type(v) == 'table' and rawget(v, 'GameUI') then
            return v
        end
    end
end

-- Gets the amount of keys in a loaded chart
function getChartKeyAmount()
    return data.chartData.chartKeys
end

function doEasterEgg()
    for i,v in pairs(game:GetService("Workspace").Map.Props:GetDescendants()) do
        if v:IsA("TextLabel") then
            if v.Text == "Brookhaven Rd" then
                v.Text = "Thanks for using"
            elseif v.Text == "Critical St" then
                v.Text = "FunkyChart <3"
            end
        end
    end

    game:GetService("Workspace").Map.FunctionalBuildings.BigAdBuilding.FunnyCat.Model.main.Beam.Texture = "rbxassetid://10586151186"

    for i,v in pairs(game:GetService("Workspace").Map.FunctionalBuildings.RotundTower.Exterior:GetDescendants()) do
        if v:IsA("Beam") then
            if v.Texture == "rbxassetid://11197878188" or v.Texture == "rbxassetid://11197888064" then
                v.Texture = "rbxassetid://10590477428"
            end
        end
    end

    game:GetService("Workspace").Map.FunctionalBuildings.RotundTower.Exterior.CatMemeSign.Main.Beam.Texture = "rbxassetid://10732694360"
    game:GetService("Workspace").Map.FunctionalBuildings.CheeseShop.ScrollingHoloDisplay.Main.Beam.Texture = "rbxassetid://10761715973"
    game:GetService("Workspace").Map.FunctionalBuildings.BigAdBuilding.CatMemeSign.Main.Beam.Texture = "rbxassetid://"
end


-- Initializes FunkyChart setup.
function initSetup()

    if not SS:FindFirstChild("ClientMusic") then
        clientMusic = Instance.new("Sound")
        clientMusic.Parent = SS
        clientMusic.Name = "ClientMusic"
        clientMusic.SoundId = 0
        clientMusic.TimePosition = 0

        consoleWindow:Success("ClientMusic Instance has been created.")
    else
        clientMusic = SS["ClientMusic"]
        consoleWindow:Print("ClientMusic Instance already created.")
    end

    local keyHook = hookfunction(framework.SongPlayer.GetKeyCount, function(value)
        return getChartKeyAmount()
    end)

    functionHandler(doEasterEgg)

end

-- Creates and manages underframes created during play.
function manageUnderframe(mode)

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
        cover.BackgroundTransparency = math.abs(a3 - 1)
        cover.BorderSizePixel = 0
        cover.Visible = true

        consoleWindow:Print("Underframe applied, not waiting")

        repeat task.wait() until clientMusic.IsPlaying

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
        image.BackgroundTransparency = 0
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
        cover.BackgroundTransparency = math.abs(a2 - 1)
        cover.BorderSizePixel = 0
        cover.Visible = true
    end

    function createColor(a1, a2)
        cover = Instance.new("Frame")
        cover.Name = "Cover"
        cover.AnchorPoint = Vector2.new(0.5, 0.5)
        cover.Parent = screenGui
        cover.Size = UDim2.new(1, 0, 1, 0)
        cover.Position = UDim2.new(0.5, 0, 0.5, 0)
        cover.ZIndex = 0
        cover.BackgroundColor3 = a1
        cover.BackgroundTransparency = math.abs(a2 - 1)
        cover.BorderSizePixel = 0
        cover.Visible = true
    end

    
    if mode == "create" then
        repeat task.wait() until playerGui.GameUI.Arrows.Visible == true

        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Underframe"
        screenGui.DisplayOrder = -10
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = playerGui
        screenGui.ResetOnSpawn = false

        if data.underframe.additionalIDType == "Image" then
            print("Creating an image")
            createImage(getlocalasset(data.underframe.additionalID), data.underframe.transparency)
            consoleWindow:Print("Underframe (img) applied")
            return

        elseif data.underframe.additionalIDType == "Video" then
            print("Creating video")
            createVideo(getlocalasset(data.underframe.additionalID), data.underframe.videoLoop, data.underframe.transparency)
            consoleWindow:Print("Underframe (vid) applied")
            return
        elseif data.underframe.additionalIDType == "Color Background" then
            print("Creating a coloful background")
            createColor(data.underframe.color, data.underframe.transparency)
            consoleWindow:Print("Underframe (color) applied")
            return
        else
            print("Nothing was given, so defaulting to black background")
            createColor(Color3.fromRGB(0, 0, 0), data.underframe.transparency)
            consoleWindow:Print("Underframe (fallback) applied")
            return
        end

    elseif mode == "remove" then
        if playerGui:FindFirstChild("Underframe") then
            playerGui:FindFirstChild("Underframe"):Destroy()
        else
            consoleWindow:Err("No underframe available.")
        end
    else
        consoleWindow:Err("Account (the developer) is on crack and this somehow happened.")
        return
    end
end

function Noti(messagetitle, messagebody, typeSound)
    START:SetCore("ChatMakeSystemMessage", {
        Text = "[FunkyChart] " .. messagetitle .. ": " .. messagebody,
        Color = Color3.fromRGB(255, 255, 255),
        TextSize = 20
    })

    venyx:Notify({
        title = messagetitle,
        text = messagebody,
        soundType = typeSound
    })
end

function loadChart(chart, textToUpdate, silent)
    chart = chart or nil
    silent = silent or false

    data.versions.receivingVersion = ""

    if chart == nil then
        consoleWindow:Err("ChartNotSelectedError - No chart was selected from the Chart Loading list, returning...")
        Noti("No chart selected", "Select a chart from the Chart Loading list.", "error")
        resetData("chart")
        return false
    end

    consoleWindow:Warn("[Loading Song " .. chart .. "] " .. tostring(silent))
    consoleWindow:Print("Checking if a chart was selected...")

    consoleWindow:Success("A chart was selected.")
    consoleWindow:Print("Checking if the chart is an actual file...")

    if checkIfFileExists(chart) then
        consoleWindow:Success("Chart is a file. Loading chart...")
        consoleWindow:Warn("If the script crashes here, there's a good chance that the file is incorrectly made.")
        loadstring(readfile(chart))()
    else
        consoleWindow:Err("FileModifiedError - " .. chart .. " could not be found in FunkyChart/Charts. Was the file moved, deleted, before loading?")
        Noti("Error", chart .. " could not be found. Check the console for more details.", "error")
        resetData("chart")
        return false
    end

    consoleWindow:Success("Chart has been successfully read with no errors. Now verifying chart...")

    if not versionCheck(data.versions.receivingVersion) then
        consoleWindow:Err("ChartVersionUnsupportedError - " .. chart .. " was created using an outdated version of the FunkyChart converter. Version used: " .. data.versions.receivingVersion .. ", please use the updated converter.")
        Noti("Outdated Chart", chart .. " is outdated. Check the console for more details.", "error")
        resetData("chart")
        return false
    end

    consoleWindow:Print("Chart is in correct version. Checking audio file...")

    if checkIfFileExists(data.chartData.loadedAudioID) then
        consoleWindow:Success("Audio file found. Getting custom asset...")

        print(data.chartData.loadedAudioID)
        clientMusic.SoundId = getlocalasset(data.chartData.loadedAudioID)

        consoleWindow:Success("Audio file loaded.")
    else
        consoleWindow:Err("AudioFileNotFoundError - No audio file found. " .. data.chartData.loadedAudioID .. " cannot be found in the Audio folder for " .. chart .. ".")
        Noti("Cannot Find Audio", data.chartData.loadedAudioID .. " is not found. Check the console for more details.", "error")
        resetData("chart")
        return false
    end

    consoleWindow:Print("Checking for underframe...")

    if data.underframe.enabled then
        consoleWindow:Success("Underframe is enabled. Checking if additional ID exists.")

        if checkIfFileExists(data.underframe.additionalID) then
            consoleWindow:Success("Additional ID found.")
        else
            consoleWindow:Err("AdditionalIDNotFoundError - Additional ID was not found. Was the file moved, deleted, before loading? To prevent errors, underframe will be disabled.")
            Noti("Additional ID Not Found", data.underframe.additionalID .. " cannot be found and will be skipped to prevent errors. Check console for details.", "error")
            data.underframe.additionalIDType = "none"
        end
    else
        consoleWindow:Success("Underframe is disabled, skipping procedure.")
    end

    consoleWindow:Print("Trying to update text.")

    if textToUpdate ~= nil then
        textToUpdate.Options:Update({
            title = data.chartData.chartName .. " - " .. data.chartData.chartAuthor,
            list = {data.chartData.chartName .. " - " .. data.chartData.chartAuthor, "Difficulty: " .. data.chartData.chartDifficulty, tostring(getChartKeyAmount()) .. "-key chart", "Has " .. #data.chartData.chartNotes .. " notes", "Underframe = " .. tostring(data.underframe.enabled)}
        })
    else
        consoleWindow:Success("No text to update.")
    end

    if not silent then
        Noti("Song Loaded", data.chartData.chartName .. " - " .. data.chartData.chartAuthor, "loaded")
    end

    consoleWindow:Success("Chart successfully loaded!")

    data.chartData.chartLoaded = true
end

function Data(mode)
    local foldername = "FunkyChart"
    local datafilename = "FunkyChartSaveData.txt"
    local audiofoldername = foldername .. "/Audio"
    local chartfoldername = foldername .. "/Charts"
    local assetsfoldername = foldername .. "/Assets"

    function reset()
        consoleWindow:Warn("Deleting current data...")
        delfile(datafilename)
        Noti("Save Data Deleted", "FunkyChart will now be closed. Please re-execute.", "main")
        Exit()
    end

    function load()
        consoleWindow:Warn("Checking if save data exists...")
        
        if checkIfFileExists(datafilename) then
            consoleWindow:Print("Save data found. Now checking if save data is up to date...")
            data.options = game:GetService("HttpService"):JSONDecode(readfile(datafilename))
            
            if data.options.version ~= data.versions.saveDataVersion then

                consoleWindow:Err("Save data is not up to date and can cause problems. Forcing reset...")
                Noti("Old Save Data", "Your save data was not up to date. Resetting save data.", "error")
                reset()
                return
            else
                consoleWindow:Success("Save data is up to date, and data loaded.")
                Noti("Save Data Loaded", "Welcome back " .. player.Name .. ".", "main")
            end
        else
            consoleWindow:Err("Could not find save data (possibly new player).")
            Noti("Save Data Not Found", "Load a chart to create your save data.", "main")
        end
    end

    function save()
        consoleWindow:Warn("Saving data...")

        local json = game:GetService("HttpService"):JSONEncode(data.options)
        writefile(datafilename, json)
        Noti("Save Data Saved", "Your Options data has been saved!", "main")
        consoleWindow:Success("Data saved.")
    end

    -- to future self, if changing remember to change the strings in functions above as well

    if checkIfFolderExists(foldername) then

        if checkIfFolderExists(audiofoldername) then makefolder(foldername) end
        if checkIfFolderExists(chartfoldername) then makefolder(chartfoldername) end
        if checkIfFolderExists(assetsfoldername) then makefolder(assetsfoldername) end

        if mode == "s" then
            save()
        elseif mode == "l" then
            load()
        elseif mode == "r" then
            reset()
        end
    else
        makefolder(foldername)
        makefolder(audiofoldername)
        makefolder(chartfoldername)
        makefolder(assetsfoldername)

        Noti("First time?", "Looks like you don't have any save data. Load a chart to start.", "main")
    end
end

function resetData(choice)
    consoleWindow:Warn("Data reset initialized for " .. choice .. ".")
    if choice == "chart" then
        data.chartData = {
            chartLoaded = false,
            chartNotes = {},
            chartKeys = 4,
            chartName = "None",
            chartNameColor = "<font color='rgb(255, 255, 255)'>%s</font>",
            chartAuthor = "None",
            chartDifficulty = "None",
            chartConverter = "None",
            loadedAudioID = ""
        }
    elseif choice == "partial" then
        data.options.timeOffset = 0.1
        data.options.playerRight = false
        data.options.side = "Left"
    end
end

function randomTPStage()
    local stage

    function randomSelectStage()
        stage = stages[math.random(#stages)]
        consoleWindow:Print("Picked stage " .. stage.Name)
        if stage.Name == "WreckedStage" or stage.Name == "FinalEscapeStage" then randomSelectStage() end
    end

    randomSelectStage()

    local tween = TS:Create(player.Character.HumanoidRootPart, TweenInfo.new(0.5), {CFrame = stage.Zone.CFrame})
	tween:Play()
    tween.Completed:Wait()
end

function Chart()
    local chartKeyMaps = {
        ["4"] = {"Tricky_Expurgation", "Hard"},
        ["5"] = {"VSFireboyWatergirl_Flashgames", "Hard"},
        ["6"] = {"VSShaggy_Blast", "Insane"},
        ["7"] = {"VSShaggy_Astralcalamity", "Insane"},
        ["8"] = {"VSMannCo_Frontierjustice", "Hard"},
        ["9"] = {"VSShaggy_Eater", "Insane"}
    }

    if not data.chartData.chartLoaded then
        consoleWindow:Err("No chart has been loaded, ignoring...")
        Noti("No Chart Loaded", "Load a chart first in the Chart Loading menu.", "error")
        return
    else
        randomTPStage()

        consoleWindow:Warn("[Now Playing Chart - " .. data.chartData.chartName .. "]")
        consoleWindow:Warn("If something goes wrong, there's a good chance that the audio file/chart file was read incorrectly.")
        Noti("Now Playing", data.chartData.chartName .. " - " .. data.chartData.chartAuthor, "loaded")

        framework.SongPlayer:StartSong(chartKeyMaps[tostring(getChartKeyAmount())][1], data.options.side, chartKeyMaps[tostring(getChartKeyAmount())][2], {player})


        if data.underframe.enabled then
            task.spawn(function()
                functionHandler(manageUnderframe, "create")
            end)
        end

        framework.SongPlayer.CurrentSongData = data.chartData.chartNotes
        framework.Songs[chartKeyMaps[tostring(getChartKeyAmount())][1]].Title = data.chartData.chartName
        framework.Songs[chartKeyMaps[tostring(getChartKeyAmount())][1]].TitleFormat = data.chartData.chartNameColor
        framework.SongPlayer.TopbarAuthor = "By: " .. data.chartData.chartAuthor .. "\nConverted by: " .. data.chartData.chartConverter
        framework.SongPlayer.TopbarDifficulty = data.chartData.chartDifficulty
        framework.SongPlayer.CountDown = true

        clientMusic.SoundId = getlocalasset(data.chartData.loadedAudioID)
        framework.SongPlayer.CurrentlyPlaying = clientMusic
        framework.SongPlayer:Countdown()
        framework.SongPlayer.CurrentlyPlaying:Play()

        player.Character.Humanoid.WalkSpeed = 0

        consoleWindow:Success("Now playing successfully, waiting for the chart to finish.")
        
        repeat
            task.wait()
        until clientMusic.IsPlaying == false or framework.SongPlayer.CurrentSongData == nil


        if clientMusic.IsPlaying == false then
            framework.SongPlayer:StopSong()
        end

        if data.underframe.enabled then
            task.spawn(function()
                functionHandler(manageUnderframe, "remove")
            end)
        end

        clientMusic.Playing = false
        clientMusic.TimePosition = 0
        player.Character.Humanoid.WalkSpeed = 24

        consoleWindow:Success("Chart finished.")
    end
end

function functionHandler(func, a1, a2, a3)
    local status, errorDesc

    a1 = a1 or nil
    a2 = a2 or nil
    a3 = a3 or nil
    a4 = a4 or nil

    local erroredFunction
    local additionalInfo = " Please report this!"

    if func == loadChart then
        status, errorDesc = pcall(func, a1, a2, a3)
        erroredFunction = "Chart file (loadChart function). Check the console for more details."
        additionalInfo = " Chart has have been read incorrectly or an actual error in the function. Please report this!"
        
    elseif func == Chart then
        status, errorDesc = pcall(func)
        erroredFunction = "Chart function. Check the console for more details."
    elseif func == Data then 
        status, errorDesc = pcall(func, a1)
        erroredFunction = "Data function. Check the console for more details."
    elseif func == manageUnderframe then 
        status, errorDesc = pcall(func, a1)
        erroredFunction = "manageUnderframe function. Check the console for more details."
    elseif func == doEasterEgg then 
        status, errorDesc = pcall(func)
        erroredFunction = "doEasterEgg function. Check the console for more details."
        additionalInfo = " This probably means the map has been changed. Please report this!"
    end

    if not status then
        consoleWindow:Err("[CRITICAL ERROR] " .. errorDesc .. "\nIn function: ".. erroredFunction .. additionalInfo)
        Noti("A critical error occured!", errorDesc .. "\nIn function: ".. erroredFunction, "error")
    end
end



function loadGUI()
	local updateSongDrop, chartLink
    
    local localThemes = {
		Background = Color3.fromRGB(0, 0, 0),
		Glow = Color3.fromRGB(80, 36, 201),
		Accent = Color3.fromRGB(80, 36, 201),
		LightContrast = Color3.fromRGB(35, 35, 36),
		DarkContrast = Color3.fromRGB(14, 14, 14),  
		TextColor = Color3.fromRGB(255, 255, 255)
	}


	local pageMain = venyx:addPage({
		title = "Main"
	})

	local pageCL = venyx:addPage({
		title = "Chart Loading"
	})

	local pageOpt = venyx:addPage({
		title = "Options"
	})

	local pageUF = venyx:addPage({
		title = "Underframe"
	})

    local pageMisc = venyx:addPage({
        title = "Miscellaneous"
    })

	local pageKB = venyx:addPage({
		title = "Keybinds"
	})

	local pageCred = venyx:addPage({
		title = "Credits"
	})

	local pageIssue = venyx:addPage({
		title = "Issues?"
	})

	local pageTheme = venyx:addPage({
		title = "Theme Editor"
	})



	---------------------------------------------------

	local mainSecPlayChart = pageMain:addSection({
		title = "Currently Loaded Chart"
	})

	local CLSecChartLoad = pageCL:addSection({
		title = "Chart Loading"
	})

	local CLSecManual = pageCL:addSection({
		title = "Manual Select"
	})

	local optSecGameplay = pageOpt:addSection({
		title = "Gameplay"
	})

	local optSecGUI = pageOpt:addSection({
		title = "GUI"
	})

	local optSecSave = pageOpt:addSection({
		title = "Save Data"
	})

	local UFSecGeneral = pageUF:addSection({
		title = "Underframe"
	})

	local UFSecSettings = pageUF:addSection({
		title = "Settings"
	})

    local MiscGeneral = pageMisc:addSection({
		title = "These options are experimental, don't report if these break"
	})

	local KBSec = pageKB:addSection({
		title = "Keybinds"
	})

	local credSec = pageCred:addSection({
		title = "Thanks to..."
	})

	local issueSec = pageIssue:addSection({
		title = "Questions or Bugs? Report them!"
	})

	local colors = pageTheme:addSection({
		title = "Colors"
	})

	-----------------------------

	local songDetails = {}

	local charts = {}

	local playerSide = {"Left", "Right"}

	local assets = {'Color Background'}

	local credits = {"wally-rblx: AutoPlayer and concept", "Aika: Older GUI (Wally's Hub v3 remake)", "xHeptc: Old GUI (Kavo)", "GreenDeno/Stefanuk12: Current GUI (Venyx)", "Lyte Interactive: making a good rhythm game", "Roblox: Killing audios and fucking up release"}

    local splashes = {
        "Created by accountrevived",
        "gaming",
        "My reaction to that information:",
        "Best script ever made",
        "One script, unlimited content",
        "Not afffiliated with Lyte Interactive",
        "Lyte would never add custom charting",
        "Mai-san my beloved",
        "Now with 99% spaghetti code!",
        "Plz give free points",
        "v1.3 coming never",
        "Technoblade never dies",
        "A critical error occured!",
        "I am in genuine pain",
        "Killing fingers, one chart at a time",
        "Im dead 💀💀💀",
        "DO NOT CODE SCRIPTS AT 3AM (SLEEP SCHEDULE RUINED)",
        "RSI mode enabled",
        "727 👈 727 WYSI WYFSI!!!!!!!!",
        "Optimization has been turned off",
        "4",
        "I hate my life",
        "HIT MOAR NOTES",
        "STANDING HERE I REALIZE",
        "soup",
        "Mike",
        "lyte please fix 0 second notes!!!!",
        "touhou underrated",
		"SYNAPSE ROCKS!!!!",
        "pls stop crashing",
        "Unfortunately, Synapse X has crashed."
    }

	local songDetailsDrop = mainSecPlayChart:addDropdown({
		title = songDetails[1],
		list = songDetails
	})

	local playChartButton = mainSecPlayChart:addButton({
		title = "Play Chart!",
		callback = function()
			functionHandler(Chart)
		end
	})

	local autoplayerButton = mainSecPlayChart:addButton({
		title = "Load Auto-player",
		callback = function()
			loadstring(game:HttpGet(('https://raw.githubusercontent.com/wally-rblx/funky-friday-autoplay/main/main.lua')))()
		end
	})

    local closeGUIButton = mainSecPlayChart:addButton({
        title = "Destroy GUI",
		callback = function()
            Exit()
		end
    })

	local chartDrop = CLSecChartLoad:addDropdown({
		title = "Select Chart",
		list = charts,
        callback = function(text)
            chartLink = text
        end
	})


	local loadChartButton = CLSecChartLoad:addButton({
		title = "Load Chart",
		callback = function()
			functionHandler(loadChart, chartLink, songDetailsDrop, false)
		end
	})


	local refreshChartButton = CLSecChartLoad:addButton({
		title = "Refresh Chart List",
		callback = function()
			chartDrop.Options:Update({
                list = listfiles("FunkyChart/Charts/")
            })
		end
	})


	local manualFileTB = CLSecManual:addTextbox({
		title = "File Location",
		default = "Type Here",
		callback = function(value, focusLost)
			if focusLost then
				chartLink = value
			end
		end
	})


	local loadManualButton = CLSecManual:addButton({
		title = "Load Chart",
		callback = function()
			functionHandler(loadChart, chartLink, songDetailsDrop, false)
		end
	})

	local playerDrop = optSecGameplay:addToggle({
		title = "Set Player as Right (Player 2)",
        default = data.options.playerRight,
		callback = function(value)
			if value then
                data.options.playerRight = true
                data.options.side = "Right"
            else
                data.options.playerRight = false
                data.options.side = "Left"
            end
		end
	})

	local timeOffsetSlider = optSecGameplay:addSlider({
		title = "Time Offset",
		default = 0,
		min = -500,
		max = 500,
		callback = function(value)
			data.options.timeOffset = value / 1000
            print(data.options.timeOffset, value)
            
		end
	})


	local applyChangesButton = optSecGameplay:addButton({
		title = "Apply To Chart",
		callback = function()
            print(chartLink)
			functionHandler(loadChart, chartLink, songDetailsDrop, true)
            functionHandler(Data, "s")
            consoleWindow:Print("Changes have been applied with time offset of " .. tostring(data.options.timeOffset) .. "and player side of " .. tostring(data.options.side))
            Noti("Changes Applied", "Time Offset: " .. tostring(data.options.timeOffset) .. "\nPlayer Side: " .. tostring(data.options.side), "loaded")
		end
	})


	local resetChangesButton = optSecGameplay:addButton({
		title = "Reset to Default",
		callback = function()
			resetData("partial")
            functionHandler(loadChart, chartLink, songDetailsDrop, true)
            consoleWindow:Print("Changes have been applied with time offset of " .. tostring(data.options.timeOffset) .. "and player side of " .. tostring(data.options.side))
            Noti("Changes Applied", "Time Offset: " .. tostring(data.options.timeOffset) .. "\nPlayer Side: " .. tostring(data.options.side), "loaded")
		end
	})


	local titleSizeSlider = optSecGUI:addSlider({
		title = "Title Size",
		default = 72,
		min = 0,
		max = 500,
		callback = function(value)
			playerGui.GameUI.TopbarLabel.Size = UDim2.new(0.4, 0, 0, value)
		end
	})

	local resetTitleButton = optSecGUI:addButton({
		title = "Reset Size to Default (72)",
		callback = function()
			playerGui.GameUI.TopbarLabel.Size = UDim2.new(0.4, 0, 0, 72)
		end
	})


	local deleteSaveButton = optSecSave:addButton({
		title = "DELETE CURRENT SAVE (use if needed)",
		callback = function()
			functionHandler(Data, "r")
		end
	})

	local enableUnderToggle = UFSecGeneral:addToggle({
		title = "Underframe Enabled",
		callback = function(value)
			data.underframe.enabled = value
		end
	})

    local UFSelectDrop = UFSecGeneral:addDropdown({
		title = "Select Asset",
		list = assets,
        callback = function(text)
            data.underframe.additionalID = text

            extension = string.lower(data.underframe.additionalID:match("^.+(%..+)$"))

            if string.match(extension, ".mp4") or string.match(extension, ".webm") then
                print("Video")
                data.underframe.additionalIDType = 'Video'
            elseif string.match(extension,".png") or string.match(extension, ".jpg") then
                print("Image")
                data.underframe.additionalIDType = 'Image'
            else
                print("File not accepted, color background")
                data.underframe.additionalIDType = 'Color Background'
            end


        end
	})

    local UFTransparencyBox = UFSecSettings:addSlider({
		title = "Transparency (%)",
		default = 0,
		min = 0,
		max = 100,
		callback = function(value)
			data.underframe.transparency = value / 100
            print(data.underframe.transparency)
		end
	})

	

    local UFBackgroundColor = UFSecSettings:addColorPicker({
        title = "Set Color Background's Color", 
        default = Color3.fromRGB(0, 0, 0), 
        callback = function(color3)
            data.underframe.color = color3
        end
    })

	local UFvideoLoopingToggle = UFSecSettings:addToggle({
		title = "Video Looping",
		callback = function(value)
			data.underframe.videoLoop = value
		end
	})

	local UFrefreshAssetsButton = UFSecSettings:addButton({
		title = "Refresh Assets List",
        callback = function()
            UFSelectDrop.Options:Update({
                list = {'None', table.unpack(listfiles("FunkyChart/Assets/"))}
            })
        end
	})

    

    local TEST_Title = MiscGeneral:addButton({
        title = "Custom Title",
        callback = function()
            local title = playerGui.GameUI.TopbarLabel

            title.AnchorPoint = Vector2.new(0, 1)
            title.BackgroundTransparency = 0
            title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            title.BorderSizePixel = 0
            title.Font = Enum.Font.GothamBlack
            title.LineHeight = 1.2
            title.Position = UDim2.new(0, 0, 1, 0)
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 1

            
        end

    })

    local TEST_Workspace = MiscGeneral:addButton({
        title = "Ultimate Lag Remover (it kills workspace)",
        callback = function()
            for i,v in pairs(workspace.Map:GetChildren()) do
                if v.Name ~= "Floor" and v.Name ~= "Stages" then
                    for j,k in pairs(v:GetChildren()) do
                        k.Parent = game:GetService("ReplicatedStorage").HiddenObjects
                    end
                end
            end

            for i,v in pairs(workspace.Map.Floor:GetDescendants()) do
                if v.ClassName == "Part" or v.ClassName == "UnionOperation" or v.ClassName == "MeshPart" or v.ClassName == "Texture" then
                    v.Transparency = 1
                end
            end

            game.Lighting:ClearAllChildren()

            game.Lighting.ClockTime = 0
        end
    })

    local TEST_keyAmountDrop = MiscGeneral:addDropdown({
		title = "Key Amount",
		list = {"4", "5", "6", "7", "8", "9"},
        callback = function(text)
            data.chartData.chartKeys = tonumber(text)
        end
	})

    local TEST_Avatar1 = MiscGeneral:addToggle({
		title = "Random color avatar thing",
		callback = function(value)
			while value do
                game.ReplicatedStorage.RF:InvokeServer({"Server", "CharacterManager", "ApplyOutfit"}, {
                '{"HumanoidDescription":{"LeftArmColor":{"__Color3":[' .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. ']}, "RightArmColor":{"__Color3":[' .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. ']}, "LeftLegColor":{"__Color3":[' .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. ']}, "RightLegColor":{"__Color3":[' .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. ']}, "HeadColor":{"__Color3":[' .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. ']}, "TorsoColor":{"__Color3":[' .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. "," .. tostring((math.random(0, 255))/255) .. ']}}}',
                "R6"
                })

                task.wait()
		    end
        end
	})


    local TEST_Workspace2 = MiscGeneral:addButton({
        title = "Earthqukae workspace",
        callback = function()
            for i,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") then
                    v.Anchored = false
                end
            end

            while task.wait() do
                 for i,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") then
                        v.CanCollide = false
                    end
                end

                task.wait()

                for i,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") then
                        v.CanCollide = true
                    end
                end

                task.wait()
            end
        end
    })

    local TEST_ExtractChart = MiscGeneral:addButton({
        title = "Extract Current Chart",
        callback = function()
            local json = game:GetService("HttpService"):JSONEncode(getGameFramework().SongPlayer.CurrentSongData)
            writefile("ExtractedChart.txt", json)
        end
    })

    local TEST_Touhou = MiscGeneral:addButton({
        title = "Change Music Ambience",
        callback = function()
            if #listfiles("FunkyChart/Audio/") ~= 0 then
                workspace.Map.FunctionalBuildings.Store.CafeZone.Attachment.CafeMusic.SoundId = getlocalasset(listfiles("FunkyChart/Audio/")[math.random(#listfiles("FunkyChart/Audio/"))])
            end
        end
    })

	local KBhideGUIKey = KBSec:addKeybind({
		title = "Toggle GUI",
		key = Enum.KeyCode.One,
		callback = function()
			venyx:toggle()
		end,
		changedCallback = function(key)
			venyx:Notify({
				text = "Changed keybind to " .. tostring(key),
				title = "Keybind Changed"
			})
		end
	})

    local KBhideGUIKey = KBSec:addKeybind({
		title = "Stop Song",
		key = Enum.KeyCode.Two,
		callback = function()
			clientMusic.Playing = false
		end,
		changedCallback = function(key)
			venyx:Notify({
				text = "Changed keybind to " .. tostring(key),
				title = "Keybind Changed"
			})
		end
	})

	local consoleKey = KBSec:addKeybind({
		title = "Toggle Console",
		key = Enum.KeyCode.Minus,
		callback = function()
			consoleWindow:Toggle()
		end,
		changedCallback = function(key)
			venyx:Notify({
				text = "Changed keybind to " .. tostring(key),
				title = "Keybind Changed"
			})
		end
	})

	local credDrop = credSec:addDropdown({
		default = "Thanks to...",
		list = credits,
        callback = function(text)
            if text == credits[1] then
                setclipboard("https://github.com/wally-rblx/funky-friday-autoplay")
                venyx:Notify({
                    text = "Copied link to clipboard.",
                    title = "Link copied"
                })
                return
            elseif text == credits[2] then
                setclipboard("https://v3rmillion.net/showthread.php?tid=1040650")
                venyx:Notify({
                    text = "Copied link to clipboard.",
                    title = "Link copied"
                })
                return
            elseif text == credits[3] then
                setclipboard("https://v3rmillion.net/showthread.php?tid=1094901")
                venyx:Notify({
                    text = "Copied link to clipboard.",
                    title = "Link copied"
                })
                return
            elseif text == credits[4] then
                setclipboard("https://github.com/Stefanuk12/Venyx-UI-Library")
                venyx:Notify({
                    text = "Copied link to clipboard.",
                    title = "Link copied"
                })
                return
            elseif text == credits[5] then
                setclipboard("https://www.roblox.com/games/6445973668/gaming")
                venyx:Notify({
                    text = "Copied link to clipboard.",
                    title = "Link copied"
                })
                return
            else
                return
            end
        end
	})

	local githubIssuesButton = issueSec:addButton({
		title = "Report on GitHub",
		callback = function()
			setclipboard("https://github.com/accountrev/funkychart/issues")
			venyx:Notify({
				text = "Copied link to clipboard.",
				title = "Link Copied"
			})
		end
	})

	local discordIDButton = issueSec:addButton({
		title = "Copy Discord ID",
		callback = function()
			setclipboard("accountrevived#0686")
			venyx:Notify({
				text = "Copied ID to clipboard.",
				title = "Discord ID Copied",
				soundType = "main"
			})
		end
	})

	for i, v in pairs(localThemes) do
		print(i, v)
		colors:addColorPicker({
			title = i, 
			default = v, 
			callback = function(color3)
				print(color3)
				venyx:setTheme({
					theme = i, 
					color3 = color3
				})
			end
		})
	end

	venyx:SelectPage({
		page = venyx.pages[1], 
		toggle = true
	})

    chartDrop.Options:Update({
        list = listfiles("FunkyChart/Charts/")
    })

    UFSelectDrop.Options:Update({
        list = {'None', table.unpack(listfiles("FunkyChart/Assets/"))}
    })

    songDetailsDrop.Options:Update({
        title = "No Chart Loaded",
        list = {"Load a chart to show its data."}
    })

    GUILib.setTitle(venyx, "FunkyChart v1.22 (" .. splashes[math.random(#splashes)] .. ")")
    
    Noti("Script Loaded", "Welcome to FunkyChart!", "main")
end

function Init()
    if executorFunctionManager() then
        checkForAgreement()
        if accept then
            framework = getGameFramework()
            initSetup()
            functionHandler(Data, "l")
            loadGUI()
        else
            return
        end
    else
        return
    end
end

Init()