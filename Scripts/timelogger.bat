:: ------------------------------------------------------------------------------------------------

:: Simple time logger batch script to keep you productive :)

:: Rename the script(eg. _timelogger.bat) to make it appear before other files
:: open command line, and type echo %date% to see your date format

:: colored text: https://stackoverflow.com/a/38617204/10825354
:: errorlevel: https://ss64.com/nt/errorlevel.html
:: setlocal and delayedexpansion: https://stackoverflow.com/q/6679907/10825354

:: ------------------------------------------------------------------------------------------------

@echo off
@REM mode con: cols=52 lines=25
TITLE RMG: [Time logger]

:: set to 1 to show previous day logs with 'view logs' option, disable for speed
set /a view_past_log=1

:: set to 0 to use %date% and %time% (faster, but format issues)
set /a get_datetime_using_wmic_call=1

:: to reorder menu options without breaking script
:: (make sure to modify menu echo statements, and choice args)
set /a menu_add_entry=1
set /a menu_view_logs=2
set /a menu_open_in_notepad=3
set /a menu_open_in_vim=4
set /a menu_exit=5

set /a menu_label=0

:refresh
cls
echo Computing values..
set /a return_label=%menu_label%
goto update_variables

:menu
cls
echo [34mPresent Day:[0m %present_day%
echo [34mPresent Time:[0m %present_time%
echo.

echo 1. Add Entry [34m[a][0m
echo 2. View logs [34m[v][0m
echo 3. Open logfile in Notepad [34m[n][0m 
echo 4. Open logfile in Vim [34m[i][0m 
echo 5. Exit batch [34m[e][0m 
echo.

choice /c avnie /n
cls

:: errorlevel value corresponds to the choice (1-5)
:: possible unexpected return label values: <= 0, >5
set /a return_label=%ERRORLEVEL%

if %return_label% equ %menu_exit% exit

echo Computing values..
goto update_variables

:add_entry
set /p entry_value=Entry Summary: 
echo %present_time% - %entry_value%>> %present_day_logfile%
@REM echo Entry added..
@REM pause
goto refresh

:edit_logfile_notepad

@REM if exist %present_day_logfile% (
@REM 	notepad %present_day_logfile%
@REM ) else (
@REM 	echo No log file found for today ^(%present_day%^).
@REM 	echo Add an entry to create one.
@REM 	echo.
@REM 	pause
@REM )

if not exist %present_day_logfile% type nul > %present_day_logfile%
notepad %present_day_logfile%
goto refresh

:edit_logfile_vim

@REM if exist %present_day_logfile% (
@REM 	nvim %present_day_logfile%
@REM ) else (
@REM 	echo No log file found for today ^(%present_day%^).
@REM 	echo Add an entry to create one.
@REM 	echo.
@REM 	pause
@REM )

if not exist %present_day_logfile% type nul > %present_day_logfile%
nvim %present_day_logfile%
goto refresh

:view_logs
if not %view_past_log% equ 1 goto end_view_previous

echo [34m[Day Before]:[0m
if exist %previous_day_logfile% (
	type %previous_day_logfile%
) else (
	echo No logs found.
)
echo.

:end_view_previous

echo [34m[Present Day]:[0m
if exist %present_day_logfile% (
	type %present_day_logfile%
) else (
	echo No logs found.
)
echo.

pause
goto refresh

:update_variables

if not %get_datetime_using_wmic_call% equ 1 (
	goto evaulate_datetime_batch
) else (
	goto evaluate_datetime_wmic
)

:evaulate_datetime_batch
:: date/time format problem (%date% output depends on regional format) 
:: set to English (United States) to prevent hair loss
for /f "tokens=1-3 delims=/" %%a in ('echo %date:~4%') do (set present_day=%%c-%%a-%%b)
set present_time=%time:~,5%
goto end_evaluate_datetime

:evaluate_datetime_wmic
for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do (set ISO_dt=%%a)
set present_day=%ISO_dt:~0,4%-%ISO_dt:~4,2%-%ISO_dt:~6,2%
set present_time=%ISO_dt:~8,2%^:%ISO_dt:~10,2%
goto end_evaluate_datetime

:end_evaluate_datetime

set present_day_logfile=%present_day%_log.txt

:: only need to compute previous day for view logs option
if not %return_label% equ %menu_view_logs% goto end_previous_day
:: and only if viewpastlogs is enabled
if not %view_past_log% equ 1 goto end_previous_day

@REM :start_previous_day

:: get previous day using powershell (slow)
@REM echo loading..
@REM for /f "delims=" %%a in (
@REM 	' powershell -command "Get-Date (Get-Date).AddDays(-1) -Format 'yyyy-MM-dd'" '
@REM ) do set "previous_day_logfile=%%a_log.txt"
@REM cls

:: get previous day using batch

set /a year=%present_day:~0,4%
set /a month=1%present_day:~5,2%-100
set /a day=1%present_day:~8,2%-100

set /a day=%day%-1

setlocal enabledelayedexpansion
if %day% equ 0 (
	set /a month=%month%-1
	if !month! equ 0 (
		set /a year=%year%-1
		set /a month=12
		set /a day=31
	) else if !month! equ 2 (
		
		set /a mod4=%year% %% 4
		
		if !mod4! equ 0 (
			set /a mod100=%year% %% 100
			set /a mod400=%year% %% 400

			if !mod100! neq 0 (set /a day=29) else (
					if !mod400! equ 0 (set /a day=29) else (set /a day=28)
				)
			) else (set /a day=28)
		
		set "mod100="
		set "mod400="
		set "mod4="

	) else (
		for %%x in (2 4 6 9 11) do (if !month! equ %%x set /a day=30)
		if !day! neq 30 set /a day=31
	)
)
setlocal disabledelayedexpansion
set month=0%month%
set day=0%day%

set previous_day=%year%-%month:~-2%-%day:~-2%
set previous_day_logfile=%previous_day%_log.txt

:end_previous_day

cls
if %return_label% equ %menu_label% goto menu
if %return_label% equ %menu_add_entry% goto add_entry
if %return_label% equ %menu_view_logs% goto view_logs
if %return_label% equ %menu_open_in_notepad% goto edit_logfile_notepad
if %return_label% equ %menu_open_in_vim% goto edit_logfile_vim

:: just in case
echo Error: Unexpected return_label value ^(%return_label%^).
pause
goto refresh

:: ------------------------------------------------------------------------------------------------