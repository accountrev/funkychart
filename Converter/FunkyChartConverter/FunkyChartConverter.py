"""

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
      / /_  / / / / __ \/ //_/ / / / /   / __ \/ __ `/ ___/ __/     Converter
     / __/ / /_/ / / / / ,< / /_/ / /___/ / / / /_/ / /  / /_       Version 1.2
    /_/    \__,_/_/ /_/_/|_|\__, /\____/_/ /_/\__,_/_/   \__/  
                           /____/                              

    -- INTRODUCTION --

    Hello.

    I present you a rewrite of the converter that is used in FunkyChart v1.2+.
    The rewrite organizes and optimizes the code so that it is easier to manage and understand,
    and makes the converter easier to use for the consumer.
    This is mostly rushed, but as time goes on I'll make some changes when I can.
    

    If you know what you're doing, I hope I made my comments as easy to understand. Some parts may be questionable, but if you have any questions or contributions 
    feel free to make a suggestion on GitHub (as an issue or pull request) and I'll look into it!

    If you want to re-use some of my code or the entire project, feel free to fork. I would appreciate giving me credit as well :)

    -------------------


    -- INFO --

    This version is running on Python 3.10.5

    Packages installed:
    colorama
    requests
    pyinstaller (compiler)

    -----------


    -- COMPILE INSTRUCTIONS (FOR WINDOWS 8+ ONLY) --

    1. Install the packages above on Python 3.10.5.
    2. Open Command Prompt or Windows PowerShell
    3. Navigate to the folder that holds the source code for FunkyChart, specifically the one that has the .py and .pyproj file.
    4. Copy and paste the command below:

    pyinstaller -F -n FunkyChartConverter -i icon.ico --hidden-import colorama FunkyChartConverter.py

    5. Wait for compile.
    6. When pyinstaller successfully compiles the program, the executable file will be in the 'dist' folder as FunkyChartConverter.exe. Done.

    --------------------








    !!! Please report any bugs/questions over on the Issues tab on GitHub !!!

    [VERSION 1.2]

    -   The converter finally gets a necessary re-write!
    -   Added support for 5K, 6K, 7K, 8K, and 9K maps
    -   The converter now requires you to show FunkyChart folder instead of selecting multiple folders for saving the audio and chart.
    -   The converter now checks if the GitHub servers are working or not (just in case if GitHub goes down, the converter is still usable)
    -   The converter now checks if the osu! client is installed on the default location (being %APPDATA%\Local\osu!) (if you are suspicious, take a look at the code)
        -   Allows for immediate access to the osu! folder when selecting a chart. If osu! not found then go back to C drive



    -------------------------------------------------

    [VERSION 1.11]

    -   Made major changes to chart converting again (all chart before 1.11 are again invalid lol)
    -   Added a feature where you can now name the chart file when converting!
    -   Added a waiting screen when converting (this is to make people not click too early when its converting).



    [VERSION 1.1]

    -   Made major changes to chart converting (all charts before 1.1 are now invalid, sorry :( )
    -   Fixed a bug with file path directory erroring out
    -   Cleaned up title (not really just added verison as a variable lol)

    -------------------------------------------------

    [VERSION 1.05]

    -   Added update notifier for future updates.
    -   _G.customChart.loadedAudioID does not use getcustomasset or getsynasset anymore, will be done in-game.


    [VERSION 1.04]

    -   Testing support for the Krnl executor

    [VERSION 1.03]

    -   Fixed an issue with file saving where the converted chart couldn't save correctly. Haha...

    [VERSION 1.02]

    -   Fixed an error where the colorama module was not found.
    -   Made it so that the Tk window does not pop up everytime it asks for a file.
    -   Fixed an error when you copy an audio file and place it in the same folder (SameFileError).

    [VERSION 1.01 - DELAYED]

    -   Delayed released due to Roblox's audio privacy update.
    -   Rewritten the program, commenting Krnl references and online mode.
    -   Other fixes

    [VERSION 1.0 - INITIAL RELEASE]

    -   Initial release
    -   Rewrote some lines for the 4v4 update on FF before release.
    -   Organization


"""




