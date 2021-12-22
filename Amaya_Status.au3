#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>


Run("AMAYA.exe")

        If WinExists("AMAYA OS Lite") Then
            Local $sAM = WinGetText("AMAYA OS Lite")
			Local $aArray = StringSplit($sAM, @CRLF)

	  #MsgBox($MB_SYSTEMMODAL, "", $aArray[17])

                ConsoleWrite("Job Name = " & $aArray[12] & @CRLF)
		ConsoleWrite("Current Spm = " & $aArray[17] & @CRLF)
		ConsoleWrite("Job % = " & $aArray[19] & @CRLF)
		ConsoleWrite("Stitch  = " & $aArray[39] & @CRLF)
		ConsoleWrite("Total Stitch = " & $aArray[41] & @CRLF)
		ConsoleWrite("Hoop = " & $aArray[45] & @CRLF)
		ConsoleWrite("Time Remaining = " & $aArray[46] & @CRLF)
		ConsoleWrite("Acti-feed = " & $aArray[48] & @CRLF)

#run('PATH\Mosquitto\mosquitto_pub.exe -h HOST -t TOPIC -m "{job:" & $aArray[12] & ", jpct:" & aArray[19] & ", cstitch:" & aArray[39] & ", actifeed: & aArray[48] & "}", '', @SW_HIDE)


        EndIf
