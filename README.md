# FunkyChart for Lyte Interactive's Funky Friday (v1.22)
## WARNING!
### You are responsible for your own actions. Exploiting violates Roblox's Community Standards. By using FunkyChart or any of my scripts, you agree that you are responsible for any punishments that can be held on your account, which includes bans (platform or in-game), account terminations, data wipes, etc. Using FunkyChart in a private environment and on a seperate Roblox account.<br>
##
### **[v1.2 Trailer](https://www.youtube.com/watch?v=HPKuQ2K9iYs)**<br>
Originally a fork of wally-rblx's [funky-friday-autoplayer](https://github.com/wally-rblx/funky-friday-autoplay).<br><br>
A modding script for Lyte Interactive's Funky Friday, a rhythm game inspired by Friday Night Funkin' in Roblox.<br>
Play your favorite osu!mania beatmaps in the Funky Friday engine, supported from 4K - 9K.<br><br>
Supported for executors **[Synapse X](https://x.synapse.to/)** and **[Krnl](https://krnl.ca/)**.<br>

### **[Download the latest release!](https://github.com/accountrev/funkychart/releases/latest)**<br><br>
![Comparison between osu!mania and Funky Friday](https://user-images.githubusercontent.com/55156874/155612058-96974ec2-1c24-443a-b985-fb13c151c6d7.gif)



## Overview and Purpose
This script allows you to fully convert an osu!mania beatmap into a Lua script that is readable by Roblox and Funky Friday's engine.<br>
The osu!mania beatmap **can be 4K - 9K**. Anything lower/higher will not work as it is not yet supported in Funky Friday.<br><br>
When I used to be into VSRGs very religiously, this was my go-to game to play on Roblox. There was a point where I got tired of the same songs, so I noted this project down as a concept. A few months later, I was tinkering with wally-rblx's autoplayer (link above). I suddenly realized that [you can edit the notes when they load](https://youtu.be/FscazwnUDjk). So I set out to make this abombination that you see in front of you.<br><br>
You can use this script to play songs for fun or practice, as Funky Friday's engine is very lenient when it comes to notes (and still is as of v1.2)<br><br>
Just remember, this is all **client-sided and singleplayer**, meaning no one will be able to hear or see you play songs in-game. I may have a few ideas for multiplayer for the future.<br><br>

## Tutorials
### **[Tutorial on how to use FunkyChart and the converter (v1.2)](https://www.youtube.com/watch?v=NT3_AIzwsSg)**<br>
### **[Tutorial on how to use the Underframe feature in FunkyChart (v1.2)](https://www.youtube.com/watch?v=06MCZHsIotg)**<br><br>

## Compiling
This section mainly focuses on how to compile the **converter** (aka the folder that is called "Converter" in this repo). **If you are just looking to download, [click here for the latest release.](https://github.com/accountrev/funkychart/releases/latest)**<br><br>
The converter was written in Python 3.10.5, so be aware that the **converter will not be supported for Windows 7 and earlier** and I have no intentions of re-writing it for a older Python release.<br><br>
Packages that are used by the converter are:
* colorama
* requests
* pyinstaller (for compilation)
<br><br>

In Command Prompt or Powershell, navigate to the folder that contains the .py and .pyproj files and paste this:<br>
`pyinstaller -F -n FunkyChartConverter -i icon.ico --hidden-import colorama FunkyChartConverter.py`<br><br>
When it's done compiling, the executable file should be in the same folder under /dist.<br><br>
Any questions, shoot me a message on Discord or report it here on the Issues tab.<br><br>

## Contact Me!
### My Discord: accountrevived#0686