import os, re, time, shutil, requests, webbrowser, random, sys
import msvcrt as kb
import colorama as clr
import tkinter as tk
from tkinter import filedialog as fd
from tkinter import colorchooser as cc

# Required for colorama's colored text to work.
clr.init()

# Required to hide tkinter's pesky window on start.
hiddenWindow = tk.Tk()
hiddenWindow.withdraw()



version = 'v1.2'
loadingVersion = 'v1.2'

splash = r'''    ______            __         ________               __     ______                           __           
   / ____/_  ______  / /____  __/ ____/ /_  ____ ______/ /_   / ____/___  ____ _   _____  _____/ /____  _____
  / /_  / / / / __ \/ //_/ / / / /   / __ \/ __ `/ ___/ __/  / /   / __ \/ __ \ | / / _ \/ ___/ __/ _ \/ ___/
 / __/ / /_/ / / / / ,< / /_/ / /___/ / / / /_/ / /  / /_   / /___/ /_/ / / / / |/ /  __/ /  / /_/  __/ /    
/_/    \__,_/_/ /_/_/|_|\__, /\____/_/ /_/\__,_/_/   \__/   \____/\____/_/ /_/|___/\___/_/   \__/\___/_/     ''' + version + '''
                       /____/                                                                                

Made with ♥ by accountrevived
'''






parsedOsuFile = {
    'hitobjects' : [],
    'assets' : ()
}


osuFileChecks = {
    'Mode' : False,
    'Title' : False,
    'Artist' : False,
    'Creator' : False,
    'Version' : False,
    'CircleSize' : False
}



textColors = {
    'r' : clr.Fore.LIGHTRED_EX + clr.Style.BRIGHT,
    'w' : clr.Fore.WHITE + clr.Style.BRIGHT,
    'g' : clr.Fore.LIGHTGREEN_EX + clr.Style.BRIGHT,
    'y' : clr.Fore.LIGHTYELLOW_EX + clr.Style.BRIGHT,
    'b' : clr.Fore.LIGHTCYAN_EX + clr.Style.BRIGHT,
    'p' : clr.Fore.MAGENTA + clr.Style.BRIGHT
}





outputedChartDetails = {
    'chartName' : None,
    'chartKeys' : None,
    'chartSongArtist' : None,
    'chartAuthor' : None,
    'chartDifficulty' : None,
    'chartConverter' : None,
    'fontColor' : None
}




fileTypes = {
    'osu' : [('osu! Beatmap File', '*.osu')],
    'audio' : (('MP3 File', '*.mp3'), ('WAV File', '*.wav')),
    'txt' : [('Text File', '*.txt')],
    'asset' : [('Accepted files', '*.png *.jpg *.mp4 *.webm')]
}

inputOutputDetails = {
    'funkyFolder' : None,
    'audioFile' : None,
    'audioName' : None,
    'chartFileName' : None
}


# Text stuff

disableClearing = False

def cls():
    if not disableClearing:
        os.system('cls' if os.name=='nt' else 'clear')
        print(textColors['p'] + splash + textColors['w'])

def cprint(text):
    cls()
    print(textColors['b'] + text + textColors['w'])

def warn(text):
    print(textColors['y'] + text + textColors['w'])

def error(text):
    print(textColors['r'] + text + textColors['w'])


def setOsuCheck(check, boolean):
    osuFileChecks[check] = boolean

def setChartDetails(dataName, data):
    outputedChartDetails[dataName] = data

def setIODetails(dataName, data):
    inputOutputDetails[dataName] = data


def keySystem(*args):
    while True:
        getKey = kb.getch().decode('ASCII')
        if getKey in args:
            return getKey


    


