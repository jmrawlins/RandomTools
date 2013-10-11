@echo off
setlocal ENABLEDELAYEDEXPANSION

if "%1"=="" (
  echo "usage: %0 <target dir> <filename suffix> <'go' or 'dry'>"
  goto :eof
)
set targetDir=%1
  

set dash=-
if "%2"=="" set dash=
set suffix=%2
echo !dash!%suffix%

if "%3"=="go" (
  set dry=false
) else (
  set dry=true
)


set /a count=1

set lastFileDate=

for %%e in (GIF JPG PNG MOV) do (
  echo %%e
  for %%f in (*.%%e) do (
    set filedateraw=%%~tf
    REM  echo %filedateraw%
    for /F "tokens=1-3 delims=/ " %%a in ("!filedateraw!") do (
      set fileDate=%%c-%%a-%%b
      REM echo Last: !lastFileDate! Now: !fileDate!
      if not "!fileDate!" == "!lastFileDate!" set /a count=1


      REM    echo %fileDate%
      for /L %%n in (1,1,1000) do (
        
        if not exist "%targetDir%\%%c\!fileDate!!dash!%suffix% (!countStr!).%%e" (
          REM echo !count! does not exist
        ) else (
          set /a count=count+1
        )

      )

      :break

      set countStr=000!count!
      set countStr=!countStr:~-3!

      if %dry%==true (
        if not exist "%targetDir%\%%c" echo "Creating dir %targetDir%\%%c"
        echo move /-Y "%%f" "%targetDir%\%%c\!fileDate!!dash!%suffix% (!countStr!).%%e"
      ) else (
        if not exist %targetDir%\%%c mkdir "%targetDir%\%%c"
        move /-Y "%%f" "%targetDir%\%%c\!fileDate!!dash!%suffix% (!countStr!).%%e"
      )

      set lastFileDate=!fileDate!
      set /a count=count+1

    )
  )
)

endlocal 