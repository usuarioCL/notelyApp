# Tests - Carpeta de Pruebas

## Estructura

```
test/
├── models/
│   ├── nota_test.dart          # Tests unitarios del modelo Nota
│   └── usuario_test.dart       # Tests unitarios del modelo Usuario
├── services/
│   ├── servicio_categorias_test.dart      # Tests del servicio de categorías
│   ├── servicio_autenticacion_test.dart   # Tests de autenticación (próximo)
│   └── servicio_notas_test.dart           # Tests de notas (próximo)
└── screens/
    ├── pantalla_inicio_test.dart      # Tests de widget PantallaInicio (próximo)
    └── editor_nota_test.dart          # Tests de widget EditorNota (próximo)
```

## Ejecución

Ejecutar todos los tests:
```bash
flutter test
```

Ver documentación completa en [docs/TESTING.md](../docs/TESTING.md)