# Error handler - to prevent exceptions from happening when using the converter
def errorHandler(errorCode = 99, exiting=True, addErrorInfo = {}):
    cls()

    # Python 3.10.5 finally introduced C++ switch statements :)
    
    match errorCode:
        case 0:
            error('ERROR 00: Something went wrong, please try again or restart the converter to continue.')
        case 1:
            error('ERROR 01: The username you provided exceeds the character limit (24). Please enter a proper username.')
        case 2:
            error('ERROR 02: The File Explorer was closed and no file/directory was selected. Please select a file/directory when asked.')
        case 3:
            error('ERROR 03: Something is wrong with the beatmap you selected. Please try again and refer to the data below.')
            print(str(addErrorInfo))
        case 4:
            error('ERROR 04: This beatmap is not designed for osu!mania. Please select an actual osu!mania beatmap file.')
        case 5:
            error('ERROR 05: This beatmap is designed with a higher/lower amount of keys in mind. Please select a map that supports 4K - 9K.')
        case 6:
            error('ERROR 06: Something went wrong while parsing the beatmap\'s notes. Please try again or choose a different beatmap.')
        case 7:
            error('ERROR 07: Invalid name, only use alphabet characters and a limit of 16 characters. Please try again.')
        case 8:
            error('ERROR 08: The converter tried to connect to the GitHub servers for verification, but has timed out. Is GitHub down?')
        case 9:
            error('ERROR 09: The converter tried to connect to the internet but failed. Are you connected to the internet?')
        case 10:
            error('ERROR 10: Something is wrong with your FunkyChart folder, or it may not be the right folder. Please try again.')
        case _:
            error('ERROR 99: Something went wrong, please try again or restart the converter to continue.')
    
    if exiting:
        error('\nPress "A" to exit the converter.')

        closeKey = keySystem('a')
        match closeKey:
            case 'a':
                sys.exit(0)



# Filters .osu file to sentences in a list
def filterFile(list):
    newList = []

    for line in list:
        if not line.isspace():
            newList.append(re.sub('[\n\r]+', '', line))

    return newList


# Filters a line from the list into two:
# EX:   Name: Sample Name
#       ("Name:", "Sample Name")
def filterData(item):

    filteredItem = re.search('([a-zA-Z0-9]+)[ ]*:[ ]*(.+)$', item)

    if filteredItem is None:
        filteredItem = ['', '']

    return filteredItem

#Sometimes, beatmaps will have a sound file name at the end of a HitObject. This function removes that.
def filterSound(list):

    if not list[-1].isdigit():
        list.remove(list[-1])

    return list

def directoryExists(dir):
    return os.path.isdir(dir)

def fileExists(file):
    return os.path.isfile(file)

def checkForOsu():
    #if not directoryExists(os.getenv('LOCALAPPDATA') + "\osu!"):
    if not directoryExists('D:\osu!'):
        return False
    else:
        return True




# Update Notifier - notifies if a new verison is available on GitHub
def githubUpdateChecker():
    


    requestedVersion = ""
    verified = True

    cls()
    print("Connecting to GitHub...")

    try:
        requestedVersion = requests.get('https://api.github.com/repos/accountrev/funkychart/releases/latest', timeout = 15).json()['tag_name']
    except requests.exceptions.Timeout:
        errorHandler(8, False)
        verified = False
    except requests.exceptions.ConnectionError:
        errorHandler(9, False)
        verified = False
    finally:
        if verified:
            if requestedVersion > version:
                cls()
                warn('There is a new version of FunkyChart available on GitHub! Please download the newer version to avoid errors.\nYou are using ' + version + ', while the latest version is ' + requestedVersion + '.\n\n')
                
                print('You can still use this converter if you\'d like. Would you like to keep using the converter?\n\nPress "Y" to continue using or "N" to exit. Alternatively, press "A" to open GitHub in your browser and exit.')

                ignoreKey = keySystem('y', 'n', 'a')
                
                match ignoreKey:
                    case 'y':
                        return
                    case 'n':
                        sys.exit(0)
                    case 'a':
                        webbrowser.open('https://github.com/accountrev/funkychart/releases/latest')
                        sys.exit(0)
            return
        else:
            cls()
            print('You can still use this converter if you\'d like. Would you like to keep using the converter?\n\nPress "Y" to continue using or "N" to exit.')

            ignoreKey = keySystem('y', 'n')
                
            match ignoreKey:
                case 'y':
                    return
                case 'n':
                    sys.exit(0)




