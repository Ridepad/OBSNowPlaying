#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

FileEncoding, UTF-8
SetTitleMatchMode 2

Look_For := "- YouTube - "

while True
{
	Last_Window_Title :=
	WinGet, Window_ID, ID, %Look_For%
	Sleep 100
	while WinExist("ahk_id" Window_ID)
	{ 
		WinGetTitle, Current_Window_Title
		Sleep 200
		if !InStr(Current_Window_Title, Look_For)
			break
		if InStr(Current_Window_Title, "Liked videos")
			break
		if (Current_Window_Title != Last_Window_Title)
		{
			Last_Window_Title := Current_Window_Title
			Current_Song := RegExReplace(Current_Window_Title, Look_For ".+$")
			Current_Song := StrReplace(Current_Song, "[Monstercat Release]")
			Current_Song := StrReplace(Current_Song, "(Original Mix)")
			Current_Song := RegExReplace(Current_Song, "\[?H[DQ]\]?")		;[HD][HQ]HD
			First_Half := SubStr(Current_Song, 1, Floor(StrLen(Current_Song) / 2))
			Half_Ftmt := RegExReplace(First_Half, "^\(\d+\)")				;(22) ...
			Half_Ftmt := RegExReplace(Half_Ftmt, "\【.+?\】")					;... 【Drum&Bass】 ...
			Half_Ftmt := RegExReplace(Half_Ftmt, "\[.+?\]")					;... [Electro] ...
			Current_Song := StrReplace(Current_Song, First_Half, Half_Ftmt)
			Current_Song := RegExReplace(Current_Song, "[\[\(].+EP[\)\]]")	;... [Secret Weapon EP] ...
			Current_Song := RegExReplace(Current_Song, "(?<=[\)\]\|]).+$")	;|)] ....
			Current_Song := Trim(Current_Song, "|- `t")
			FileDelete, OBS.txt
			Sleep 200
			FileAppend, %Current_Song%, OBS.txt
		}
		Sleep 2500
	}
	Sleep 2500
}
