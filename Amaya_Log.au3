#include <FileConstants.au3>
;~ Set a hotkey Escape to exit the script
HotKeySet("{ESC}", "_ExitScript")

; Create file in same folder as script
Global $sFileName = "c:\Log\Amaya_Log.txt"
Global $hFileOpen = FileOpen($sFileName, $FO_APPEND)

Run("AMAYA.exe")

getAmaya()

Func getAmaya()
    Local $sID = "", $oLd = ""
    While 1
        If WinExists("AMAYA OS Lite") Then
            $sID = ControlGetText("AMAYA OS Lite", "", "[CLASS:Edit; INSTANCE:22]")
            If ($sID == $oLD) Then
                ContinueLoop
            Else
                ConsoleWrite($sID & @CRLF)
                ; Append a line
                FileWrite($hFileOpen, $sID & @CRLF)
                $oLd = $sID
            EndIf
        EndIf
        Sleep (50)
    WEnd
EndFunc

Func _ExitScript()
    FileClose($hFileOpen)
    Exit
EndFunc
