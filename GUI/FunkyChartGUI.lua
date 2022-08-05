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
    v1.21
    Made with ♥ by accountrevived          

    Hello again, and thanks for waiting. I just want to say that the amount of feedback that I've gotten over the past 6+
    months has been incredible. Thank you for using my script and I hope you have fun using it.

    As usual, if at some point you want to fork/modify and re-distribute this script, I would appreciate the credit.







    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!

    [VERSION 1.21]
    - Fixed a bug where playing a chart outside the stage will softlock the game.
        - With this in mind, "Prevent Error Spam Lag" has been permanently enabled, and is not a toggle anymore.

    [VERSION 1.2]

    - New GUI (Venyx by GreenDeno/Stefanuk12 on GitHub)
    - FunkyChart now supports 5K - 9K!!!!
    - Re-written most of the code
    - You now need to accept the agreement in order to use FunkyChart (requested from many people)
    - New notification system
    - Added proper documentation for the Underframe feature
    - FunkyChart now detects what executor you are using as a quality of life improvement.
    - You can now stop a song by using a keybind (Set to 2)
    - New Miscellaneous section for WIP features and such
    - Very cool and very awesome redesigns to Tamshop
    - New splash texts when using FunkyChart
    - Made FunkyChart use less RAM (hopefully, if you get a memory error message tell me ASAP)
    - New save data implementation, should reset your save data.
    - New chart file implementation, reconvert you charts again!
    - Theme Editor (very cool)
    - More bug fixes and QOL improvements

    Thanks for waiting again! :D


    -------------------------------------------------------------------------------------------------


    

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

accept = false

local RS, CAS, TS, START = game:GetService("RunService"), game:GetService("ContextActionService"), game:GetService("TweenService"), game:GetService("StarterGui") 
local errorLagBool, chartLink, currentlyloadedtext, status, errorDesc
destroying, previouslyDestroyed= false, false
local saveDataVersion = "2"

data = {

    chartData = {
        chartNotes = {},
		chartKeys = 4,
        chartName = "None",
        chartNameColor = "<font color='rgb(255, 255, 255)'>%s</font>",
        chartAuthor = "None",
        chartDifficulty = "None",
        chartConverter = "None",
        loadedAudioID = ""
    },

    options = {
        timeOffset = 0,
        side = "Left",
        lastplayed = "",
        version = saveDataVersion,
        console = false
    },

    underframe = {
        enabled = false,
        additionalID = "",
        additionalIDType = "none",
        videoLoop = false,
        transparency = 0,
        color = Color3.fromRGB(0, 0, 0)
    },

    versions = {
        acceptedVersions = {
            "v1.2"
        },
        loadingVersion = "",
        synX = false
    }
}

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/gui-libraries/main/venyx.lua')))()

local venyx = library.new({
    title = "Loading FunkyChart, please wait..."
})

function checkForAgreement()
     if (readfile and isfile and checkIfFileExists("FunkyChartAgreement.txt")) then
        print("Agreement found. True?")
        accept = game:GetService("HttpService"):JSONDecode(readfile("FunkyChartAgreement.txt"))
        
        if accept then
            return
        else
            game.CoreGui[_G.FunkyChartGUI]:Destroy()
            loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/funkychart/main/GUI/FunkyChartAgreement.lua')))()
            return
        end
    else
        game.CoreGui[_G.FunkyChartGUI]:Destroy()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/funkychart/main/GUI/FunkyChartAgreement.lua')))()
        return
    end
end

function isSynapse()
    if string.find(identifyexecutor(), "Synapse") then
        print("Found Synapse")
        return true
    else
        print("Found Krnl or something else")
        return false
    end
end


function console(message, before)
    if data.options.console then
        before = before or ""
        rconsoleprint(before .. "[FunkyChart on " .. os.date("*t").hour .. ":" .. os.date("*t").min .. ":" .. os.date("*t").sec .. "] " .. message .. "\n")
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
    if isfile(link) then
        return true
    else
        return false
    end
end

function checkIfFolderExists(link)
    if isfolder(link) then
        return true
    else
        return false
    end
end

function getGameFramework()
    for _, framework in next, getgc(true) do
        if type(framework) == 'table' and rawget(framework, 'GameUI') then
            return framework
        end
    end
