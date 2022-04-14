"""

    Hello and thanks for passing by.

    This is the source code for the converter used in FunkyChart, a Roblox script intended for the game Funky Friday.
    If you downloaded this and don't know what you're doing, download the one from the Releases tab on GitHub instead,
    where it is converted to a .exe for your pleasure.

    If you DO know what you're doing, I hope I made it easy to read for your eyes. I'm actually pretty shit with Python.
    I've worked on this for so many hours and I sometimes don't know half of what I type LOL.

    If you eventually decide to fork this or intend to modify the code for re-distribution,
    please please please please PLEASE credit me on your work. I would really appreciate that.

    A message to you regardless:
    Thanks for downloading and using my script, if you're here to just use it once or plan to use it many times.
    I have put many hours into this as well as my YouTube channel with showcases and such. I don't really care about the views that much,
    but the amount of attention that those videos created have blown my mind. Thank you.

    Anyways enough with the speech, I hope you have fun.

    -   accountrev


"""


"""

!!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!
!!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!
!!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!

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



#   MODULES

import requests
import webbrowser
import sys
import logging
import re
import os
import time
import colorama as clr
import tkinter as tk
from tkinter import filedialog as fd
import shutil

# Required for the colored text to work
clr.init()

# Cannot hide root Tk window unless I make it
windowTemp = tk.Tk()
windowTemp.withdraw()


version = "v1.11"
acceptableVersion = "v1.11"


# FunkyChart Logo
logo = r'''    ______            __         ________               __     ______                           __           
   / ____/_  ______  / /____  __/ ____/ /_  ____ ______/ /_   / ____/___  ____ _   _____  _____/ /____  _____
  / /_  / / / / __ \/ //_/ / / / /   / __ \/ __ `/ ___/ __/  / /   / __ \/ __ \ | / / _ \/ ___/ __/ _ \/ ___/
 / __/ / /_/ / / / / ,< / /_/ / /___/ / / / /_/ / /  / /_   / /___/ /_/ / / / / |/ /  __/ /  / /_/  __/ /    
/_/    \__,_/_/ /_/_/|_|\__, /\____/_/ /_/\__,_/_/   \__/   \____/\____/_/ /_/|___/\___/_/   \__/\___/_/     
                       /____/                                                                                

''' + version + '''
Made with ♥ by accountrev
'''




# These lists are used to hold data in place when parsing the .osu file
generalList = []    # General
metadataList = []   # Metadata
difficultyList = [] # Difficulty
hitobjList = []     # HitObjects

# This dictionary is used to hold the chart information for later
chartDictionary = {"chartName" : "", "chartSongArtist" : "", "chartAuthor" : "", "chartDifficulty" : "", "chartConverter" : "", "fontColor" : "255, 255, 255", "audio" : "", "fileName" : "chart"}

# Checks to make sure the .osu file contains all the required data
generalChecks = {"Mode" : False}
metadataChecks = {"Title" : False, "Artist" : False, "Creator" : False, "Version" : False}
difficultyChecks = {"CircleSize" : False}
hitobjChecks = {"Valid" : False}

# Color dictionary (makes it easier to add color instead of remembering the exact code)
colorDict = {"R" : clr.Fore.LIGHTRED_EX + clr.Style.BRIGHT, "W" : clr.Fore.WHITE + clr.Style.BRIGHT, "G" : clr.Fore.LIGHTGREEN_EX + clr.Style.BRIGHT, "Y" : clr.Fore.LIGHTYELLOW_EX + clr.Style.BRIGHT}

# Filetypes for tkinter
osuFiletype = [('osu! beatmap file', "*.osu")]
audioFiletype = (('MP3', "*.mp3"), ('WAV', "*.wav"))
txtFiletype = [('Text File', "*.txt")]


# Clear console and prints logo (thx stackoverflow!)

debugEnableCLS = True

def cls():
    if debugEnableCLS:
        os.system('cls' if os.name=='nt' else 'clear')
        print(colorDict["R"] + logo)
        

# Error handler - to prevent exceptions from happening when in use
#       additionalInfo - used to print out data to the user
#       exiting - if exiting is set to true, it will exit the program. if false, the user can enter something again.
def errorHandler(error, additionalInfo = "", exiting=True):

    # I swear im not yanderedev
    if error == 0:
        print(colorDict["R"] + "\nThat is not a valid option.\n" + colorDict["W"] + "ERROR 00")
    if error == 1:
        print(colorDict["R"] + "The username you provided exceeds the character limit (24). Please enter a proper username.\n" + colorDict["W"] + "ERROR 01")
    elif error == 2:
        print(colorDict["R"] + "The path you provided must be a valid directory.\n" + colorDict["W"] + "ERROR 02")
    elif error == 3:
        print(colorDict["R"] + "No file provided or file already exists. Please select a file when asked.\n" + colorDict["W"] + "ERROR 03")
    elif error == 4:
        print(colorDict["R"] + 'Something is wrong with the beatmap you selected. Please try again and refer to this dictionary.\n\n' + colorDict["W"] + 'beatmapValidation = ' + additionalInfo + "\n\nERROR 04")
    elif error == 5:
        print(colorDict["R"] + 'This beatmap is not designed for !mania. Please select an actual !mania beatmap file.\n\n' + colorDict["W"] + 'Beatmap file mode (must be 3): ' + additionalInfo + "\n\nERROR 05")
    elif error == 6:
        print(colorDict["R"] + '\nThis beatmap is missing a key component in the General section. Try again and refer to this dictionary or try another beatmap.\n\n' + colorDict["W"] + 'generalChecks = ' + additionalInfo + "\n\nERROR 06")
    elif error == 7:
        print(colorDict["R"] + '\nThis beatmap is missing a key component in the Metadata section. Try again and refer to this dictionary or try another beatmap.\n\n' + colorDict["W"] + 'metadataChecks = ' + additionalInfo + "\n\nERROR 07")
    elif error == 8:
        print(colorDict["R"] + '\nThis beatmap is designed with ' + additionalInfo + ' keys in mind. Please select an !mania beatmap with 4 keys.\n\n' + colorDict["W"] + "ERROR 08")
    elif error == 9:
        print(colorDict["R"] + '\nThis beatmap is missing a key component in the Difficulty section. Try again and refer to this dictionary or try another beatmap.\n\n' + colorDict["W"] + 'difficultyChecks = ' + additionalInfo + "\n\nERROR 09")
    elif error == 10:
        print(colorDict["R"] + '\nSomething went wrong while parsing the notes. Please try again or choose a different beatmap.' + colorDict["W"] + "\n\nERROR 10")
#   elif error == 11:
#       print(colorDict["R"] + '\nYou can only enter numeric characters (aka the audio ID you are using). Please try again.' + colorDict["W"] + "\n\nERROR 10")
    elif error == 12:
        print(colorDict["R"] + '\nInvalid name, only use alphabet characters and a limit of 16 characters. Please try again.' + colorDict["W"] + "\n\nERROR 12")
    
    if exiting:
        print(colorDict["R"] + '\n\nClosing in 20 seconds...' + colorDict["W"])
        time.sleep(20)
        exit(0)


# Filters .osu file to sentences in a list
def filterFile(list):
    newList = []

    for line in list:
        if not line.isspace():
            newList.append(re.sub("[\n\r]+", "", line))

    return newList

# Filters a line from the list into two:
# EX:   Name: Sample Name
#       ("Name:", "Sample Name")
def filterData(item):

    filteredItem = re.search("([a-zA-Z0-9]+)[ ]*:[ ]*(.+)$", item)

    if filteredItem is None:
        filteredItem = ["", ""]

    return filteredItem

#Sometimes, beatmaps will have a sound file name at the end of a HitObject. This function removes that.
def filterSound(list):

    if not list[-1].isdigit():
        list.remove(list[-1])

    return list

# Closed input system, with different modes for different requirements
# If a requirement is not met, then the user will get redirected to errorHandler.
def inputSys(mode):

    if mode == 1:
        while True:
            print("\nType \"Y\" or \"N\" to choose.\n")

            input1 = input("# ")

            if input1.lower() == "y" or input1.lower() == "n":
                break
            else:
                cls()
                errorHandler(0, exiting = False)
                continue

        return input1


    # Can only allow a maximum of 24 characters
    if mode == 2:
        while True:
            input1 = input("# ")

            if len(input1) <= 24:
                return input1
            else:
                cls()
                errorHandler(1, exiting = False)
                continue
    
    # Can only allow numbers
    #if mode == 3:
    #    while True:
    #        input1 = input("# ")

    #        if input1.isnumeric():
    #            return input1
    #        else:
    #            cls()
    #            errorHandler(11, exiting = False)

    # Only allows 16 characters and alphabet characters
    if mode == 4:
        while True:
            input1 = input("# ")

            if len(input1) <= 16 and input1.isalpha():
                return input1
            else:
                cls()
                errorHandler(12, exiting = False)
                continue
        


# Update Notifier - notifies if a new verison is available on GitHub
def checkForUpdate():
    requestedVersion = requests.get("https://api.github.com/repos/accountrev/funkychart/releases/latest").json()["tag_name"]

    if requestedVersion > version:
        cls()
        print(colorDict["Y"] + "There is a new version of FunkyChart available on GitHub! Please update this to continue using the converter.\nYou are using " + version + ", while the latest version is " + requestedVersion + ".\n\n" + colorDict["W"] + "OPENING GITHUB PAGE...")
        webbrowser.open("https://github.com/accountrev/funkychart/releases/latest")
        print(colorDict["Y"] + "\n\nYou can still use this converter if you'd like. Would you like to keep using the converter?\n\n")

        ignoreMSG = inputSys(1)

        if ignoreMSG.lower() == "y":
            return
        else:
            exit(0)

# Parses the .osu file that was selected into different lists.
def parseOsuBeatmap(filename):

    # Beatmap validation - If the files does not have any of these sections, it will not continue.
    beatmapValidation = {"general" : False, "metadata" : False, "difficulty" : False, "hitobj" : False}
    

    try:
        with open(filename, "r", encoding="utf-8") as file:

            section = ""
            
            osuFile = filterFile(file.readlines())

            for line in osuFile:
                match = re.search("\[([a-zA-Z0-9]+)\]$", line)

                if match:
                    section = match[1]
                else:
                    if section == "General":
                        generalList.append(line)
                        beatmapValidation["general"] = True
                    elif section == "Metadata":
                        metadataList.append(line)
                        beatmapValidation["metadata"] = True
                    elif section == "Difficulty":
                        difficultyList.append(line)
                        beatmapValidation["difficulty"] = True
                    elif section == "HitObjects":
                        hitobjList.append(line)
                        beatmapValidation["hitobj"] = True
                    else:
                        pass

        for key, value in beatmapValidation.items():
            if value == True:
                pass
            else:
                cls()
                errorHandler(4, str(beatmapValidation))

    except FileNotFoundError:
        cls()
        errorHandler(3)
    return

# Checks for any problems within the data that was parsed, like if a name is missing or the beatmap supports !mania.
def chartCreationAndValidation():

    #region General
    for thing in generalList:
        dataObject = re.search("([a-zA-Z0-9]+)[ ]*:[ ]*(.+)$", thing)

        if dataObject[1] == "Mode":
            generalChecks["Mode"] = True
            if dataObject[2] == "3":
                # print("Mania mode")
                pass
            else:
                cls()
                errorHandler(5, str(dataObject[2]))

    for key, value in generalChecks.items():
        if value == True:
            pass
        else:
            cls()
            errorHandler(6, str(generalChecks))
    #endregion

    #region Metadata
    for thing in metadataList:

        dataObject = filterData(thing)

        if dataObject[1] == "Title":
            metadataChecks["Title"] = True
            chartDictionary["chartName"] = dataObject[2]
        elif dataObject[1] == "Artist":
            metadataChecks["Artist"] = True
            chartDictionary["chartSongArtist"] = dataObject[2]
        elif dataObject[1] == "Creator":
            metadataChecks["Creator"] = True
            chartDictionary["chartAuthor"] = dataObject[2]
        elif dataObject[1] == "Version":
            metadataChecks["Version"] = True
            chartDictionary["chartDifficulty"] = dataObject[2]

    for key, value in metadataChecks.items():
        if value == True:
            pass
        else:
            cls()
            errorHandler(7, str(metadataChecks))

    #endregion

    #region Difficulty
    for thing in difficultyList:
        dataObject = filterData(thing)

        if dataObject[1] == "CircleSize":
            difficultyChecks["CircleSize"] = True
            if dataObject[2] == "4":
                # print("4k mode")
                pass
            else:
                cls()
                errorHandler(8, str(dataObject[2]))

    for key, value in difficultyChecks.items():
        if value == True:
            pass
        else:
            cls()
            errorHandler(9, str(difficultyChecks))
    #endregion


# Turns the data that was collected into an actual readable Lua file for FunkyChart.
def convertChartToFF(filePath):

    # some of code was written in early 2021, so it needs optimizing

    noteLocationDictionary = {"64" : "0", "192" : "1", "320" : "2", "448" : "3"}
    counter = 1

    cls()
    print("Converting to " + filePath + "...\nDO NOT CLOSE THE CONVERTER!")

    with open(r"" + filePath + "/" + chartDictionary["chartConverter"] + "-" + chartDictionary["fileName"] + "_DONOTEDIT-OR-EXECUTE" + ".lua", "w") as file:

        # Beginning of the file - puts info about the chart (name, author, difficulty, etc.)
        file.writelines(["data.versions.loadingVersion = \"" + acceptableVersion + "\"\n\n",
                        "data.chartData = {\n",
                        "chartName = [[" + chartDictionary["chartName"] + "]],\n",
                        "chartAuthor = [[" + chartDictionary["chartSongArtist"] + "]],\n",
                        "chartNameColor = \"<font color=\'rgb(" + chartDictionary["fontColor"] + ")\'>%s</font>\",\n",
                        "chartDifficulty = [[" + chartDictionary["chartAuthor"] + "\'s " + chartDictionary["chartDifficulty"] + "]],\n",
                        "chartConverter = [[" + chartDictionary["chartConverter"] + "]],\n"])


        # Different actions wheter the user chose Online or Local mode.
        #if mode == "l":
        #    file.writelines(["_G.customChart.loadedAudioID = getsynasset(\"FunkyChart_AudioFiles/" + chartDictionary["audio"].split("/")[-1] + "\")\n",
        #                     "_G.customChart.timeOffset = 0"])
        #elif mode == "o":
        #    file.writelines(["_G.customChart.loadedAudioID = \"rbxassetid://" + chartDictionary["audio"] + "\"\n",
        #                     "_G.customChart.timeOffset = 0"])

        file.writelines(["\nloadedAudioID = \"FunkyChart/Audio/" + chartDictionary["audio"].split("/")[-1] + "\","])



        # Beginning of chart notes
        file.write("\n\nchartNotes = {\n")

        
        for note in hitobjList:

            hitObject = filterSound(note.strip("\n").replace(":", ",").split(","))

            # Normal Note
            if len(hitObject) == 9:

                side = "data.options.side"
                position = noteLocationDictionary[hitObject[0]]
                length = "0"
                time1 = str(int(hitObject[2]) / 1000)
                str_counter = str(counter)

                convertedLine = f'[{counter}]=' + '{' + f'Side = {side},Length = {length},Time = {time1}+data.options.timeOffset,Position = {position}' + '}'

                if counter != len(hitobjList):
                    convertedLine = convertedLine + ","
                    #print(counter, convertedLine, "NINE")

                counter += 1

                file.write(convertedLine + "\n")

            # Hold Note
            elif len(hitObject) == 10:

                side = "data.options.side"
                position = noteLocationDictionary[hitObject[0]]
                length = str((int(hitObject[5]) - int(hitObject[2])) / 1000)
                time1 = str(int(hitObject[2]) / 1000)
                str_counter = str(counter)

                convertedLine = f'[{counter}]=' + '{' + f'Side = {side},Length = {length},Time = {time1}+data.options.timeOffset,Position = {position}' + '}'

                if counter != len(hitobjList):
                    convertedLine = convertedLine + ","
                    #print(counter, convertedLine, "TEN")

                counter += 1

                file.write(convertedLine + "\n")

        file.write("}\n}")
        file.close()

        #if mode == "l":
        #    file.write("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/accountrev/funkychart/main/LocalOnly.lua\", true))()")

        
        time.sleep(3)

        cls()
        print("Saved to " + filePath + "!")
        print("Closing in 30 seconds.")

        time.sleep(30)

# The "beginning" of the program
def startProcedure():

    # The user can choose between Online and Local mode.
    #print(colorDict["G"] + "Choose your intended mode\n(O)nline mode or (L)ocal mode?" + colorDict["W"] + "\n\nOnline mode allows you to use Roblox audio IDs for audio and can be shared on the internet easily.\n(Recommended)\n\nLocal mode allows you to use a specified audio file stored locally on your computer.\n(Synapse X ONLY)\n\nGo to the GitHub wiki to see all pros and cons.\n")
    #mode = inputSys(1)

    # The username is required for crediting who converted it
    cls()
    print(colorDict["G"] + "Welcome! To start of:\n\nWhat is your username? (This would be put in the chart)\n" + colorDict["W"] + "EX:\n\tCOOL CHART (IMPOSSIBLE MODE)\n\tBy: coolkid69\n\tConverted by: (Your Username Here)\n")
    chartDictionary["chartConverter"] = inputSys(2)
    
    # Beatmap selection using tkinter's askopenfilename function
    cls()
    print(colorDict["G"] + "Choose a beatmap file.")
    filename = fd.askopenfilename(title='Open a beatmap file', initialdir='C:/', filetypes=osuFiletype)

    # Chart creating starts here
    parseOsuBeatmap(filename)
    chartCreationAndValidation()

    # Naming the saved file
    cls()
    print(colorDict["G"] + "Now, name your saved file.\n")
    chartDictionary["fileName"] = inputSys(4)

    # Saving the finished product - uses tkinter's askdirectory function
    cls()
    print(colorDict["G"] + "Where would you want your converted file to be saved?")
    filePath = fd.askdirectory()

    # Different actions for Online and Local mode (Online needs to put an audio ID, Local needs to select a sound file)
    #if mode == "o":
    #    cls()
    #    print(colorDict["G"] + "Since you chose online mode, please enter the audio ID for this chart.")
    #    chartDictionary["audio"] = inputSys(3)
    #elif mode == "l":
    #    cls()
    #    print(colorDict["G"] + "Since you chose local mode, please select the mp3 file that will go with the chart.")
    #    chartDictionary["audio"] = fd.askopenfilename(title='Open an audio file', initialdir='C:/', filetypes=audioFiletype)

    #    # Checks if the file is actually a file - should probably implement that for the first one as well...
    #    if not os.path.isfile(chartDictionary["audio"]):
    #        errorHandler(3)

    # Selecting audio for the chart
    cls()
    print(colorDict["G"] + "Please select the mp3 file that will go with the chart.")
    chartDictionary["audio"] = fd.askopenfilename(title='Open an audio file', initialdir='C:/', filetypes=audioFiletype)
    print(chartDictionary["audio"])

    # Checks if the file is actually a file - should probably implement that for the first one as well...
    if not os.path.isfile(chartDictionary["audio"]):
        errorHandler(3)

    cls()
    print(colorDict["G"] + "Where would you want the audio file to be saved?")
    filePathAudio = fd.askdirectory()

    try:
        shutil.copy(chartDictionary["audio"], filePathAudio)
    except (FileNotFoundError, shutil.SameFileError) as exception:
        cls()
        errorHandler(3)

    # You can change the color of the title in a song using RGB values. For example if your song is TTFAF, you can choose an orange or red color and it will look nice.
    cls()
    print(colorDict["G"] + "Choose a color in RGB value (this will change the color of the title)\n" + colorDict["W"] + "EX:\n\t0, 0, 0 (Black)\n\t255, 255, 255 (White)\n\t0, 174, 255 (Light Blue)\n")
    chartDictionary["fontColor"] = input("# ")
    
    convertChartToFF(filePath)


# Main - prints logo and starts program
def main():
    cls()
    startProcedure()


# You love to see it
if __name__ == "__main__":
    checkForUpdate()
    main()
