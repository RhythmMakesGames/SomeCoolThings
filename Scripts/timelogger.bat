:: ----------------------------------------------------------------------

:: Simple time logger batch script to keep you productive :)

:: uncomment(remove @REM from) 'goto todays_log' if View Logs too slow.
:: Rename the script to !timelogger.bat so it shows up before other files

:: References:
:: for colored text: https://stackoverflow.com/a/38617204/10825354
:: errorlevel: https://ss64.com/nt/errorlevel.html


:: ----------------------------------------------------------------------

@echo off
@REM mode con: cols=52 lines=25

:refresh
cls
TITLE RMG: [Time logger]

set YY=%date:~10,4%
set MM=%date:~4,2%
set DD=%date:~7,2%

set present_day=%YY%-%MM%-%DD%
set present_time=%time:~,5%
set present_day_logfile=%present_day%_log.txt

echo [34mPresent Day:[0m %present_day%
echo [34mPresent Time:[0m %present_time%
echo.

echo [1m[a][0m - Add Entry
echo [1m[v][0m - View logs
echo [1m[n][0m - Open logfile in Notepad
echo [1m[i][0m - Open logfile in Vim
echo [1m[e][0m - Exit batch
echo.

choice /c avnie /n
cls

if %ERRORLEVEL% equ 1 goto add_entry
if %ERRORLEVEL% equ 2 goto read_logfile
if %ERRORLEVEL% equ 3 goto edit_logfile_notepad
if %ERRORLEVEL% equ 4 goto edit_logfile_vim
if %ERRORLEVEL% equ 5 exit

:: just in case
pause
goto refresh

:add_entry
set /p entry_value=Entry Summary: 
echo %present_time% - %entry_value%>> %present_day_logfile%
@REM echo Entry added..
@REM pause
goto refresh

:edit_logfile_notepad
if exist %present_day_logfile% (
	notepad %present_day_logfile%
) else (
	echo No log file found.
	echo Add an entry to create a new one.
	echo.
	pause
)
goto refresh

:edit_logfile_vim
if exist %present_day_logfile% (
	nvim %present_day_logfile%
) else (
	echo No log file found.
	echo Add an entry to create a new one.
	echo.
	pause
)
goto refresh

:read_logfile
@REM goto todays_log

echo loading..
for /f "delims=" %%a in (
	' powershell -command "Get-Date (Get-Date).AddDays(-1) -Format 'yyyy-MM-dd'" '
) do set "previous_day_logfile=%%a_log.txt"
cls

:: since your day probably ends at 2 am
:: you might need logs from the day before

echo [34m[Day Before]:[0m
if exist %previous_day_logfile% (
	type %previous_day_logfile%
) else (
	echo No logs found.
)
echo.

:todays_log
echo [34m[Present Day]:[0m
if exist %present_day_logfile% (
	type %present_day_logfile%
) else (
	echo No logs found.
)
echo.

pause
goto refresh

:: ----------------------------------------------------------------------