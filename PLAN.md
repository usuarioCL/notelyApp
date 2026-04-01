# 📋 Plan Detallado - Notely MVP

## 🎯 Objetivo General

Construir una aplicación multiplataforma de notas con sincronización en tiempo real, usando Flutter y Firebase, siguiendo un enfoque modular y documentado.

## 📊 Decisiones Aprobadas

| Aspecto | Decisión |
|--------|----------|
| Stack | Flutter (multiplataforma) |
| Backend | Firebase (Firestore + Auth) |
| MVP Features | Notas de texto simple (crear, editar, guardar) |
| Rastreo | Git + commits descriptivos + documentación |
| Idioma | Español (commits, documentación, comentarios) |
| Gestor de Estado | **Provider** (moderno y simple) |
| Navegación | **Go Router** (para Flutter 3.0+) |
| Documentación | Completa en cada etapa |
| Proceso | Paso a paso, consultando antes de cada decisión |

## 🧩 Fases de Desarrollo

### Fase 1: MVP Básico (Actual)

```
├─ 1.1: Definir MVP ✅
├─ 1.2: Inicializar estructura del proyecto ✅ (AQUÍ)
├─ 1.3: Diseñar modelo de datos
├─ 1.4: Frontend - Pantalla de listado
├─ 1.5: Frontend - Editor de notas
├─ 1.6: Backend - Integración Firebase
├─ 1.7: Sincronización básica
└─ 1.8: Testing MVP
```

### Fase 2: Mejoras (Próxima)
- Editor enriquecido (bold, italic, underline)
- Búsqueda de notas
- Organización (carpetas/categorías)

### Fase 3: Avanzado (Futura)
- Sistema de bloques
- Colaboración en tiempo real
- Plantillas

## 🏗️ Arquitectura

### Capas

1. **Presentation Layer**
   - Screens (HomeScreen, NoteEditor)
   - Widgets reutilizables
   - State management (Provider/Riverpod)

2. **Domain Layer**
   - Modelos de datos (Note, User)
   - Casos de uso

3. **Data Layer**
   - Firebase Service
   - Repositorios
   - Cache local

### Flujo de Datos

```
Firebase ← → Firestore Service ← → Repository ← → UI
```

## 🗄️ Modelo de Datos (MVP)

### Note
```dart
class Note {
  String id;              // ID único
  String userId;          // Usuario propietario
  String title;           // Título
  String content;         // Contenido (texto plano)
  String category;        // Categoría (Personal, Trabajo, Ideas, etc.)
  DateTime createdAt;     // Fecha creación
  DateTime updatedAt;     // Última actualización
  bool isDeleted;         // Soft delete
}
```

**Categorías disponibles (MVP)**:
- "General" (default)
- "Personal"
- "Trabajo"
- "Ideas"

### User
```dart
class User {
  String id;              // ID único
  String email;           // Email
  String displayName;     // Nombre
  DateTime createdAt;     // Fecha creación
}
```

## 🎯 Milestones Seguimiento

- [ ] Proyecto inicializado ← AQUÍ
- [ ] Modelo de datos definido
- [ ] Pantalla de listado funcional
- [ ] Editor de notas funcional
- [ ] Firebase integrado
- [ ] MVP completado

## 📝 Convenciones

### Git Commits
```
feat: Nueva característica
fix: Corrección de bug
docs: Cambios en documentación
refactor: Refactorización de código
chore: Tareas de mantenimiento
test: Adición/modificación de tests
```

### Estructura de Ramas (para equipos)
```
main         → Producción
develop      → Desarrollo
feature/*    → Nuevas características
bugfix/*     → Correcciones
```

### Documentación
- Cambios importantes se documentan en CHANGELOG.md
- Decisiones técnicas en docs/
- Código incluye comentarios claros

## 🔒 Configuración Firebase (Pendiente)

- [ ] Crear proyecto en Firebase Console
- [ ] Configurar Firestore Database
- [ ] Configurar Authentication
- [ ] Configurar reglas de seguridad
- [ ] Generar configuración para Flutter

## ✅ Próximos Pasos

1. **Diseñar el modelo de datos** - Definir estructura de Note
2. **Consultar sobre dependencias** - Qué paquetes usar
3. **Crear estructura básica Flutter** - main.dart, pubspec.yaml
4. **Empezar con UI básica** - Pantalla de listado

---

**Última Actualización**: Marzo 31, 2026  
**Estado**: En Inicialización
