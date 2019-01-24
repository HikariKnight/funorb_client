#NoTrayIcon

; Include the array and file library
#include <Array.au3>
#include <File.au3>

; If the jagexlauncher does not exist then
If FileExists(@UserProfileDir & "\jagexcache\JagexLauncher\") = 0 Then
	; Tell user that they need to reinstall the client
	MsgBox(16,"Jagex Client not found", "Did not find the RuneScape client, please reinstall the client")
	; Exit the program
	Exit
EndIf

; Get the list of prms
$prms = _FileListToArray(@ScriptDir & "\prms\","*.prm",1)

; Create a desktop folder where we will place all shortcuts
DirCreate(@StartMenuDir & "\FunOrb\Games")

; For each prm we found
For $x = 1 To $prms[0]
	; Make a variable that contains the prm folder name
	$prmfolder = StringReplace($prms[$x],".prm","")

	; Create a folder for the prm file
	DirCreate(@UserProfileDir & "\jagexcache\JagexLauncher\" & $prmfolder)

	; Copy the prmfile to the location
	FileCopy(@ScriptDir & "\prms\" & $prms[$x], @UserProfileDir & "\jagexcache\JagexLauncher\" & $prmfolder & "\" & $prms[$x],1)

	; Copy the icon to the folder
	FileCopy(@ScriptDir & "\icon\jagexappletviewer.ico",@UserProfileDir & "\jagexcache\JagexLauncher\" & $prmfolder & "\jagexappletviewer.ico")
	FileCopy(@ScriptDir & "\icon\jagexappletviewer.png",@UserProfileDir & "\jagexcache\JagexLauncher\" & $prmfolder & "\jagexappletviewer.png")

	; Create a shortcut
	FileCreateShortcut(@UserProfileDir & "\jagexcache\JagexLauncher\bin\JagexLauncher.exe",@StartMenuDir & "\Funorb\Games\" & _
	$prmfolder & ".lnk",@UserProfileDir & "\jagexcache\JagexLauncher\bin\",$prmfolder,"", _
	@UserProfileDir & "\jagexcache\JagexLauncher\" & $prmfolder & "\jagexappletviewer.ico")

	; Create a folder shortcut to the FunOrb games
	FileCreateShortcut(@StartMenuDir & "\FunOrb\Games\",@DesktopDir & "\FunOrb.lnk")
Next

; Ask if we shall install the launcher
$install_launcher = MsgBox(4,"Install Launcher?", "Do you want to install the FunOrb launcher too?")

; If the user said yes then
If $install_launcher = 6 Then
	; Copy the launcher into the JagexLauncher
	FileCopy(@ScriptDir & "\Launcher\*",@UserProfileDir & "\jagexcache\JagexLauncher\",1)

	; Make a shortcut
	FileCreateShortcut(@UserProfileDir & "\jagexcache\JagexLauncher\FunOrb Launcher.exe",@DesktopDir & "\FunOrb Launcher.lnk")
	; Make a shortcut to start menu
	DirCreate(@StartMenuDir & "\FunOrb")
	FileCreateShortcut(@UserProfileDir & "\jagexcache\JagexLauncher\FunOrb Launcher.exe",@StartMenuDir & "\FunOrb\FunOrb Launcher.lnk")
EndIf

; Tell that we are done
MsgBox(0,"Installation done", "All the files are now copied to the client and all shortcuts are placed in your FunOrb folder on your desktop")