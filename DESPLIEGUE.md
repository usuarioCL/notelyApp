# 🚀 Opciones de Despliegue - Notely App

## 📍 Formas de Ver/Desplegar la Aplicación

### Opción 1: Compilación Local (Recomendado para Testing)
**Requisitos**: Flutter SDK 3.0+ instalado localmente

```bash
# 1. Clonar repositorio
git clone https://github.com/usuarioCL/notelyApp.git
cd notelyApp

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar en emulador/dispositivo
flutter run

# 4. Ejecutar en Web (alternativa)
flutter run -d web
```

**Plataformas soportadas**:
- ✅ Android (APK/AAB)
- ✅ iOS (IPA) - requiere macOS
- ✅ Web (navegador)
- ✅ Windows, macOS, Linux (desktop)

---

### Opción 2: APK Standalone (Android)
**Para instalar en dispositivos Android reales**

```bash
cd c:\pyDev\notely-app

# Generar APK de Debug
flutter build apk --debug

# Generar APK de Release (optimizado)
flutter build apk --release

# Resultado
# build/app/outputs/flutter-app-debug.apk
# build/app/outputs/flutter-app-release.apk
```

**Instalación**:
```bash
# Conectar dispositivo via USB
flutter install

# O instalar manualmente
adb install build/app/outputs/flutter-app-release.apk
```

---

### Opción 3: Web Deploy (Producción Online)
**Publicar en internet para acceso desde navegador**

#### Paso 1: Compilar para Web
```bash
cd c:\pyDev\notely-app

# Generar build web
flutter build web

# Resultado en: build/web/
```

#### Paso 2: Desplegar en Firebase Hosting (Fácil ✨)

```bash
# 1. Instalar Firebase CLI
npm install -g firebase-tools

# 2. Login en Firebase
firebase login

# 3. Inicializar proyecto
cd c:\pyDev\notely-app
firebase init hosting

# 4. Seleccionar:
#    - Proyecto: notelyApp (de Firebase Console)
#    - Directorio público: build/web

# 5. Desplegar
firebase deploy
```

**Resultado**:
```
Hosting URL: https://notely-app.web.app
Disponible en: Cualquier dispositivo con internet
```

---

#### Alternativa: Netlify (Muy Fácil)

```bash
# 1. Instalar Netlify CLI
npm install -g netlify-cli

# 2. Login
netlify login

# 3. Desplegar
netlify deploy --prod --dir=build/web
```

**Resultado**:
```
Hosting URL: https://notely-app.netlify.app
```

---

#### Alternativa: Vercel

```bash
# 1. Instalar Vercel CLI
npm install -g vercel

# 2. Desplegar
cd c:\pyDev\notely-app
vercel --prod
```

---

### Opción 4: Docker (Containerización)
**Para desplegar en cualquier servidor**

```dockerfile
# Crear: Dockerfile
FROM ubuntu:22.04

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip

# Instalar Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

# Clonar app
RUN git clone https://github.com/usuarioCL/notelyApp.git /app
WORKDIR /app

# Instalar dependencias
RUN flutter pub get

# Compilar web
RUN flutter build web --release

# Server
FROM nginx:latest
COPY --from=0 /app/build/web /usr/share/nginx/html
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

**Ejecutar**:
```bash
docker build -t notely-app .
docker run -p 80:80 notely-app
```

**Acceder**: http://localhost

---

### Opción 5: App Store / Play Store
**Para distribución pública**

#### Google Play Store (Android)

```yaml
# pubspec.yaml ya configurado:
name: notely_app
description: "Una aplicación multiplataforma de notas tipo Notion..."
version: 0.1.0+1

# Proceso:
# 1. Generar keystore
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# 2. Generar AAB (Android App Bundle)
flutter build appbundle --release

# 3. Subir a Play Console: https://play.google.com/console
# 4. Crear app, configurar metadatos, subir AAB
# 5. Esperar revisión (24-48 hrs)
```

#### Apple App Store (iOS)

```bash
# Requiere: macOS + Xcode + Cuenta de Apple Developer ($99/año)

# 1. Configurar firma en Xcode
flutter build ios --release

# 2. Archivizar en Xcode
open ios/Runner.xcworkspace

