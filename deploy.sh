#!/bin/bash

# =========================================================
# Notely App - Script de Despliegue Automático (Linux/macOS)
# =========================================================
# Uso: ./deploy.sh [opcion]
# Opciones: web, apk, test, clean
# =========================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
clear
echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║        NOTELY APP - DESPLIEGUE AUTOMÁTICO              ║"
echo "║        Versión 0.1.0+1                                 ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Verificar que Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ ERROR: Flutter no está instalado${NC}"
    echo ""
    echo "Para instalar Flutter en macOS:"
    echo "  1. brew install flutter"
    echo ""
    echo "Para instalar Flutter en Linux:"
    echo "  1. Visita: https://flutter.dev/docs/get-started/install/linux"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ Flutter encontrado${NC}"
flutter --version
echo ""

# Determinar opción del usuario
OPCION=$1
if [ -z "$OPCION" ]; then
    echo "Selecciona una opción:"
    echo ""
    echo "  [1] Compilar para Web (Netlify/Firebase)"
    echo "  [2] Generar APK (Android)"
    echo "  [3] Ejecutar Tests"
    echo "  [4] Limpiar build"
    echo "  [5] Instalar dependencias"
    echo "  [6] Ejecutar en local (flutter run)"
    echo "  [0] Salir"
    echo ""
    read -p "Ingresa tu opción [0-6]: " OPCION
fi

echo ""
echo "────────────────────────────────────────────────────────"
echo ""

case $OPCION in
    1|web)
        deploy_web
        ;;
    2|apk)
        build_apk
        ;;
    3|test)
        run_tests
        ;;
    4|clean)
        clean_build
        ;;
    5|install|deps)
        install_deps
        ;;
    6|run)
        run_local
        ;;
    0|exit)
        exit_script
        ;;
    *)
        echo -e "${RED}❌ Opción no válida${NC}"
        sleep 2
        exit 1
        ;;
esac

# =========================================================
# FUNCIÓN: Compilar para Web
# =========================================================
deploy_web() {
    echo -e "${BLUE}🌐 Compilando para Web...${NC}"
    echo ""

    # Limpiar build anterior
    if [ -d "build/web" ]; then
        echo "Limpiando build anterior..."
        rm -rf build/web
    fi

    # Compilar
    echo "Compilando Flutter web release..."
    flutter build web --release

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error durante compilación web${NC}"
        exit 1
    fi

    echo ""
    echo -e "${GREEN}✓ Compilación exitosa!${NC}"
    echo ""
    echo "Archivos listos en: build/web/"
    echo ""
    echo "┌────────────────────────────────────────────────┐"
    echo "│  OPCIONES PARA DESPLEGAR:                      │"
    echo "├────────────────────────────────────────────────┤"
    echo "│                                                │"
    echo "│  A) NETLIFY (Recomendado - Muy Fácil):        │"
    echo "│     npm install -g netlify-cli                │"
    echo "│     netlify login                             │"
    echo "│     netlify deploy --prod --dir=build/web     │"
    echo "│                                                │"
    echo "│  B) FIREBASE:                                 │"
    echo "│     npm install -g firebase-tools            │"
    echo "│     firebase login                            │"
    echo "│     firebase init hosting                    │"
    echo "│     firebase deploy                          │"
    echo "│                                                │"
    echo "│  C) GITHUB PAGES:                            │"
    echo "│     Pushear build/web a rama gh-pages        │"
    echo "│                                                │"
    echo "└────────────────────────────────────────────────┘"
    echo ""
    read -p "Presiona Enter para continuar..."
}

# =========================================================
# FUNCIÓN: Generar APK
# =========================================================
build_apk() {
    echo -e "${BLUE}📱 Generando APK para Android...${NC}"
    echo ""

    echo "Compilando APK release..."
    flutter build apk --release

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error durante compilación APK${NC}"
        exit 1
    fi

    echo ""
    echo -e "${GREEN}✓ APK generado exitosamente!${NC}"
    echo ""
    echo "Archivo: build/app/outputs/flutter-app-release.apk"
    echo "Tamaño: aproximadamente 50-80 MB"
    echo ""
    echo "Para instalar en dispositivo:"
    echo "  1. Conecta tu teléfono via USB"
    echo "  2. Ejecuta: flutter install"
    echo ""
    read -p "Presiona Enter para continuar..."
}

# =========================================================
# FUNCIÓN: Ejecutar Tests
# =========================================================
run_tests() {
    echo -e "${BLUE}🧪 Ejecutando tests...${NC}"
    echo ""

    flutter test --no-coverage

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Algunos tests fallaron${NC}"
        exit 1
    fi

    echo ""
    echo -e "${GREEN}✓ Todos los tests pasaron!${NC}"
    echo ""
    echo "Para generar reporte de cobertura:"
    echo "  flutter test --coverage"
    echo ""
    read -p "Presiona Enter para continuar..."
}

# =========================================================
# FUNCIÓN: Limpiar Build
# =========================================================
clean_build() {
    echo -e "${BLUE}🧹 Limpiando archivos de build...${NC}"
    echo ""

    flutter clean
    rm -rf build/

    echo -e "${GREEN}✓ Limpieza completada${NC}"
    echo ""
    read -p "Presiona Enter para continuar..."
}

# =========================================================
# FUNCIÓN: Instalar Dependencias
# =========================================================
install_deps() {
    echo -e "${BLUE}📦 Instalando dependencias...${NC}"
    echo ""

    flutter pub get

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error al instalar dependencias${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ Dependencias instaladas${NC}"
    echo ""
    read -p "Presiona Enter para continuar..."
}

# =========================================================
# FUNCIÓN: Ejecutar en Local
# =========================================================
run_local() {
    echo -e "${BLUE}▶️ Iniciando app en modo debug...${NC}"
    echo ""
    echo "Asegúrate de tener:"
    echo "  - Emulador de Android/iOS ejecutándose, O"
    echo "  - Dispositivo conectado via USB"
    echo ""
    read -p "Presiona Enter para continuar..."

    flutter run
}

# =========================================================
# FUNCIÓN: Salir
# =========================================================
exit_script() {
    echo "Saliendo..."
    sleep 1
    exit 0
}
