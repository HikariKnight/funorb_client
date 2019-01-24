#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\icon\jagexappletviewer.ico
#AutoIt3Wrapper_Outfile=FunOrb Launcher.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GuiComboBox.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <Array.au3>
#include <File.au3>

; Disable tray icon
#NoTrayIcon

; Enable events
Opt("GUIOnEventMode",1)

; Make global variables
Global $gamelist

; Load gui
choose_game()

Func choose_game()
	#Region ### START Koda GUI section ### Form=c:\users\copy\devel\lindbak\klar-installer\src\nykunde\nykunde.kxf
	$selectshare = GUICreate("Choose FunOrb Game", 325, 125)
	$Label1 = GUICtrlCreateLabel("Choose a FunOrb game from the dropdown and click Start", 20, 16, 276, 42)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$gamelist = GUICtrlCreateCombo("", 65, 55, 180, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "")
	$start = GUICtrlCreateButton("Start", 65, 83, 180, 25)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	; Load the prms
	loadPrms()

	; Make closing the window work
	GUISetOnEvent($GUI_EVENT_CLOSE, "Close")

	; Make the start button do something
	GUICtrlSetOnEvent($start,"start_main")
EndFunc

Func loadPrms()
	; Read all folders in JagexLauncher
	$configs = _FileListToArray(@UserProfileDir & "\jagexcache\JagexLauncher\","*",2)

	; If no errors then
	If @error = 0 Then
		; Sort the games
		_ArraySort($configs)

		; Loop through the configs
		For $x = 1 To $configs[0]
			ConsoleWrite($x & @CRLF)
			; Move the foldername to a variable
			$gamename = $configs[$x]

			; If this is a funorb config then
			If StringRegExp($gamename,"^funorb") = 1 Then
				; Check in a gamelist.ini file for a reference to an actual readable name, if none is found then use the foldername
				$gamename = IniRead(@ScriptDir & "\gamelist.ini","games",StringLower($gamename),$gamename)

				; Add $gamename to the dropdown
				_GUICtrlComboBox_AddString($gamelist,$gamename)
			EndIf
		Next
	EndIf
EndFunc

Func start_main()
	; Get the selected game
	$selectedgame = GUICtrlRead($gamelist)

	; If no game is selected
	If $selectedgame = "" Then
		; Tell user to select a game
		MsgBox(0,"Select a FunOrb game", "Please select a FunOrb game before trying to start the client.")

		; Return to call
		Return
	EndIf

	; Read the gamelist into an array
	$gamelistlines = FileReadToArray(@ScriptDir & "\gamelist.ini")

	; Make a variable that contains the gameconfig name we will use
	$gameconfig = $selectedgame

	; If no errors then
	If @error = 0 Or _ArrayToString($gamelistlines) <> "" Then
		; Loop through the file til we find the selected game
		For $x = 0 To UBound($gamelistlines)-1
			; If the line has a match
			If StringRegExp($gamelistlines[$x],"=" & $selectedgame) = 1 Then
				; Split the line by =
				$config_id = StringSplit($gamelistlines[$x],"=")

				; Transfer the config name to the $gameconfig variable
				$gameconfig = $config_id[1]
			EndIf
		Next
	EndIf

	; Run the game
	Run(@UserProfileDir & "\jagexcache\JagexLauncher\bin\JagexLauncher.exe " & $gameconfig,@UserProfileDir & "\jagexcache\JagexLauncher\bin\")
EndFunc

Func Close()
	; Exit
	Exit
EndFunc

; While gui is shown
While 1
	; Idle for 10 ms
	Sleep(100)
WEnd
