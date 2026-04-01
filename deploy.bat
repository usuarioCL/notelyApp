@echo off
REM =========================================================
REM Notely App - Script de Despliegue Automático
REM =========================================================
REM Uso: deploy.bat [opcion]
REM Opciones: web, apk, test, clean
REM =========================================================

setlocal enabledelayedexpansion
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

REM Colores en consola
for /F %%A in ('echo prompt $H ^| cmd') do set "BS=%%A"

REM Funciones para colores
cls
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║        NOTELY APP - DESPLIEGUE AUTOMÁTICO              ║
echo ║        Versión 0.1.0+1                                 ║
echo ╚════════════════════════════════════════════════════════╝
echo.

REM Verificar que Flutter está instalado
where flutter >nul 2>nul
if errorlevel 1 (
    echo ❌ ERROR: Flutter no está instalado o no está en PATH
    echo.
    echo Para instalar Flutter:
    echo   1. Visita: https://flutter.dev/docs/get-started/install/windows
    echo   2. Descarga el SDK
    echo   3. Extrae el archivo
    echo   4. Agrega 'flutter\bin' a tu PATH
    echo.
    pause
    exit /b 1
)

echo ✓ Flutter encontrado
flutter --version
echo.

REM Determinar opción del usuario
set OPCION=%1
if "%OPCION%"=="" (
    echo Selecciona una opción:
    echo.
    echo   [1] Compilar para Web (Netlify/Firebase)
    echo   [2] Generar APK (Android)
    echo   [3] Ejecutar Tests
    echo   [4] Limpiar build
    echo   [5] Instalar dependencias
    echo   [6] Ejecutar en local (flutter run)
    echo   [0] Salir
    echo.
    set /p OPCION="Ingresa tu opción [0-6]: "
)

echo.
echo ────────────────────────────────────────────────────────
echo.

if "%OPCION%"=="1" goto deploy_web
if "%OPCION%"=="2" goto build_apk
if "%OPCION%"=="3" goto run_tests
if "%OPCION%"=="4" goto clean_build
if "%OPCION%"=="5" goto install_deps
if "%OPCION%"=="6" goto run_local
if "%OPCION%"=="0" goto exit_script
if "%OPCION%"=="web" goto deploy_web
if "%OPCION%"=="apk" goto build_apk
if "%OPCION%"=="test" goto run_tests
if "%OPCION%"=="clean" goto clean_build

echo ❌ Opción no válida
timeout /t 2 >nul
goto exit_script

REM =========================================================
REM OPCIÓN 1: Compilar para Web
REM =========================================================
:deploy_web
echo 🌐 Compilando para Web...
echo.

REM Limpiar build anterior
if exist build\web (
    echo Limpiando build anterior...
    rmdir /s /q build\web
)

REM Compilar
echo Compilando Flutter web release...
call flutter build web --release
if errorlevel 1 (
    echo ❌ Error durante compilación web
    pause
    exit /b 1
)

echo.
echo ✓ Compilación exitosa!
echo.
echo Archivos listos en: build\web\
echo.
echo ┌────────────────────────────────────────────────┐
echo │  OPCIONES PARA DESPLEGAR:                      │
echo ├────────────────────────────────────────────────┤
echo │                                                │
echo │  A) NETLIFY (Recomendado - Muy Fácil):        │
echo │     npm install -g netlify-cli                │
echo │     netlify login                             │
echo │     netlify deploy --prod --dir=build/web     │
echo │                                                │
echo │  B) FIREBASE:                                 │
echo │     npm install -g firebase-tools            │
echo │     firebase login                            │
echo │     firebase init hosting                    │
echo │     firebase deploy                          │
echo │                                                │
echo │  C) GITHUB PAGES:                            │
echo │     Pushear build/web a rama gh-pages        │
echo │                                                │
echo └────────────────────────────────────────────────┘
echo.
pause
exit /b 0

REM =========================================================
REM OPCIÓN 2: Generar APK
REM =========================================================
:build_apk
echo 📱 Generando APK para Android...
echo.

REM Verificar que Android SDK está disponible
where adb >nul 2>nul
if errorlevel 1 (
    echo ⚠ Advertencia: Android SDK no encontrado
    echo Asegúrate de haber instalado Android Studio
    echo.
)

echo Compilando APK release...
call flutter build apk --release
if errorlevel 1 (
    echo ❌ Error durante compilación APK
    pause
    exit /b 1
)

echo.
echo ✓ APK generado exitosamente!
echo.
echo Archivo: build\app\outputs\flutter-app-release.apk
echo Tamaño: aproximadamente 50-80 MB
echo.
echo Para instalar en dispositivo:
echo   1. Conecta tu teléfono via USB
echo   2. Ejecuta: flutter install
echo.
pause
exit /b 0

REM =========================================================
REM OPCIÓN 3: Ejecutar Tests
REM =========================================================
:run_tests
echo 🧪 Ejecutando tests...
echo.

call flutter test --no-coverage
if errorlevel 1 (
    echo ❌ Algunos tests fallaron
    pause
    exit /b 1
)

echo.
echo ✓ Todos los tests pasaron!
echo.
echo Para generar reporte de cobertura:
echo   flutter test --coverage
echo.
pause
exit /b 0

REM =========================================================
REM OPCIÓN 4: Limpiar Build
REM =========================================================
:clean_build
echo 🧹 Limpiando archivos de build...
echo.

call flutter clean
if exist build (
    rmdir /s /q build
)

echo ✓ Limpieza completada
echo.
pause
exit /b 0

REM =========================================================
REM OPCIÓN 5: Instalar Dependencias
REM =========================================================
:install_deps
echo 📦 Instalando dependencias...
echo.

call flutter pub get
if errorlevel 1 (
    echo ❌ Error al instalar dependencias
    pause
    exit /b 1
)

echo ✓ Dependencias instaladas
echo.
pause
exit /b 0

REM =========================================================
REM OPCIÓN 6: Ejecutar en Local
REM =========================================================
:run_local
echo ▶️ Iniciando app en modo debug...
echo.
echo Asegúrate de tener:
echo   - Emulador de Android/iOS ejecutándose, O
echo   - Dispositivo conectado via USB
echo.
pause

call flutter run
exit /b %ERRORLEVEL%

REM =========================================================
REM SALIR
REM =========================================================
:exit_script
echo Saliendo...
timeout /t 1 >nul
exit /b 0
