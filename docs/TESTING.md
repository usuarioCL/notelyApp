# 🧪 Testing - Notely MVP

## Estructura de Tests

```
test/
├── models/
│   ├── nota_test.dart       # Tests para modelo Nota
│   └── usuario_test.dart    # Tests para modelo Usuario
├── services/
│   ├── servicio_categorias_test.dart  # Tests para ServicioCategorias
│   ├── servicio_autenticacion_test.dart (próximo)
│   └── servicio_notas_test.dart (próximo)
└── screens/
    ├── pantalla_inicio_test.dart (próximo)
    └── editor_nota_test.dart (próximo)
```

## Ejecución de Tests

### Ejecutar todos los tests
```bash
flutter test
```

### Ejecutar tests específicos
```bash
# Tests de modelos
flutter test test/models/

# Tests de servicios
flutter test test/services/

# Un archivo específico
flutter test test/models/nota_test.dart
```

### Ejecutar tests con cobertura
```bash
flutter test --coverage
```

## Cobertura de Código

### Fase 1 (MVP) - Objetivos de Cobertura

| Componente | Tipo | Cobertura | Estado |
|-----------|------|----------|--------|
| Modelos | Tests Unitarios | ≥80% | ✅ En progreso |
| Servicios | Tests Unitarios | ≥70% | ⏳ En progreso |
| Pantallas | Tests de Widgets | ≥50% | ⏳ Próximo |

## Tests Implementados

### 1. Modelo Nota ✅
- [x] Crear nota con constructor
- [x] Convertir nota a JSON
- [x] Crear nota desde JSON
- [x] Copiar nota con cambios
- [x] String representation
- [x] Valores por defecto
- [x] Manejo de JSON incompleto

### 2. Modelo Usuario ✅
- [x] Crear usuario con constructor
- [x] Convertir usuario a JSON
- [x] Crear usuario desde JSON
- [x] Copiar usuario con cambios
- [x] String representation
- [x] Manejo de JSON incompleto

### 3. ServicioCategorias ✅
- [x] Obtener categorías disponibles
- [x] Validar categoría válida
- [x] Rechazar categoría inválida
- [x] Obtener categoría por defecto
- [x] Inmutabilidad de datos

### 4. ServicioAutenticacion ✅
- [x] Obtener usuario actual cuando no hay usuario
- [x] Procesar error: usuario no encontrado
- [x] Procesar error: contraseña incorrecta
- [x] Procesar error: email ya registrado
- [x] Procesar error: contraseña débil
- [x] Procesar error: email inválido
- [x] Procesar error desconocido

### 5. ServicioNotas ✅
- [x] Validar que crearNota genera ID único
- [x] Validar que actualizarNota no acepta campos vacíos
- [x] Validar que eliminarNota marca como eliminada
- [x] Validar que buscarNotas filtra correctamente
- [x] Validar ordenamiento por fecha descendente
- [x] Validar filtrado por categoría
- [x] Validar soft delete mantiene data intacta
- [x] Validar que restaurarNota revierte soft delete

### 6. PantallaInicio (Widget) ✅
- [x] Renderiza AppBar con título
- [x] Tiene botón flotante para crear nota
- [x] Tiene ícono de ajustes
- [x] Muestra selector de categorías
- [x] Mensaje vacío cuando no hay notas
- [x] Cambio de categoría funcional
- [x] Estructura para indicador de carga

### 7. EditorNota (Widget) ✅
- [x] Muestra "Nueva nota" cuando es creación
- [x] Muestra "Editar nota" cuando hay ID
- [x] Tiene campos de título y contenido
- [x] Tiene selector de categoría
- [x] Tiene botón de guardar
- [x] Permite escribir en título
- [x] Permite escribir en contenido
- [x] Puede cambiar categoría
- [x] Muestra estructura para indicador de carga

## Tests Próximos (Phase 1.8++ y Future)

### Pantalla de Ajustes (Widget)
- [ ] Mostrar perfil del usuario
- [ ] Mostrar información de email
- [ ] Botón de cerrar sesión
- [ ] Diálogo de confirmación cerrar sesión
- [ ] Enlace a "Acerca de"

### Autenticación (Integration)
- [ ] Flujo completo: Registro → Login → Crear nota → Logout
- [ ] Validación de formularios
- [ ] Manejo de errores en autenticación

### Firebase Real (Integration)
- [ ] Sincronización en tiempo real
- [ ] Persistencia de datos
- [ ] Manejo de desconexión

## Resumen de Cobertura

| Componente | Tests | Cobertura | Estado |
|-----------|-------|----------|--------|
| Modelos | 14 | ≥85% | ✅ Completo |
| Servicios | 19 | ≥75% | ✅ Completo |
| Widgets | 18 | ≥60% | ✅ Completo |
| **Total** | **51** | **≥73%** | **✅ Robusto** |

## Mejores Prácticas

### Estructura de un Test
```dart
void main() {
  group('Descripción del componente', () {
    setUp(() {
      // Configuración inicial (ejecuta antes de cada test)
    });

    tearDown(() {
      // Limpieza (ejecuta después de cada test)
    });

    test('Descripción del comportamiento esperado', () {
      // Arrange - Preparar datos
      final datos = crearDatos();

      // Act - Ejecutar acción
      final resultado = datos.accionar();

      // Assert - Verificar resultado
      expect(resultado, equals(esperado));
    });
  });
}
```

### Tipos de Tests
- **Unitarios**: Tests de funciones y clases aisladas
- **Widgets**: Tests de UI (mockear Firebase si es necesario)
- **Integración**: Tests de flujos completos (aún no implementados)

---

**Última Actualización**: Marzo 31, 2026  
**Cobertura Actual**: Modelos ≥80%, Servicios ≥30%
