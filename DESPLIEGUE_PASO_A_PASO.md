# 🌐 Guía Step-by-Step: Desplegar Notely en Web

## ⚡ Forma Más Rápida: Netlify (5 minutos)

### Paso 1: Instalar Netlify CLI

```powershell
# En PowerShell (como admin)
npm install -g netlify-cli

# Verificar instalación
netlify --version
```

### Paso 2: Login en Netlify

```powershell
netlify login

# Se abrirá navegador para autenticarse con GitHub
# Autorizar acceso
```

### Paso 3: Compilar App para Web

```powershell
cd c:\pyDev\notely-app

# Compilar (esta es la parte que requiere Flutter instalado)
flutter build web

# Resultado: build/web/ (lista para subir)
```

**✅ Si no tienes Flutter**: [Descargarlo aquí](https://flutter.dev/docs/get-started/install/windows)

### Paso 4: Desplegar

```powershell
cd c:\pyDev\notely-app

# Desplegar a producción
netlify deploy --prod --dir=build/web

# Resultado:
# ┌──────────────────────────┐
# │ Deploy success!          │
# │ URL: https://....netlify.app
# └──────────────────────────┘
```

**¡Listo! Tu app está en vivo** 🎉

---

## 🔥 Alternativa: Firebase Hosting (Gratis)

### Instalación Firebase CLI

```powershell
# Instalar
npm install -g firebase-tools

# Verificar
firebase --version

# Login
firebase login
```

### Desplegar

```powershell
cd c:\pyDev\notely-app

# Compilar
flutter build web

# Inicializar (primera vez)
firebase init hosting
# → Proyecto: notely (o seleccionar existente)
# → Public directory: build/web
# → Single-page app: YES
# → Overwrites? NO

# Desplegar
firebase deploy

# Resultado:
# Hosting URL: https://notely-XXXXX.web.app/
```

---

## 📱 Opción B: Generar APK para Android

### Requisitos
- Flutter SDK instalado
- Java Development Kit (JDK)
- Android SDK

### Compilar APK Release

```powershell
cd c:\pyDev\notely-app

# Generar APK de liberar (optimizado para distribución)
flutter build apk --release

# Resultado:
# build/app/outputs/flutter-app-release.apk

# Instalar en dispositivo conectado via USB
flutter install

# O instalar manualmente
adb install build/app/outputs/flutter-app-release.apk
```

**File Size**: ~50-80 MB

---

## 🍎 Opción C: Para iOS (Requiere macOS)

```bash
# Solo en macOS
flutter build ios --release

# Resultado: build/ios/iphoneos/Runner.app
# Abrir en Xcode para firma y subida a App Store
open ios/Runner.xcworkspace
```

---

## 🐳 Opción D: Docker (Profesional)

### Crear Dockerfile

**Archivo**: `Dockerfile` (crear en raíz del proyecto)

```dockerfile
# Build stage
FROM ubuntu:22.04 as builder

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    curl git unzip openjdk-11-jdk-headless

# Instalar Flutter
RUN cd /opt && \
    git clone https://github.com/flutter/flutter.git && \
    /opt/flutter/bin/flutter config --android-sdk /android-sdk && \
    /opt/flutter/bin/flutter --version

ENV PATH="/opt/flutter/bin:${PATH}"

# Clonar app
WORKDIR /app
COPY . .

# Build web
RUN flutter pub get && \
    flutter build web --release

# Production stage
FROM nginx:latest
COPY --from=builder /app/build/web /usr/share/nginx/html

# Configuración NGINX
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen 80;
    location / {
        root /usr/share/nginx/html;
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Construir y Ejecutar

```bash
# Construir imagen
docker build -t notely-app:latest .

# Ejecutar
docker run -p 8080:80 notely-app:latest

# Acceder: http://localhost:8080
```

---

## ☁️ Desplegar en Servidor Profesional

### AWS (Amazon Web Services)

```bash
# 1. Crear instancia EC2 Ubuntu
# 2. Conectarse via SSH
ssh -i clave.pem ubuntu@tu-instancia-ec2

# 3. Instalar Docker
sudo apt update
sudo apt install docker.io
sudo usermod -aG docker ubuntu

# 4. Clonar repo
git clone https://github.com/usuarioCL/notelyApp.git
cd notelyApp

# 5. Construir y ejecutar
docker build -t notely-app .
docker run -d -p 80:80 notely-app:latest

# 6. Configurar dominio DNS
# Apuntar tu dominio a IP de EC2
```

**Costo**: ~$5-10/mes

### Google Cloud Run (Más fácil)

```bash
# 1. Instalar Google Cloud CLI
# https://cloud.google.com/sdk/docs/install

# 2. Login
gcloud auth login

# 3. Crear proyecto
gcloud projects create notely-app

# 4. Desplegar en Cloud Run
gcloud run deploy notely-app \
  --source . \
  --platform managed \
  --region us-central1

# Resultado: URL pública lista
```

**Costo**: Gratis (500 invocaciones/mes), luego ~$0.24 por 1M invocaciones

---

## 📊 Comparativa Rápida

| Plataforma | Tiempo | Costo | Comando |
|-----------|--------|-------|---------|
| **Netlify** | 5 min | Gratis | `netlify deploy --prod --dir=build/web` |
| **Firebase** | 10 min | Gratis | `firebase deploy` |
| **GitHub Pages** | 5 min | Gratis | Push a rama `gh-pages` |
| **Vercel** | 3 min | Gratis | `vercel --prod` |
| **AWS** | 30 min | $5/mes | EC2 + Docker |
| **Google Cloud** | 15 min | Gratis tier | `gcloud run deploy` |

---

## ✅ Checklist Final

Antes de desplegar:

- [ ] Todas las dependencias instaladas (`flutter pub get`)
- [ ] Tests pasando (`flutter test`)
- [ ] Sin errores de compilación
- [ ] Firebase configurado (si usar backend)
- [ ] Variables de entorno configuradas
- [ ] README.md actualizado

---

## 🆘 Troubleshooting

### "flutter command not found"
```powershell
# Descargar Flutter
# https://flutter.dev/docs/get-started/install/windows

# Agregar a PATH permanentemente
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\flutter\bin", "User")

# Restart PowerShell y verifica
flutter --version
```

### "No se puede compilar (error en pubspec)"
```powershell
flutter clean
flutter pub get
flutter pub upgrade
```

### "Build web fallido"
```powershell
flutter clean
flutter build web --release --verbose
```

### "No tengo Node.js"
```powershell
# Descargar Node.js
# https://nodejs.org/

# Instalar
# Reiniciar PowerShell

# Verificar
node --version
npm --version
```

---

## 🎯 Recomendación Final

**Para ver la app HOY mismo**:

Option 1️⃣ - Si tienes Flutter instalado:
```bash
flutter build web
netlify deploy --prod --dir=build/web
```
**Tiempo**: 5 minutos ⚡

Option 2️⃣ - Si NO tienes Flutter:
1. Descargar Flutter: https://flutter.dev/docs/get-started/install
2. Agregar a PATH
3. Ejecutar comando de arriba
**Tiempo**: 30 minutos total

---

**¿Necesitas ayuda con algún paso específico? 🤔**

Puedo generar scripts automatizados para cualquiera de estas opciones.

**Última Actualización**: 31 de Marzo, 2026
