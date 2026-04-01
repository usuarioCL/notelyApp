# 📚 Documentación - Modelo de Datos

## Estructura de Datos - MVP

### Note Model

Campo | Tipo | Descripción
------|------|-------------
`id` | String | ID único generado por Firestore
`userId` | String | ID del usuario propietario
`title` | String | Título de la nota
`content` | String | Contenido en texto plano
`category` | String | Categoría para organizar (ej: "Personal", "Trabajo", "Ideas")
`createdAt` | DateTime | Timestamp de creación
`updatedAt` | DateTime | Timestamp de última actualización  
`isDeleted` | bool | Flag para soft delete (recuperación posterior)

**Categorías por defecto**:
- "General" (default)
- "Personal"
- "Trabajo"
- "Ideas"
- (Los usuarios pueden agregar más en futuras versiones)

### User Model

Campo | Tipo | Descripción
------|------|-------------
`id` | String | Firebase Auth UID
`email` | String | Correo electrónico
`displayName` | String | Nombre mostrado del usuario
`createdAt` | DateTime | Timestamp de creación de cuenta

## Estructura Firestore (MVP)

```
firestore
├── users/
│   └── {userId}
│       ├── id
│       ├── email
│       ├── displayName
│       └── createdAt
└── notes/
    └── {noteId}
        ├── id
        ├── userId
        ├── title
        ├── content
        ├── category
        ├── createdAt
        ├── updatedAt
        └── isDeleted
```

## Métodos del Modelo

### Note

- `toJson()` - Serializa a JSON para Firestore
- `fromJson()` - Deserializa desde JSON de Firestore
- `copyWith()` - Crea copia con cambios específicos (Pattern común en Flutter)

### User

- `toJson()` - Serializa a JSON
- `fromJson()` - Deserializa desde JSON
- `copyWith()` - Crea copia modificada

## Validaciones Futuras (Phase 2+)

- [ ] Validar longitud mínima de título
- [ ] Validar que categoría sea válida
- [ ] Validar que content no esté vacío
- [ ] Sanitizar entrada de usuario

---

**Última Actualización**: Marzo 31, 2026