def inputSystem(mode):
    # Can only allow a maximum of 24 characters
    if mode == 1:
        while True:
            input1 = input("# ")

            if len(input1) <= 24:
                return input1
            else:
                errorHandler(1, False)

    # Only allows 16 characters and alphabet characters
    if mode == 2:
        while True:
            input1 = input("# ")

            if len(input1) <= 16 and input1.isalpha():
                return input1
            else:
                errorHandler(7, False)
                continue


def selectOption():
    cprint("Welcome to the FunkyChart converter. What would you like to do?\n\n1 - Create a chart\n2 - Add assets")
    warn (("\n" * 7) + "You are responsible for your own actions. Exploiting violates Roblox's Community Standards. By using FunkyChart or\nany of my scripts, you agree that you are responsible for any punishments that can be held on your account, which\nincludes bans (platform or in-game), account terminations, data wipes, etc. Using FunkyChart in a private environment\nand on a seperate Roblox account.")

    optionKey = keySystem('1', '2')

    match optionKey:
        case '1':
            return True
        case '2':
            return False



def executorSetup():
    cprint("Set up the converter by finding the FunkyChart folder.")

    tempFolder = fd.askdirectory(title='Find the FunkyChart folder', initialdir=os.getenv('USERPROFILE'))

    if not directoryExists(tempFolder):
        errorHandler(2)
    
    cprint("Directory selected. Checking if FunkyChart folder is legitimate.")

    if directoryExists(tempFolder + "\Assets") and directoryExists(tempFolder + "\Charts") and directoryExists(tempFolder + "\Audio"):
        setIODetails('funkyFolder', tempFolder)
    else:
        errorHandler(10)



    
def selectBeatmap():
    def checkAndParseBeatmap(osuChart):
        with open(osuChart, "r", encoding="utf-8") as file:
            section = ""
            filteredOsu = filterFile(file.readlines())

            for line in filteredOsu:
                matched = re.search("\[([a-zA-Z0-9]+)\]$", line)

                if matched:
                    section = matched[1]
                else:

                    if section == "General":
                        filteredLine = filterData(line)
                        if filteredLine[1] == "Mode":
                            setOsuCheck(filteredLine[1], True)
                            if filteredLine[2] == "3":
                                pass
                            else:
                                errorHandler(4)

                            


                    elif section == "Metadata":
                        filteredLine = filterData(line)

                        match filteredLine[1]:
                            case 'Title':
                                setOsuCheck(filteredLine[1], True)
                                setChartDetails('chartName', filteredLine[2])
                            case 'Artist':
                                setOsuCheck(filteredLine[1], True)
                                setChartDetails('chartSongArtist', filteredLine[2])
                            case 'Creator':
                                setOsuCheck(filteredLine[1], True)
                                setChartDetails('chartAuthor', filteredLine[2])
                            case 'Version':
                                setOsuCheck(filteredLine[1], True)
                                setChartDetails('chartDifficulty', filteredLine[2])

                        

                    elif section == "Difficulty":
                        filteredLine = filterData(line)
                        if filteredLine[1] == "CircleSize":
                            setOsuCheck(filteredLine[1], True)
                            if int(filteredLine[2]) >= 4 and int(filteredLine[2]) <= 9:
                                setChartDetails('chartKeys', filteredLine[2])
                            else:
                                errorHandler(5)

                        

                    elif section == "HitObjects":
                        parsedOsuFile['hitobjects'].append(line)
                    else:
                        pass

        for _, value in osuFileChecks.items():
            if value == True:
                pass
            else:
                errorHandler(3, True, str(osuFileChecks))


    cprint('Now, select a beatmap to convert. Remember the qualifications:\n\t- Must be an osu!mania beatmap\n\t- Only 4K - 9K beatmaps')

    if checkForOsu():
        osuChart = fd.askopenfilename(title='Find an osu!mania beatmap file', initialdir=os.getenv('LOCALAPPDATA') + '\osu!\Songs', filetypes=fileTypes['osu'])
    else:
        osuChart = fd.askopenfilename(title='Find an osu!mania beatmap file', initialdir='C:/', filetypes=fileTypes['osu'])

    if not fileExists(osuChart):
        errorHandler(2)
    else:
        checkAndParseBeatmap(osuChart)


