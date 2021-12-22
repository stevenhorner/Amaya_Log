
#include <FileConstants.au3>
#include <StringConstants.au3>
;~ Set a hotkey Escape to exit the script
HotKeySet("{ESC}", "_ExitScript")

; Set Global Variables - Change these to match your values
Global $sMqttPub = "C:\Mosquitto\mosquitto_pub.exe"
Global $sHost = "192.168.0.81"
Global $sTopic = "home/amaya"

Run("AMAYA.exe")

getStats()

Func getStats()
    Local $sCstitch = "", $sOld = ""
    While 1
        If WinExists("AMAYA OS Lite") Then
			; Read Data from Amaya OS
            Local $sData = WinGetText("AMAYA OS Lite")
			; Split into an Array
			Local $aArray = StringSplit($sData, @CRLF)
			; Copy Array values into variables (easier to understand what they are)
			Local $sJob = $aArray[12]
			Local $sJpct = $aArray[19]
			Local $sCstitch = $aArray[39]
			Local $sActifeed = $aArray[48]
			Local $sCspm = $aArray[17]
			Local $sTremain = $aArray[46]
			Local $sTstitch = $aArray[41]
			Local $sHoop = $aArray[45]
			
			; Check if stitch count has increased, if not start loop again, else write to console and publish to MQTT
            If ($sCstitch == $sOld) Then
                Sleep(50)
                ContinueLoop
            Else
			   
			   ; Write to Console
			   ConsoleWrite("Job Name = " & $sJob & @CRLF)
			   ConsoleWrite("Current Spm = " & $sCspm & @CRLF)
			   ConsoleWrite("Job % = " & $sJpct & @CRLF)
			   ConsoleWrite("Stitch  = " & $sCstitch & @CRLF)
			   ConsoleWrite("Total Stitch = " & $sTstitch & @CRLF)
			   ConsoleWrite("Hoop = " & $sHoop] & @CRLF)
			   ConsoleWrite("Time Remaining = " & $sTremain & @CRLF)
			   ConsoleWrite("Acti-feed = " & $sActifeed & @CRLF)
				
                ; Send to MQTT Broker
                run('$sMqttPub -h $sHost-t $sTopic -m "{job:" & $sJob & ", jpct:" & $sJpct & ", cstitch:" & $sCstitch] & ", actifeed: & $sActifeed & "}", '', @SW_HIDE)
				
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
