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

## Tests Próximos (Phase 1.8 continuación)

### ServicioAutenticacion
- [ ] Registrarse con email válido
- [ ] Registrarse con email duplicado
- [ ] Iniciar sesión con credenciales correctas
- [ ] Iniciar sesión con credenciales incorrectas
- [ ] Cerrar sesión
- [ ] Obtener usuario actual
- [ ] Stream de cambios de autenticación

### ServicioNotas
- [ ] Crear nota
- [ ] Obtener notas por usuario
- [ ] Obtener nota por ID
- [ ] Actualizar nota
- [ ] Eliminar nota (soft delete)
- [ ] Restaurar nota eliminada
- [ ] Buscar notas
- [ ] Filtrar por categoría

### Pantallas (Widgets)
- [ ] PantallaInicio: renderizar lista vacía
- [ ] PantallaInicio: renderizar lista de notas
- [ ] PantallaInicio: filtrado por categoría
- [ ] EditorNota: crear nota
- [ ] EditorNota: editar nota existente
- [ ] PantallaAjustes: mostrar datos del usuario

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
