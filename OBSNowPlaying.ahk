#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
FileEncoding, UTF-8

windowTitle := "- YouTube - Google Chrome"
SetTitleMatchMode 2 
DetectHiddenWindows, on

Run := False
	
F3:: Run:=False

F2::
	Last_Window_Title := 
	WinGet, Window_ID, ID, %windowTitle%
	Sleep, 100
	if Window_ID
		Run := True
	while Run
	{
		WinGetTitle, Current_Window_Title, ahk_id %Window_ID%
		Sleep, 200
		if (Current_Window_Title != Last_Window_Title and InStr(Current_Window_Title, windowTitle))
		{
			RegExMatch(Current_Window_Title, "([^-]+(?:-[^-]+)*)", _match)
			Current_Song := RegExReplace(_match1, "^\(\d+\)")				;(...)
			Current_Song := RegExReplace(Current_Song, "\[.+?\]")			;[...]
			Current_Song := RegExReplace(Current_Song, "(?<=[\)\]]).+$")	;)|]....
			Current_Song := RegExReplace(Current_Song, "\[?H[DQ]\]?")		;[HD][HQ]HD
			Current_Song := StrReplace(Current_Song, "[Monstercat Release]")
			Current_Song := StrReplace(Current_Song, windowTitle)
			Current_Song := Trim(Current_Song, "- `t")
			FileDelete, %A_ScriptDir%\OBS.txt
			Sleep, 100
			TmpStr := "Current song: " . Current_Song
			;MsgBox, %TmpStr%
			FileAppend, %TmpStr%, %A_ScriptDir%\OBS.txt
			Last_Window_Title := Current_Window_Title
		}
		Sleep, 1000
	}
	Window_ID := 
	return