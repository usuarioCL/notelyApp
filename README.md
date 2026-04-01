# 📝 Notely - App de Notas tipo Notion

Una aplicación multiplataforma de notas y organización inspirada en Notion, enfocada en sincronización en tiempo real y usabilidad.

## 🎯 Visión General

**Notely** es una herramienta de productividad que permite a los usuarios:
- ✅ Crear y editar notas simples (MVP)
- 🔄 Sincronizar automáticamente entre dispositivos (móvil y escritorio)
- 📱 Acceder desde cualquier dispositivo en tiempo real

## 🛠️ Stack Tecnológico

- **Frontend**: Flutter (multiplataforma: iOS, Android, Web, Desktop)
- **Backend**: Firebase (Firestore + Authentication + Cloud Storage)
- **Versionamiento**: Git con documentación completa

## 📊 Fases del Proyecto

1. **Phase 1 - MVP Básico** (en progreso)
   - Crear, editar y guardar notas en texto plano
   - Autenticación simple
   - Sincronización básica

2. **Phase 2 - Mejoras**
   - Editor enriquecido (negrita, cursiva, etc.)
   - Búsqueda de notas
   - Organización por carpetas/etiquetas

3. **Phase 3 - Avanzado**
   - Sistema de bloques tipo Notion
   - Colaboración en tiempo real
   - Plantillas personalizadas

## 📁 Estructura del Proyecto

```
notely-app/
├── lib/
│   ├── main.dart           # Punto de entrada
│   ├── models/             # Modelos de datos (Note, User, etc.)
│   ├── screens/            # Pantallas (HomeScreen, NoteEditor, etc.)
│   ├── services/           # Servicios (Firebase, Auth, etc.)
│   └── widgets/            # Componentes reutilizables
├── firebase_config/        # Configuración de Firebase
├── docs/                   # Documentación detallada
├── pubspec.yaml            # Dependencias de Flutter
├── PLAN.md                 # Plan detallado del proyecto
├── CHANGELOG.md            # Registro de versiones
└── README.md               # Este archivo
```

## 🚀 Cómo Comenzar

### Requisitos
- Flutter >= 3.0.0
- Dart >= 3.0.0
- Firebase account (gratuita)

### Instalación

```bash
# Clonar el repositorio
git clone <URL_DEL_REPOSITORIO>
cd notely-app

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
```

## 📝 Documentación

- [PLAN.md](PLAN.md) - Plan detallado del proyecto y roadmap
- [CHANGELOG.md](CHANGELOG.md) - Historial de cambios
- [docs/](docs/) - Documentación técnica adicional

## 🤝 Contribución

Este proyecto se desarrolla paso a paso con consultas y aprobaciones previas. Cada cambio incluye:
- ✅ Commits descriptivos
- ✅ Documentación actualizada
- ✅ Decisiones documentadas

## 📅 Estado del Proyecto

**Fase Actual**: MVP Básico - Inicialización ✅
**Última Actualización**: Marzo 31, 2026

---

**Autor**: Desarrollo en colaboración  
**Licencia**: MIT
