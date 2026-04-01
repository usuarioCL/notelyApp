# 📝 Changelog - Notely

Todos los cambios notables del proyecto serán documentados en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [Unreleased]

### Agregado
- Inicialización del proyecto con estructura base
- Documentación: README.md, PLAN.md, CHANGELOG.md
- Estructura de carpetas (lib/, docs/, firebase_config/)
- **Modelos de datos** (Fase 1.3):
  - Modelo `Nota` con campos: id, usuarioId, titulo, contenido, categoria, creadoEn, actualizadoEn, eliminado
  - Modelo `Usuario` con campos: id, email, nombreMostrado, creadoEn
  - Métodos aJSON/desdeJSON para serialización Firebase
  - Patrón copiarCon para modificaciones inmutables
  - Documentación de modelos en `docs/MODELO_DATOS.md`
  - Categorías predefinidas: General, Personal, Trabajo, Ideas

- **Frontend básico** (Fase 1.4 - Opción B):
  - Configuración de Provider (gestor de estado)
  - Configuración de GoRouter (navegación)
  - main.dart con inicialización de proveedores y rutas
  - PantallaInicio: listado de notas con filtro por categoría
  - EditorNota: editor con selector de categoría
  - PantallaAjustes: pantalla de configuración
  - Sistema de rutas con GoRouter configurado

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