# 3. Subir a App Store Connect
# 4. Esperar revisión (24-48 hrs)
```

---

## 🌐 Estado Actual de Despliegue

### Repositorio GitHub
- ✅ **Nombre**: notelyApp
- ✅ **URL**: https://github.com/usuarioCL/notelyApp.git
- ✅ **Estado**: 9 commits, rama main actualizada
- ✅ **Acceso**: Público

```bash
# Para clonar
git clone https://github.com/usuarioCL/notelyApp.git
```

---

## 📋 Checklist Antes de Desplegar

### Testing
- [x] 102 test cases pasando
- [x] Cobertura ≥78%
- [x] Sin errores de compilación

### Configuración Firebase
- [ ] Crear proyecto en Firebase Console
- [ ] Generar google-services.json (Android)
- [ ] Generar GoogleService-Info.plist (iOS)
- [ ] Configurar Authentication
- [ ] Configurar Firestore Database
- [ ] Habilitar Web Hosting (opcional)

### Seguridad
- [ ] Configurar Firebase Security Rules
- [ ] Validar autenticación
- [ ] Revisar manejo de errores
- [ ] Ejecutar security audit

### Performance
- [ ] Probar con 100+ notas
- [ ] Verificar tiempo de carga
- [ ] Monitorear consumo de data
- [ ] Optimizar imágenes/assets

### Documentación
- [x] README.md completado
- [x] SETUP_PRODUCCION.md
- [x] GUIA_VISUAL.md
- [x] PROYECTO_ESTADO.md
- [ ] Documentación API (endpoint)
- [ ] Guía de contribución

---

## 🎯 Recomendación: Flujo Completo

### Paso 1: Testing Local (Hoy)
```bash
# Clonar el repo
git clone https://github.com/usuarioCL/notelyApp.git

# Instalar Flutter y dependencias
flutter pub get

# Ejecutar en local
flutter run
```

### Paso 2: Web Deploy (Mañana)
```bash
# Compilar para web
flutter build web

# Desplegar a Firebase/Netlify
firebase deploy  # o netlify deploy --prod
```

### Paso 3: Mobile Deploy (Semana siguiente)
```bash
# Generar AAB para Play Store
flutter build appbundle --release

# Subirlo a Google Play Console
```

---

## 💡 Recomendaciones por Caso de Uso

### Caso 1: "Quiero verla funcionando hoy"
→ **Opción**: Web en Netlify
- Tiempo: 5 minutos
- Costo: Gratis
- Acceso: URL pública

```bash
flutter build web
netlify deploy --prod --dir=build/web
```

### Caso 2: "Quiero testarla en mi teléfono"
→ **Opción**: APK/IPA instalada
- Tiempo: 10 minutos
- Costo: Gratis
- Acceso: Solo tu dispositivo

```bash
flutter build apk --release
# Instalar en Android
```

### Caso 3: "Quiero publicarla públicamente"
→ **Opción**: Play Store + App Store
- Tiempo: 1-2 semanas
- Costo: $100-200 (cuentas developer)
- Acceso: Millones de usuarios

```bash
# Play Store
flutter build appbundle --release

# App Store (macOS)
flutter build ios --release
```

### Caso 4: "Quiero un servidor empresarial"
→ **Opción**: Docker + AWS/GCP
- Tiempo: 1 día
- Costo: $20-100/mes
- Acceso: Escalable, profesional

---

## 🐛 Troubleshooting

### Error: "Flutter no encontrado"
```bash
# Descargar Flutter
https://flutter.dev/docs/get-started/install

# Agregar a PATH (Windows)
setx PATH "%PATH%;C:\flutter\bin"

# Verificar
flutter --version
```

### Error: "Firebase no configurado"
```bash
# Firebase Console
https://console.firebase.google.com

# Crear proyecto "notelyApp"
# Descargar archivos de configuración
# Colocar en android/ e ios/
```

### Error: "No tiene capacidad de compilar iOS"
```bash
# Requiere macOS
# Alternativa: Compilar solo web o Android
flutter build web
flutter build apk
```

---

## 📊 Comparativa de Opciones

| Opción | Tiempo | Costo | Escalabilidad | Usuarios |
|--------|--------|-------|---------------|----------|
| Local | Inmediato | $0 | 1 | 1 (local) |
| Web (Netlify) | 5 min | $0 | Media | ∞ |
| Firebase Hosting | 10 min | $0/mes | Media | ∞ |
| APK Standalone | 10 min | $0 | n/a | 1+ manual |
| Play Store | 1 semana | $25 | Alta | Millones |
| App Store | 2 semanas | $99/año | Alta | Millones |
| Docker | 1 día | $20-100 | Alta | ∞ |

---

## 🚀 Comando Rápido para Desplegar Web

```bash
# Setup (una sola vez)
npm install -g netlify-cli

# Desplegar (cada vez que quieras actualizar)
cd c:\pyDev\notely-app
flutter build web
netlify deploy --prod --dir=build/web
```

**Resultado**: Tu app en vivo en internet en 2 minutos ⚡

---

**Próximos Pasos**:
1. ¿Qué opción prefieres usar?
2. ¿Necesitas ayuda con la configuración de Firebase?
3. ¿Quieres que genere un script de despliegue automático?

**Última Actualización**: 31 de Marzo, 2026
