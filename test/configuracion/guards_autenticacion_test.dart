import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:notely_app/configuracion/guards_autenticacion.dart';
import 'package:notely_app/services/servicio_autenticacion.dart';
import 'package:notely_app/models/user.dart';

void main() {
  group('GuardAutenticacion - Security Tests', () {
    late MockServicioAutenticacion mockServicio;
    late BuildContext testContext;

    setUp(() {
      mockServicio = MockServicioAutenticacion();
    });

    test('redirectAutenticacion permite acceso a /login sin autenticación', () async {
      // Arrange
      final state = MockGoRouterState(matchedLocation: '/login');
      mockServicio.usuarioActual = null;

      // Act
      final resultado = await GuardAutenticacion.redirectAutenticacion(
        _createTestContext(mockServicio),
        state,
      );

      // Assert - null significa permitir acceso
      expect(resultado, isNull);
    });

    test('redirectAutenticacion redirige a /login si intenta acceder a / sin autenticación',
        () async {
      // Arrange
      final state = MockGoRouterState(matchedLocation: '/');
      mockServicio.usuarioActual = null;

      // Act
      final resultado = await GuardAutenticacion.redirectAutenticacion(
        _createTestContext(mockServicio),
        state,
      );

      // Assert
      expect(resultado, equals('/login'));
    });

    test('redirectAutenticacion redirige a /login si intenta acceder a /ajustes sin autenticación',
        () async {
      // Arrange
      final state = MockGoRouterState(matchedLocation: '/ajustes');
      mockServicio.usuarioActual = null;

      // Act
      final resultado = await GuardAutenticacion.redirectAutenticacion(
        _createTestContext(mockServicio),
        state,
      );

      // Assert
      expect(resultado, equals('/login'));
    });

    test(
        'redirectAutenticacion permite acceso a / si usuario está autenticado',
        () async {
      // Arrange
      final state = MockGoRouterState(matchedLocation: '/');
      mockServicio.usuarioActual = createTestUsuario();

      // Act
      final resultado = await GuardAutenticacion.redirectAutenticacion(
        _createTestContext(mockServicio),
        state,
      );

      // Assert
      expect(resultado, isNull);
    });

    test('redirectAutenticacion permite acceso a /ajustes si usuario está autenticado',
        () async {
      // Arrange
      final state = MockGoRouterState(matchedLocation: '/ajustes');
      mockServicio.usuarioActual = createTestUsuario();

      // Act
      final resultado = await GuardAutenticacion.redirectAutenticacion(
        _createTestContext(mockServicio),
        state,
      );

      // Assert
      expect(resultado, isNull);
    });

    test('redirectAutenticacion redirige a / si está en /login y ya autenticado',
        () async {
      // Arrange
      final state = MockGoRouterState(matchedLocation: '/login');
      mockServicio.usuarioActual = createTestUsuario();

      // Act
      final resultado = await GuardAutenticacion.redirectAutenticacion(
        _createTestContext(mockServicio),
        state,
      );

      // Assert
      expect(resultado, equals('/'));
    });

    test('redirectAutenticacion redirige a / si está en /registro y ya autenticado',
        () async {
      // Arrange
      final state = MockGoRouterState(matchedLocation: '/registro');
      mockServicio.usuarioActual = createTestUsuario();

      // Act
      final resultado = await GuardAutenticacion.redirectAutenticacion(
        _createTestContext(mockServicio),
        state,
      );

      // Assert
      expect(resultado, equals('/'));
    });

    test('redirectAutenticacion permite /recuperar-contraseña sin autenticación',
        () async {
      // Arrange
      final state =
          MockGoRouterState(matchedLocation: '/recuperar-contraseña');
      mockServicio.usuarioActual = null;

      // Act
      final resultado = await GuardAutenticacion.redirectAutenticacion(
        _createTestContext(mockServicio),
        state,
      );

      // Assert
      expect(resultado, isNull);
    });

    test('esUsuarioAutenticado retorna false si no hay usuario', () async {
      // Arrange
      mockServicio.usuarioActual = null;

      // Act
      final resultado = await GuardAutenticacion.esUsuarioAutenticado(
        MockGoRouterState(),
        _createTestContext(mockServicio),
      );

      // Assert
      expect(resultado, isFalse);
    });

    test('esUsuarioAutenticado retorna true si hay usuario', () async {
      // Arrange
      mockServicio.usuarioActual = createTestUsuario();

      // Act
      final resultado = await GuardAutenticacion.esUsuarioAutenticado(
        MockGoRouterState(),
        _createTestContext(mockServicio),
      );

      // Assert
      expect(resultado, isTrue);
    });
  });
}

// Mocks
class MockServicioAutenticacion implements ServicioAutenticacion {
  Usuario? usuarioActual;

  @override
  Future<Usuario> registrarse({
    required String email,
    required String contraseña,
    required String nombreMostrado,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Usuario> iniciarSesion({
    required String email,
    required String contraseña,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> cerrarSesion() async {
    usuarioActual = null;
  }

  @override
  Usuario? obtenerUsuarioActual() {
    return usuarioActual;
  }

  @override
  Stream<Usuario?> obtenerStreamUsuario() {
    return Stream.value(usuarioActual);
  }

  @override
  Future<void> enviarEnlaceRecuperacionContraseña({
    required String email,
  }) async {
    throw UnimplementedError();
  }
}

class MockGoRouterState extends Mock implements GoRouterState {
  MockGoRouterState({this.matchedLocation = '/'});

  @override
  final String matchedLocation;
}

BuildContext _createTestContext(MockServicioAutenticacion mockServicio) {
  final builder = (BuildContext context) {
    return Provider<ServicioAutenticacion>(
      create: (_) => mockServicio,
      child: Container(),
    );
  };

  late BuildContext capturedContext;

  Widget testWidget = Builder(
    builder: (BuildContext context) {
      capturedContext = context;
      return Container();
    },
  );

  testWidget = Provider<ServicioAutenticacion>(
    create: (_) => mockServicio,
    child: testWidget,
  );

  testWidget = MaterialApp(
    home: testWidget,
  );

  // Este es un workaround para tests - en realidad la BuildContext se obtendría
  // del árbol de widgets durante la navegación
  return capturedContext;
}

Usuario createTestUsuario() {
  return Usuario(
    id: 'usuario-123',
    email: 'test@example.com',
    nombreMostrado: 'Usuario Test',
    creadoEn: DateTime.now(),
  );
}