def selectAudio():
    cprint('Select an audio file that works with your beatmap.')

    if checkForOsu():
        audioFile = fd.askopenfilename(title='Find an audio file', initialdir=os.getenv('LOCALAPPDATA') + '\osu!\Songs', filetypes=fileTypes['audio'])
    else:
        audioFile = fd.askopenfilename(title='Find an audio file', initialdir='C:/', filetypes=fileTypes['audio'])

    if not fileExists(audioFile):
        errorHandler(2)
    else:
        setIODetails('audioFile', audioFile)


def selectFileName():
    cprint('Type the name of the saved chart file. It has to be a max of 16 characters (only A-Z characters).\n\nFor example, if you type "CoolSongNineKeys" it will show up as "CoolSongNineKeys_01234567.lua" when loading the song.')
    setIODetails('chartFileName', inputSystem(2))

def selectUserName():
    cprint('Type your username. This will show up while playing, and it has to be a max of 24 characters.\n\nEX:\n\tCOOL CHART (IMPOSSIBLE MODE)\n\tBy: coolkid69\n\tConverted by: (Your Username Here)\n')
    setChartDetails('chartConverter', inputSystem(1))

def selectColor():
    cprint('Please choose a color for the chart title. This will add detail to your converted chart.')
    color = cc.askcolor(title="Choose Color for Chart Title")[0]
    setChartDetails('fontColor', str(color[0]) + "," + str(color[1]) + "," + str(color[2]))


def createAudio():

    timestamp = str(time.time()*1000)
    audioName = "audio_" + timestamp + os.path.splitext(inputOutputDetails['audioFile'])[1]

    setIODetails('audioName', audioName)

    try:
        shutil.copy(inputOutputDetails['audioFile'], inputOutputDetails['funkyFolder'] + "\\Audio\\" + inputOutputDetails['audioName'])
    except:
        errorHandler(0)


