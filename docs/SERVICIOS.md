# 📚 Documentación - Servicios Firebase

## Descripción

Los servicios encapsulan la lógica de acceso a datos y comunicación con Firebase. Cada servicio maneja un dominio específico.

## Servicios Disponibles

### 1. ServicioAutenticacion

**Responsabilidades**:
- Registro de nuevos usuarios
- Inicio de sesión
- Cierre de sesión
- Obtener usuario actual
- Stream de cambios de autenticación

**Métodos principales**:

```dart
// Obtener usuario actual (sincrónico)
Usuario? obtenerUsuarioActual();

// Stream del usuario (para escuchar cambios)
Stream<Usuario?> obtenerStreamUsuario();

// Registrarse
Future<Usuario> registrarse({
  required String email,
  required String contraseña,
  required String nombreMostrado,
});

// Iniciar sesión
Future<Usuario> iniciarSesion({
  required String email,
  required String contraseña,
});

// Cerrar sesión
Future<void> cerrarSesion();
```

### 2. ServicioNotas

**Responsabilidades**:
- CRUD de notas (crear, leer, actualizar, eliminar)
- Obtener notas con filtros
- Búsqueda de notas
- Sincronización en tiempo real

**Métodos principales**:

```dart
// Crear nota
Future<String> crearNota({
  required String usuarioId,
  required String titulo,
  required String contenido,
  required String categoria,
});

// Obtener notas del usuario
Future<List<Nota>> obtenerNotasUsuario({
  required String usuarioId,
  String? categoria,
});

// Stream de notas en tiempo real
Stream<List<Nota>> obtenerStreamNotasUsuario({
  required String usuarioId,
  String? categoria,
});

// Obtener una nota por ID
Future<Nota?> obtenerNota(String notaId);

// Actualizar nota
Future<void> actualizarNota({
  required String notaId,
  String? titulo,
  String? contenido,
  String? categoria,
});

// Eliminar nota (soft delete)
Future<void> eliminarNota(String notaId);

// Restaurar nota eliminada
Future<void> restaurarNota(String notaId);

// Buscar notas
Future<List<Nota>> buscarNotas({
  required String usuarioId,
  required String termino,
});
```

### 3. ServicioCategorias

**Responsabilidades**:
- Proporcionar categorías disponibles
- Validar categorías

**Métodos principales**:

```dart
// Obtener todas las categorías
List<String> obtenerCategorias();

// Verificar si categoría es válida
bool esCategoriasValida(String categoria);

// Obtener categoría por defecto
String obtenerCategoriaDefault();
```

**Categorías disponibles (MVP)**:
- General
- Personal
- Trabajo
- Ideas

## Manejo de Errores

Todos los servicios lanzan excepciones con mensajes descriptivos:

```dart
try {
  final nota = await servicioNotas.obtenerNota(notaId);
} catch (e) {
  print('Error: $e');
}
```

## Uso con Provider

Los servicios se instancian una sola vez y se proporcionan a través de Provider:

```dart
// En proveedores_aplicacion.dart
Provider<ServicioAutenticacion>((ref) => ServicioAutenticacion()),
Provider<ServicioNotas>((ref) => ServicioNotas()),
Provider<ServicioCategorias>((ref) => ServicioCategorias()),
```

Luego se accede en widgets:

```dart
final servicioNotas = context.read<ServicioNotas>();
final notas = await servicioNotas.obtenerNotasUsuario(usuarioId: usuarioId);
```

---

**Última Actualización**: Marzo 31, 2026
