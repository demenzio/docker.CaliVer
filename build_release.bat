@echo off

title Build Script v1.0.0

set ver=
set choice=n

:CHOICEno

cls 

echo  Building xuvin/caliver:release

echo   Version      : %ver%
echo   Build Date   : %date%
echo.

set /p ver="Set Version (vX-X.XX.X) [%ver%]: "

IF not defined ver (
  cls
  GOTO ERROR1
) ELSE (GOTO QUESTION)

REM GOTO - Section

:EXIT
cmd /k

:ERROR1
echo  Error 1 - No Version Entered
echo.
set /p ver="Set Version (vX-X.XX.X) [%ver%]: "

IF not defined ver (
  cls
  GOTO ERROR1
) ELSE (GOTO QUESTION)

:QUESTION
cls
:CHOICEnotvalid
echo.
echo  Building xuvin/caliver:%ver%
echo.
set /p choice="Are you sure? [y/n]: "

IF %choice%==y (
  set choice=n
  GOTO BUILD
) ELSE (
  IF %choice%==n (
    GOTO CHOICEno
  ) ELSE (
    cls
    echo.
    echo  No valid answer given.
    echo.
    GOTO CHOICEnotvalid
  )
) 

:BUILD
cls
echo.
echo  Building xuvin/caliver:%ver%
echo.
docker build --build-arg VERSION=%ver% --build-arg BUILD_DATE=%date% -t xuvin/caliver:%ver% -t xuvin/caliver:latest .
echo.
echo  DONE.
echo  Have a nice day. :)
echo.
GOTO EXIT