def createChart():
    counter = 1

    noteLocations = {
        "4" : {"64" : "0", "192" : "1", "320" : "2", "448" : "3"},
        "5" : {"51" : "0", "153" : "1", "256" : "2", "358" : "3", "460" : "4"},
        "6" : {"42" : "0", "128" : "1", "213" : "2", "298" : "3", "384" : "4", "469" : "5"},
        "7" : {"36" : "0", "109" : "1", "182" : "2", "256" : "3", "329" : "4", "402" : "5", "475" : "6"},
        "8" : {"32" : "0", "96" : "1", "160" : "2", "224" : "3", "288" : "4", "352" : "5", "416" : "6", "480" : "7"},
        "9" : {"28" : "0", "85" : "1", "142" : "2", "199" : "3", "256" : "4", "312" : "5", "369" : "6", "426" : "7", "483" : "8"}
    }
    
    cprint("Now converting to the FunkyChart folder. Do NOT close the converter!")
    

    with open(inputOutputDetails["funkyFolder"] + "/Charts/" + inputOutputDetails["chartFileName"] + "_" + str(time.time()*1000) + ".lua", "w") as file:

        # Beginning of the file - puts info about the chart (name, author, difficulty, etc.)
        file.writelines([

            "data.versions.loadingVersion = \"" + loadingVersion + "\"\n\n",

            "data.chartData.chartName = [[" + outputedChartDetails['chartName'] + "]]\n",

            "data.chartData.chartAuthor = [[" + outputedChartDetails["chartSongArtist"] + "]]\n",
                        
            "data.chartData.chartNameColor = \"<font color=\'rgb(" + outputedChartDetails["fontColor"] + ")\'>%s</font>\"\n",
                        
            "data.chartData.chartDifficulty = [[" + outputedChartDetails["chartAuthor"] + "\'s " + outputedChartDetails["chartDifficulty"] + "]]\n",

            "data.chartData.chartKeys = " + outputedChartDetails["chartKeys"] + "\n",
                        
            "data.chartData.chartConverter = [[" + outputedChartDetails["chartConverter"] + "]]\n",

            "\ndata.chartData.loadedAudioID = \"FunkyChart/Audio/" + inputOutputDetails["audioName"] + "\""
            
        ])
        

        file.write("\n\ndata.chartData.chartNotes = {\n")

        
        for note in parsedOsuFile["hitobjects"]:
            hitObject = filterSound(note.strip("\n").replace(":", ",").split(","))

            if hitObject[0] not in noteLocations[outputedChartDetails["chartKeys"]].keys():
                continue


            # Normal Note
            if len(hitObject) == 9:

                side = "data.options.side"
                position = noteLocations[outputedChartDetails["chartKeys"]][hitObject[0]]
                timeNote = str(int(hitObject[2]) / 1000)

                convertedLine = f'[{counter}]=' + '{' + f'Side={side},Length=0,Time={timeNote}+data.options.timeOffset,Position={position}' + '}'

                if counter != len(parsedOsuFile["hitobjects"]):
                    convertedLine = convertedLine + ","

                counter += 1

                file.write(convertedLine + "\n")

            # Hold Note
            elif len(hitObject) == 10:

                side = "data.options.side"
                position = noteLocations[outputedChartDetails["chartKeys"]][hitObject[0]]
                length = str((int(hitObject[5]) - int(hitObject[2])) / 1000)
                timeNote = str(int(hitObject[2]) / 1000)

                convertedLine = f'[{counter}]=' + '{' + f'Side={side},Length={length},Time={timeNote}+data.options.timeOffset,Position={position}' + '}'

                if counter != len(parsedOsuFile["hitobjects"]):
                    convertedLine = convertedLine + ","

                counter += 1

                file.write(convertedLine + "\n")

        file.write("}")

        file.close()

        
        time.sleep(3)
        
        cprint('Saved to the FunkyChart folder!\nPress the "A" button to exit.')

        closeKey = keySystem('a')
        match closeKey:
            case 'a':
                sys.exit(0)

def selectAssets():
    cprint('Select the assets that you want to copy over to FunkyChart.')

    parsedOsuFile["assets"] = fd.askopenfilenames(title='Find assets', initialdir=os.getenv('USERPROFILE'), filetypes=fileTypes['asset'])

    if len(parsedOsuFile["assets"]) == 0:
        errorHandler(2)
    else:
        for asset in parsedOsuFile["assets"]:
            if not fileExists(asset):
                errorHandler(2)
        return


def copyAssets():
    cprint("Now copying assets to the FunkyChart folder. Do NOT close the converter!")


    for asset in parsedOsuFile['assets']:
        randomNumber = str(random.randint(0, 1000))
        newName = os.path.splitext(os.path.split(asset)[1])[0] + "_" + randomNumber + os.path.splitext(os.path.split(asset)[1])[1]

        try:
            shutil.copy(asset, inputOutputDetails['funkyFolder'] + "\\Assets\\" + newName)
        except:
            errorHandler(0)


    time.sleep(3)
        
    cprint('Saved to the FunkyChart folder!\nPress the "A" button to exit.')

    closeKey = keySystem('a')
    match closeKey:
        case 'a':
            sys.exit(0)





def procedureInit():
    option = selectOption()

    executorSetup()

    if option:
        selectBeatmap()
        selectAudio()
        selectFileName()
        selectUserName()
        selectColor()
        createAudio()
        createChart()
    else:
        selectAssets()
        copyAssets()

    return

if __name__ == "__main__":
    githubUpdateChecker()
    procedureInit()