#include <FileConstants.au3>
#include <Date.au3>
;~ Set a hotkey Escape to exit the script
HotKeySet("{ESC}", "_ExitScript")

; Create file in same folder as script
Global $sFileName = "c:\Log\Amaya_Log.txt"
Global $hFileOpen = FileOpen($sFileName, $FO_APPEND)
Global $sMqttPub = "C:\Program Files\Mosquitto\mosquitto_pub.exe"
Global $sHost = "192.168.0.81"
Global $sTopic = "home/amayalog"

Run("AMAYA.exe")

getAmaya()

Func getAmaya()
    Local $sID = "", $oLd = ""
    While 1
        If WinExists("AMAYA OS Lite") Then
            $sID = ControlGetText("AMAYA OS Lite", "", "[CLASS:Edit; INSTANCE:22]")
			Local $sArray = StringSplit($sID, "-")
			Local $sTime = $sArray[1]
			Local $sCluster = $sArray[2]
			Local $sHead = $sArray[3]
			Local $sDetail = $sArray[4]
			Local $sMessage = $sHead & $sDetail
            If ($sID == $oLD) Then
                Sleep(50)
                ContinueLoop
            Else
                ConsoleWrite(_NowCalcDate() & " - " & $sID & @CRLF)
				ConsoleWrite("Time: " & $sTime & @CRLF)
				ConsoleWrite("Cluster: " & $sCluster & @CRLF)
				ConsoleWrite("Message: " & $sMessage & @CRLF)
                ; Append a line
                FileWrite($hFileOpen, _NowCalcDate() & " - " & $sID & @CRLF)
				; $sJson = StringFormat('{\"sAmayaLog\":\"%s\"', $sID)
				$sJson = StringFormat('{\"sTime\":\"%s\", \"sCluster\":\"%s\",\"sMessage\":\"%s\"}', $sTime, $sCluster, $sMessage)
				$sMQTT = StringFormat('"%s" -h %s -t %s -m ' & '"%s"', $sMqttPub, $sHost, $sTopic, $sJson)
				run($sMQTT, '', @SW_HIDE)
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
