#include <FileConstants.au3>
#include <StringConstants.au3>

; Call function when Exit error
OnAutoItExitRegister("_ExitRegister")

;~ Set a hotkey Escape to exit the script
HotKeySet("{ESC}", "_ExitScript")

; Set Global Variables - Change these to match your values
Global $sMqttPub = "C:\Program Files\Mosquitto\mosquitto_pub.exe"
Global $sHost = "192.168.0.81"
Global $sTopic = "home/melco"

Run("MelcoOS.exe")

getStats()

Func getStats()
    Local $sCstitch = "", $sOld = ""
    While 1
        If WinExists("Melco OS SE - [413291]") Then
            ; Read Data from Melco OS
            Local $sData = WinGetText("Melco OS SE - [413291]")
            ; Split into an Array
            Local $aArray = StringSplit($sData, @CRLF)
				If @error Then
					ContinueLoop
				EndIf
            ; Copy Array values into variables (easier to understand what they are)
			Local $sLog = $aArray[11]
            Local $sJob = $aArray[13]
            Local $sJpct = $aArray[20]
            Local $sCstitch = $aArray[47]
            Local $sActifeed = $aArray[61]
            Local $sCspm = $aArray[44]
            Local $sTremain = $aArray[59]
            Local $sTstitch = $aArray[49]
            Local $sHoop = $aArray[58]

            ; Check if stitch count has increased, if not start loop again, else write to console and publish to MQTT
            If ($sCstitch == $sOld) Then
                Sleep(50)
                ContinueLoop
            Else

               ; Write to Console
			   ConsoleWrite("Log = " & $sLog & @CRLF)
               ConsoleWrite("Job Name = " & $sJob & @CRLF)
               ConsoleWrite("Current Spm = " & $sCspm & @CRLF)
               ConsoleWrite("Job % = " & $sJpct & @CRLF)
               ConsoleWrite("Stitch  = " & $sCstitch & @CRLF)
               ConsoleWrite("Total Stitch = " & $sTstitch & @CRLF)
               ConsoleWrite("Hoop = " & $sHoop & @CRLF)
               ConsoleWrite("Time Remaining = " & $sTremain & @CRLF)
               ConsoleWrite("Acti-feed = " & $sActifeed & @CRLF)

               $sJson = StringFormat('{\"cJob\":\"%s\",\"actifeed\":%s,\"cStitch\":%s,\"sCspm\":%s,\"sTstitch\":%s,\"cHoop\":\"%s\",\"sTremain\":\"%s\",\"sJpct\":\"%s\",\"sLog\":\"%s\"}', $sJob, $sActifeed, $sCstitch, $sCspm, $sTstitch, $sHoop, $sTremain, $sJpct, $sLog)


               $sMQTT = StringFormat('"%s" -h %s -t %s -m ' & '"%s"', $sMqttPub, $sHost, $sTopic, $sJson)
               ConsoleWrite($sMQTT & @CRLF)

               ; Send to MQTT Broker
                run($sMQTT, '', @SW_HIDE)

                ; Set $sOld to current stitch count before loop starts again
                $sOld = $sCstitch
            EndIf
        EndIf
        Sleep (50)
    WEnd
EndFunc

; Exit the script
Func _ExitScript()
    Exit
EndFunc

; Function to handle Script Exit errors, often happens when the Melco Program is close.
Func _ExitRegister()
    If @exitCode = 1 Then
        ConsoleWrite("exitCode = " & @exitCode & "   " & "exitMethod = " & @exitMethod & @CRLF)
        ; send yourself a Telegram message warning (your Telegram API integration)
        ; or send it by running another script etc...
	Run(@ScriptDir & "\Melco_stitch_launch.exe" & " /ErrorStdOut")
    EndIf
EndFunc   ;==>_ExitRegister
