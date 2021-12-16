#include <FileConstants.au3>

; Create file in same folder as script
$sFileName = "c:\Log\Amaya_Log.txt"

$sID = ""
$oLd = ""
Run("AMAYA.exe")

Func getAmaya()
While 1
if WinExists("AMAYA OS Lite") Then
   $sID = ControlGetText("AMAYA OS Lite", "", "[CLASS:Edit; INSTANCE:22]")
	If ($sID == $oLD) Then
		ContinueLoop
	Else
		ConsoleWrite($sID & @CRLF)
		; Append a line
	  Local $hFileOpen = FileOpen($sFileName, $FO_APPEND)
	  FileWrite($hFileOpen, @CRLF & $sID)
	  FileClose($hFileOpen)
   		$oLd = $sID
	EndIf
Sleep (50)
EndIf
WEnd
EndFunc
getAmaya()