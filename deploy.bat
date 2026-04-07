@echo off
setlocal

cd /d "%~dp0"

echo === InkOS Deploy ===

:: Check Node.js
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Node.js not found. Please install Node.js ^>= 20.
    exit /b 1
)

for /f "tokens=1 delims=v." %%a in ('node -v') do set NODE_MAJOR=%%a
for /f "tokens=2 delims=v." %%a in ('node -v') do set NODE_MAJOR=%%a
if %NODE_MAJOR% lss 20 (
    echo Error: Node.js ^>= 20 required ^(current: %NODE_MAJOR%^)
    exit /b 1
)

:: Check pnpm
where pnpm >nul 2>&1
if %errorlevel% neq 0 (
    echo pnpm not found, installing via corepack...
    corepack enable
    corepack prepare pnpm@latest --activate
)

:: Install dependencies
echo ^>^>^> pnpm install
call pnpm install --frozen-lockfile
if %errorlevel% neq 0 (
    echo Error: pnpm install failed.
    exit /b 1
)

:: Build all packages
echo ^>^>^> pnpm build
call pnpm build
if %errorlevel% neq 0 (
    echo Error: pnpm build failed.
    exit /b 1
)

echo.
echo === Build complete ===
echo.
echo To start InkOS Studio:  cd packages\studio ^&^& node dist\api\index.js
echo To use CLI:             cd packages\cli ^&^& node dist\index.js

endlocal
