# 📝 Changelog - Notely

Todos los cambios notables del proyecto serán documentados en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [Unreleased]

### Added
- Inicialización del proyecto con estructura base
- Documentación: README.md, PLAN.md, CHANGELOG.md
- Estructura de carpetas (lib/, docs/, firebase_config/)
- **Modelos de datos** (Phase 1.3):
  - `Note` model con campos: id, userId, title, content, category, createdAt, updatedAt, isDeleted
  - `User` model con campos: id, email, displayName, createdAt
  - Métodos toJson/fromJson para serialización Firebase
  - Patrón copyWith para modificaciones inmutables
- Documentación de modelos en `docs/DATA_MODEL.md`
- Categorías predefinidas: General, Personal, Trabajo, Ideas

### Changed
- N/A

### Removed
- N/A

---

## Notas de Versiones Futuras

### v0.1.0 - MVP Básico
- [ ] Autenticación básica
- [ ] Crear notas
- [ ] Editar notas
- [ ] Listar notas
- [ ] Eliminar notas
- [ ] Sincronización Firebase

### v0.2.0 - Mejoras UI/UX
- [ ] Editor enriquecido
- [ ] Búsqueda de notas
- [ ] Categorías/Carpetas

### v0.3.0 - Sistema de Bloques
- [ ] Arquitectura de bloques
- [ ] Diferentes tipos de bloques
- [ ] Colaboración en tiempo real

---

**Formato de Changelog**:
- "Added" para nuevas características
- "Changed" para cambios en funcionalidad existente
- "Fixed" para correcciones de bugs
- "Removed" para características removidas
