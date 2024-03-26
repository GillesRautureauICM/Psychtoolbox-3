ECHO OFF
CLS

ECHO.
ECHO This script will setup touchscreen for best performances in experiment
ECHO It disable right-click emulation wich slow down response when user keep touching the screen
ECHO You can chose to disable visual feedback
ECHO You can also enable or disable edge-swipe gestures
ECHO.
ECHO 1 - Disable right-click emulation WITHOUT visual feedback
ECHO 2 - Disable right-click emulation WITH visual feedback
ECHO 3 - Restore right-click emulation and visual feedback
ECHO 4 - Disable edge-swipe gestures
ECHO 5 - Enable edge-swipe gestures
ECHO 6 - Do nothing (quit)
ECHO.

SET /P M=Type a number (1-6) then press ENTER:

IF %M%==1 GOTO WITHOUT
IF %M%==2 GOTO WITH
IF %M%==3 GOTO RESTORE
IF %M%==4 GOTO GESTURESOFF
IF %M%==5 GOTO GESTURESON
GOTO EOF

:WITHOUT
reg import "reg\\touchscreen_setup (without visual feedback).reg"
GOTO APPLY

:WITH
reg import "reg\\touchscreen_setup (with visual feedback).reg"
GOTO APPLY

:GESTURESOFF
reg import "reg\\touchscreen_gestures (disable).reg"
GOTO APPLY

:GESTURESON
reg import "reg\\touchscreen_gestures (enable).reg"
GOTO APPLY

:RESTORE
reg import "reg\\touchscreen_setup (restore).reg"
GOTO APPLY


:APPLY
timeout /T 1 /NOBREAK >nul
RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True
ECHO .
timeout /T 1 /NOBREAK >nul
RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True
ECHO .
timeout /T 1 /NOBREAK >nul
RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True

ECHO If some changes didn't take effect, try to disconnect and reconnect your session or restart computer


:EOF
pause