end

function getChartKeyAmount()
    return data.chartData.chartKeys
end

function loadSetup()
    data.versions.synX = isSynapse()
    
    if not game.SoundService:FindFirstChild("ClientMusic") then
        clientMusicInstance = Instance.new("Sound")
        clientMusicInstance.Parent = game.SoundService
        clientMusicInstance.Name = "ClientMusic"
        clientMusicInstance.SoundId = data.chartData.loadedAudioID
        clientMusicInstance.TimePosition = 0
    else
        console("ClientMusic Instance already created.")
    end

    local keyHook = hookfunction(getGameFramework().SongPlayer.GetKeyCount, function(value)
        return data.chartData.chartKeys
    end)

    if checkIfFolderExists("FunkyChart/Audio/") then
        if #listfiles("FunkyChart/Audio/") ~= 0 then
            if data.versions.synX then
                game:GetService("Workspace").Map.FunctionalBuildings.Store.CafeZone.Attachment.CafeMusic.SoundId = getsynasset(listfiles("FunkyChart/Audio/")[math.random(#listfiles("FunkyChart/Audio/"))])
            else
                game:GetService("Workspace").Map.FunctionalBuildings.Store.CafeZone.Attachment.CafeMusic.SoundId = getcustomasset(listfiles("FunkyChart/Audio/")[math.random(#listfiles("FunkyChart/Audio/"))])
            end
        end
    end

    for _,v in pairs(game:GetService("Workspace").Map.FunctionalBuildings.Store.Fanart:GetDescendants()) do
        if v:IsA("Texture") then
            v.Texture = "rbxassetid://9985133915"
        end
    end

end

function manageUnderframe(mode)

    local IDTranslated = ""

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

        console("Underframe applied, not waiting")

        repeat wait() until game.SoundService.ClientMusic.IsPlaying

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
        repeat wait(0.1) until game.Players.LocalPlayer.PlayerGui.GameUI.Arrows.Visible == true

        if data.versions.synX then
            IDTranslated = getsynasset(data.underframe.additionalID)
        else
            IDTranslated = getcustomasset(data.underframe.additionalID)
        end


        print("Now making underframe")

        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Underframe"
        screenGui.DisplayOrder = -10
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = game.Players.LocalPlayer.PlayerGui
        screenGui.ResetOnSpawn = false

        if data.underframe.additionalIDType == "Image" then
            print("Creating an image")
            createImage(IDTranslated, data.underframe.transparency)
            console("Underframe (img) applied")
            return

        elseif data.underframe.additionalIDType == "Video" then
            print("Creating video")
            createVideo(IDTranslated, data.underframe.videoLoop, data.underframe.transparency)
            console("Underframe (vid) applied")
            return
        elseif data.underframe.additionalIDType == "Color Background" then
            print("Creating a coloful background")
            createColor(data.underframe.color, data.underframe.transparency)
            console("Underframe (color) applied")
            return
        else
            print("Nothing was given, so defaulting to black background")
            createColor(Color3.fromRGB(0, 0, 0), data.underframe.transparency)
            console("Underframe (fallback) applied")
            return
        end


    elseif mode == "remove" then

        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Underframe") then
            game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Underframe"):Destroy()
        else
            console("No underframe available")
        end
    else
        console("Account (the developer) is on crack and this somehow happened.")
        return
    end
end

function Announce(messagetitle, messagebody, duration, typeSound)

    console("Announcement - " .. messagetitle .. ": " .. messagebody .. " (" .. tostring(duration) .. " sec as " .. typeSound .. ")")

    START:SetCore("ChatMakeSystemMessage", {
        Text = "[FunkyChart] " .. messagetitle .. ": " .. messagebody,
        Color = Color3.fromRGB(255, 255, 255),
        TextSize = 20})

    venyx:Notify({
        title = messagetitle,
        text = messagebody,
        soundType = typeSound
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

function loadChart(chart, silent, fromGUI, textToUpdate)
    chart = chartLink or data.options.lastplayed
    silent = silent or false
    fromGUI = fromGUI or false
    textToUpdate = textToUpdate or nil

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
    end

    if checkIfFileExists(data.chartData.loadedAudioID) then
        if data.versions.synX then
            console("Synapse mode")
            data.chartData.loadedAudioID = getsynasset(data.chartData.loadedAudioID)
        else
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
        if checkIfFileExists(data.underframe.additionalID) then
            console("Additional ID found")
        else
            console("ERROR - Additional ID not Found! " .. data.underframe.additionalID .. " cannot be found.")
            Announce("Additional ID not Found!", data.underframe.additionalID .. " cannot be found and will be skipped to prevent errors", 10, "error")
            data.underframe.additionalIDType = "none"
        end
    end


    if data.chartData.chartKeys == 0 then
        console("ERROR - Chart key amount was not selected. Ignoring request...")
        Announce("No key amount selected", "Select the number of keys your chart has to load a song.", 10, "error")
        resetData("customChart")
        return
    end

    if not silent then
        Announce("Song Loaded", data.chartData.chartName .. " - " .. data.chartData.chartAuthor, 10, "loaded")
        functionHandler(Data, "s")
    end

    if textToUpdate ~= nil then
        print("Updating text...")
        textToUpdate.Options:Update({
            title = data.chartData.chartName .. " - " .. data.chartData.chartAuthor,
            list = {data.chartData.chartName .. " - " .. data.chartData.chartAuthor, "Difficulty: " .. data.chartData.chartDifficulty, tostring(data.chartData.chartKeys) .. "-key chart", "Has " .. #data.chartData.chartNotes .. " notes", "Underframe = " .. tostring(data.underframe.enabled)}
        })
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
    delfile(filename)
    Announce("Save Data Deleted", "FunkyChart will now be closed. Please re-execute.", 10, "main")
    
    destroying = true
	game.CoreGui[_G.FunkyChartGUI]:Destroy()
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
            chartKeys = 4,
            chartName = "None",
            chartNameColor = "<font color='rgb(255, 255, 255)'>%s</font>",
            chartAuthor = "None",
            chartDifficulty = "None",
            chartConverter = "None",
            loadedAudioID = ""
        }

    elseif choice == "options" then
        data.options = {
            timeOffset = 0,
            side = "Left",
            lastplayed = "",
            version = saveDataVersion,
            console = false
        }
    elseif choice == "sideandoffset" then
        data.options.timeOffset = 0
        data.options.side = "Left"
    end
end

function randomTPStage()
    stagesArray = {}

    for _,v in pairs(game:GetService("Workspace").Map.Stages:GetChildren()) do
        table.insert(stagesArray, v)
    end

    local stagepos = stagesArray[math.random(#stagesArray)].Zone.CFrame

    tweenMove(stagepos)
end

function Chart(preventErrorLag)
    preventErrorLag = preventErrorLag or false
    
    local framework = getGameFramework()

    local chartKeyMaps = {
        ["4"] = {"Tricky_Expurgation", "Hard"},
        ["5"] = {"VSFireboyWatergirl_Flashgames", "Hard"},
        ["6"] = {"VSShaggy_Blast", "Insane"},
        ["7"] = {"VSShaggy_Astralcalamity", "Insane"},
        ["8"] = {"VSMannCo_Frontierjustice", "Hard"},
        ["9"] = {"VSShaggy_Eater", "Insane"}
    }

    print(data.chartData.chartKeys)
    print(chartKeyMaps[tostring(data.chartData.chartKeys)][1])

    if data.chartData.loadedAudioID == "" then
        console("No chart has been loaded!")
        Announce("Load a song", "Load a song first in the Chart Loading menu.", 10, "error")
        return
    else
        randomTPStage()

        console("[NOW PLAYING CHART - " .. data.chartData.chartName .. " WITH preventErrorLag = " .. tostring(preventErrorLag) .. "]", "\n\n")
        Announce("Now Loading", data.chartData.chartName .. " - " .. data.chartData.chartAuthor, 1, "loaded")

        framework.SongPlayer:StartSong(chartKeyMaps[tostring(data.chartData.chartKeys)][1], data.options.side, chartKeyMaps[tostring(data.chartData.chartKeys)][2], {game.Players.LocalPlayer})

        if data.underframe.enabled then
            task.spawn(function()
                print("Here")
                functionHandler(manageUnderframe, "create")
            end)
        end
        

        framework.SongPlayer.CurrentSongData = data.chartData.chartNotes
        framework.Songs[chartKeyMaps[tostring(data.chartData.chartKeys)][1]].Title = data.chartData.chartName
        framework.Songs[chartKeyMaps[tostring(data.chartData.chartKeys)][1]].TitleFormat = data.chartData.chartNameColor
        framework.SongPlayer.TopbarAuthor = "By: " .. data.chartData.chartAuthor .. "\nConverted by: " .. data.chartData.chartConverter
        framework.SongPlayer.TopbarDifficulty = data.chartData.chartDifficulty
        framework.SongPlayer.CountDown = true

        
        game:GetService("SoundService").ClientMusic.SoundId = data.chartData.loadedAudioID
        framework.SongPlayer.CurrentlyPlaying = game:GetService("SoundService").ClientMusic
        framework.SongPlayer:Countdown()
        framework.SongPlayer.CurrentlyPlaying:Play()

        game.Players.LocalPlayer.Character.Torso.Anchored = true

        console("Playing successfully, now waiting for finish")
        
        repeat
            wait()
        until game.SoundService.ClientMusic.IsPlaying == false or framework.SongPlayer.CurrentSongData == nil


        if game.SoundService.ClientMusic.IsPlaying == false then
            framework.SongPlayer:StopSong()
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

function functionHandler(func, a1, a2, a3, a4)
    
    a1 = a1 or nil
    a2 = a2 or nil
    a3 = a3 or nil
    a4 = a4 or nil

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
        status, errorDesc = pcall(func, a1)
        erroredFunction = "manageUnderframe" 
    end

    if not status then
        console("[CRITICAL ERROR] " .. errorDesc .. "\nIn function: ".. erroredFunction .. additionalInfo, "\n\n\n")
        Announce("A critical error occured!", errorDesc .. "\nIn function: ".. erroredFunction .. "\n" .. additionalInfo, 100, "error")
    end

    
end

function loadGUI()
    



	local updateSongDrop
    
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

	local assets = {'None'}

	local credits = {"wally-rblx: AutoPlayer and concept", "Aika: Older GUI (Wally's Hub v3 remake)", "xHeptc: Old GUI (Kavo)", "GreenDeno/Stefanuk12: Current GUI (Venyx)", "Lyte Interactive: making a good rhythm game", "Roblox: Killing audios and fucking up release"}

    local splashes = {
        "Created by accountrevived",
        "gaming",
        "My reaction to that information:",
        "Best script ever made",
        "One chart, unlimited content",
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
        "Touhou is overrated, change my mind"
    }

	local songDetailsDrop = mainSecPlayChart:addDropdown({
		title = songDetails[1],
		list = songDetails
	})

	local playChartButton = mainSecPlayChart:addButton({
		title = "Play Chart!",
		callback = function()
			functionHandler(Chart, errorLagBool)
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
            destroying = true
			game.CoreGui[_G.FunkyChartGUI]:Destroy()
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
			functionHandler(loadChart, chartLink, false, true, songDetailsDrop)

            songDetailsDrop.Options:Update({
                title = data.chartData.chartName .. " - " .. data.chartData.chartAuthor,
                list = {data.chartData.chartName .. " - " .. data.chartData.chartAuthor, "Difficulty: " .. data.chartData.chartDifficulty, tostring(data.chartData.chartKeys) .. "-key chart", "Has " .. #data.chartData.chartNotes .. " notes", "Underframe = " .. tostring(data.underframe.enabled)}
            })
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
			functionHandler(loadChart, chartLink, false, true, songDetailsDrop)
		end
	})

	local playerDrop = optSecGameplay:addToggle({
		title = "Set Player as Right (Player 2)",
		callback = function(value)
			if value then
                data.options.side = "Right"
            else
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
		title = "Apply Changes",
		callback = function()
            print(chartLink)
			functionHandler(loadChart, chartLink, true, true, songDetailsDrop)
            console("Changes have been applied with time offset of " .. tostring(data.options.timeOffset) .. "and player side of " .. tostring(data.options.side))
            Announce("Changes Applied", "Time Offset: " .. tostring(data.options.timeOffset) .. "\nPlayer Side: " .. tostring(data.options.side), 10, "loaded")
		end
	})


	local resetChangesButton = optSecGameplay:addButton({
		title = "Reset to Default",
		callback = function()
			resetData("sideandoffset")
            functionHandler(loadChart, chartLink, true, true, songDetailsDrop)
            console("Changes have been applied with time offset of " .. tostring(data.options.timeOffset) .. "and player side of " .. tostring(data.options.side))
            Announce("Changes Applied", "Time Offset: " .. tostring(data.options.timeOffset) .. "\nPlayer Side: " .. tostring(data.options.side), 10, "loaded")
		end
	})


	local titleSizeSlider = optSecGUI:addSlider({
		title = "Title Size",
		default = 72,
		min = 0,
		max = 500,
		callback = function(value)
			game.Players.LocalPlayer.PlayerGui.GameUI.TopbarLabel.Size = UDim2.new(0.4, 0, 0, value)
		end
	})

	local resetTitleButton = optSecGUI:addButton({
		title = "Reset Size to Default (72)",
		callback = function()
			game.Players.LocalPlayer.PlayerGui.GameUI.TopbarLabel.Size = UDim2.new(0.4, 0, 0, 72)
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

	local UFSelectDrop = UFSecSettings:addDropdown({
		title = "Select Asset",
		list = assets,
        callback = function(text)
            data.underframe.additionalID = text

            if string.match(data.underframe.additionalID:match("^.+(%..+)$"), ".mp4") or string.match(data.underframe.additionalID:match("^.+(%..+)$"), ".webm") then
                print("Video")
                data.underframe.additionalIDType = 'Video'
            elseif string.match(data.underframe.additionalID:match("^.+(%..+)$"), ".png") or string.match(data.underframe.additionalID:match("^.+(%..+)$"), ".jpg") then
                print("Image")
                data.underframe.additionalIDType = 'Image'
            else
                print("File not accepted, color background")
                data.underframe.additionalIDType = 'Color Background'
            end


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
            local title = game.Players.LocalPlayer.PlayerGui.GameUI.TopbarLabel

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
            for i,v in pairs(game:GetService("Workspace").Map:GetChildren()) do
                if v.Name ~= "Floor" and v.Name ~= "Stages" then
                    for j,k in pairs(v:GetChildren()) do
                        k.Parent = game:GetService("ReplicatedStorage").HiddenObjects
                    end
                end
            end

            for i,v in pairs(game:GetService("Workspace").Map.Floor:GetDescendants()) do
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

                wait(0.01)
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

            while true do
                 for i,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") then
                        v.CanCollide = false
                    end
                end

                wait(0.01)

                for i,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") then
                        v.CanCollide = true
                    end
                end

                wait(0.01)
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
                if data.versions.synX then
                    game:GetService("Workspace").Map.FunctionalBuildings.Store.CafeZone.Attachment.CafeMusic.SoundId = getsynasset(listfiles("FunkyChart/Audio/")[math.random(#listfiles("FunkyChart/Audio/"))])
                else
                    game:GetService("Workspace").Map.FunctionalBuildings.Store.CafeZone.Attachment.CafeMusic.SoundId = getcustomasset(listfiles("FunkyChart/Audio/")[math.random(#listfiles("FunkyChart/Audio/"))])
                end
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
			game.SoundService.ClientMusic.Playing = false
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

    local enableConsole = issueSec:addToggle({
        title = "Enable Console",
        callback = function(value)
            data.options.console = value
            functionHandler(Data, "s")
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
        title = data.chartData.chartName .. " - " .. data.chartData.chartAuthor,
        list = {data.chartData.chartName .. " - " .. data.chartData.chartAuthor, "Difficulty: " .. data.chartData.chartDifficulty, tostring(data.chartData.chartKeys) .. "-key chart", "Has " .. #data.chartData.chartNotes .. " notes", "Underframe = " .. tostring(data.underframe.enabled)}
    })

    library.setTitle(venyx, "FunkyChart v1.21 (" .. splashes[math.random(#splashes)] .. ")")
    
    Announce("Script Loaded", "Welcome to FunkyChart!", 10, "main")
end

function Init()
    checkForAgreement()

    if accept then
        loadSetup()
        functionHandler(Data, "l")
        loadGUI()
    end
end

Init()