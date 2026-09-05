@echo off
setlocal
title Tavern Auto Image - 一键安装桥
set "AUTO="
if /i "%~1"=="--auto" set "AUTO=1"

echo ============================================
echo   Tavern Auto Image  一键安装（酒馆服务端桥）
echo ============================================
echo.

REM ── 0. 自动定位酒馆根目录：从当前目录向上逐层找 config.yaml ──
set "ROOT=%~dp0"
set "PREV="
:findroot
if not defined PREV set "PREV=%ROOT%"
if exist "%ROOT%config.yaml" goto rootfound
for %%i in ("%ROOT%.") do set "NEXT=%%~dpi"
if /i "%NEXT%"=="%PREV%" goto rootnotfound
set "PREV=%NEXT%"
set "ROOT=%NEXT%"
goto findroot
:rootnotfound
echo [错误] 找不到酒馆根目录（没找到 config.yaml）。
echo 请把 install.bat 放到酒馆根目录（有 config.yaml 和 server.js 的那个文件夹）再双击。
echo.
if not defined AUTO pause
exit /b 1
:rootfound
echo [1/4] 酒馆根目录：%ROOT%

REM ── 1. 校验 Node ──
where node >nul 2>&1
if errorlevel 1 (
    echo [错误] 没找到 Node.js（酒馆本身就依赖 Node，正常安装过酒馆就一定有）。
    echo 请先安装 Node.js 22+，然后重新运行本程序。
    if not defined AUTO pause
    exit /b 1
)
for /f "delims=" %%v in ('node -v') do set "NODEV=%%v"
echo [2/4] Node.js：%NODEV%

REM ── 2. 桥文件：本地搜索（装扩展时已随仓库下载）→ 同目录 → 联网下载兜底 ──
set "SRC="
if exist "%ROOT%tavern-auto-img-bridge.mjs" set "SRC=%ROOT%tavern-auto-img-bridge.mjs"
if not defined SRC for /d %%d in ("%ROOT%data\default-user\extensions\*") do ( if exist "%%d\bridge\tavern-auto-img-bridge.mjs" set "SRC=%%d\bridge\tavern-auto-img-bridge.mjs" )
if not defined SRC for /d %%d in ("%ROOT%public\scripts\extensions\third-party\*") do ( if exist "%%d\bridge\tavern-auto-img-bridge.mjs" set "SRC=%%d\bridge\tavern-auto-img-bridge.mjs" )
if not defined SRC (
    echo        正在从 GitHub 下载桥文件...
    powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/skyyy231/tavern-auto-img/master/bridge/tavern-auto-img-bridge.mjs' -OutFile '%ROOT%tavern-auto-img-bridge.mjs'" >nul 2>&1
    if exist "%ROOT%tavern-auto-img-bridge.mjs" set "SRC=%ROOT%tavern-auto-img-bridge.mjs"
)
if not defined SRC (
    echo [错误] 没找到桥文件（扩展目录、本目录都没有，且下载失败）。
    echo 请确认已通过链接安装扩展「tavern-auto-img-extension」后再试。
    if not defined AUTO pause
    exit /b 1
)
if not exist "%ROOT%plugins" mkdir "%ROOT%plugins" 2>nul
copy /Y "%SRC%" "%ROOT%plugins\tavern-auto-img-bridge.mjs" >nul
echo [3/4] 桥已复制到：plugins\tavern-auto-img-bridge.mjs

REM ── 3. 开启服务端插件开关（config.yaml 为 UTF-8 读取/写入）──
powershell -NoProfile -Command "$p='%ROOT%config.yaml'; $c=[System.IO.File]::ReadAllText($p,[System.Text.Encoding]::UTF8); if($c -match '(?m)^enableServerPlugins:\s*false'){ $c=$c -replace '(?m)^enableServerPlugins:\s*false','enableServerPlugins: true'; [System.IO.File]::WriteAllText($p,$c,(New-Object System.Text.UTF8Encoding($false))); 'config.yaml：enableServerPlugins 已开启。' } elseif($c -match '(?m)^enableServerPlugins:\s*true'){ 'config.yaml：enableServerPlugins 已是 true（无需修改）。' } else { 'config.yaml：未找到该设置，帮你追加一行。'; $c=$c + \"`r`n`r`nenableServerPlugins: true`r`n`r`n\"; [System.IO.File]::WriteAllText($p,$c,(New-Object System.Text.UTF8Encoding($false))); '已追加 enableServerPlugins: true。' }"
echo [4/4] 服务端插件开关完成。

REM ── 4. 检测酒馆是否在运行 ──
set "RPID="
for /f %%i in ('powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0detect_running.ps1"') do set "RPID=%%i"
if not "%RPID%"=="" (
    echo.
    echo [提示] 检测到酒馆正在运行（进程 %RPID%）。
    echo        下一步的重启 = 关闭酒馆「整个服务」（你的酒馆窗口/聊天会短暂断开），
    echo        再从后台重新启动酒馆。这不是只刷新网页！网页刷新由你自己做。
    set "ANS=N"
    if not defined AUTO set /p ANS=确认重启酒馆整个服务？ Y=立即重启 / N=我稍后自己重启（默认N）
    if /i "%ANS:~0,1%"=="Y" (
        echo         正在关闭酒馆服务进程并重新启动...
        powershell -NoProfile -Command "Stop-Process -Id %RPID% -Force -Confirm:$false" >nul 2>&1
        timeout /t 2 /nobreak >nul
        powershell -NoProfile -Command "Start-Process -FilePath 'node' -ArgumentList 'server.js' -WorkingDirectory '%ROOT%' -WindowStyle Hidden" >nul 2>&1
        echo         已重启（后台无窗口运行）。等 10 秒左右，刷新酒馆网页即可。
    ) else (
        echo         好的。请【完全关闭酒馆】——关掉启动酒馆的那个 CMD/Start.bat 窗口，
        echo         然后重新双击 Start.bat（或你平时启动酒馆的方式）启动酒馆。
        echo         【不要】只点浏览器刷新，服务端桥需要酒馆服务重启才生效。
    )
) else (
    echo.
    echo 酒馆当前未运行。下次启动酒馆时，桥会自动随酒馆运行。
)

echo.
echo ============================================
echo   安装完成！打开酒馆后右下角出现 闪电图标 按钮
echo   文生图控制台即安装成功。
echo ============================================
echo.
if not defined AUTO pause
