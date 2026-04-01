import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:notely_app/screens/pantalla_login.dart';
import 'package:notely_app/screens/pantalla_registro.dart';
import 'package:notely_app/services/servicio_autenticacion.dart';
import 'package:notely_app/models/user.dart';

void main() {
  group('Pantalla Login - Widget Tests', () {
    late MockServicioAutenticacion mockServicio;

    setUp(() {
      mockServicio = MockServicioAutenticacion();
    });

    Widget crearWidgetDeTest() {
      return Provider<ServicioAutenticacion>(
        create: (_) => mockServicio,
        child: MaterialApp(
          home: const PantallaLogin(),
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const PantallaLogin(),
              ),
              GoRoute(
                path: '/registro',
                builder: (context, state) => const PantallaRegistro(),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('PantallaLogin muestra campos de email y contraseña',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byHint('correo@ejemplo.com'), findsOneWidget);
      expect(find.byHint('Tu contraseña'), findsOneWidget);
    });

    testWidgets('PantallaLogin tiene botón de iniciar sesión',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.text('Iniciar Sesión'), findsOneWidget);
    });

    testWidgets('PantallaLogin tiene enlace a registro',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.text('Regístrate aquí'), findsOneWidget);
    });

    testWidgets('PantallaLogin tiene opción mostrar/ocultar contraseña',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.byIcon(Icons.visibility), findsWidgets);
    });

    testWidgets('PantallaLogin permite escribir email', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Act
      await tester.enterText(
        find.byHint('correo@ejemplo.com'),
        'usuario@test.com',
      );

      // Assert
      expect(find.text('usuario@test.com'), findsOneWidget);
    });

    testWidgets('PantallaLogin permite escribir contraseña',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Act
      await tester.enterText(
        find.byHint('Tu contraseña'),
        'MiContraseña123',
      );

      // Assert
      expect(find.text('MiContraseña123'), findsOneWidget);
    });

    testWidgets('PantallaLogin muestra enlace de recuperación de contraseña',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);
    });

    testWidgets('PantallaLogin valida email en formulario',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Act - Intentar enviar sin email
      await tester.tap(find.text('Iniciar Sesión'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('El email es requerido'), findsWidgets);
    });

    testWidgets('PantallaLogin valida contraseña en formulario',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Act
      await tester.enterText(
        find.byHint('correo@ejemplo.com'),
        'usuario@test.com',
      );
      await tester.tap(find.text('Iniciar Sesión'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('La contraseña es requerida'), findsWidgets);
    });
  });

  group('Pantalla Registro - Widget Tests', () {
    late MockServicioAutenticacion mockServicio;

    setUp(() {
      mockServicio = MockServicioAutenticacion();
    });

    Widget crearWidgetDeTest() {
      return Provider<ServicioAutenticacion>(
        create: (_) => mockServicio,
        child: MaterialApp(
          home: const PantallaRegistro(),
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/registro',
                builder: (context, state) => const PantallaRegistro(),
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) => const PantallaLogin(),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('PantallaRegistro muestra campos requeridos',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.byHint('Tu nombre'), findsOneWidget);
      expect(find.byHint('correo@ejemplo.com'), findsOneWidget);
      expect(find.byHint('Al menos 6 caracteres'), findsOneWidget);
      expect(find.byHint('Repite tu contraseña'), findsOneWidget);
    });

    testWidgets('PantallaRegistro tiene indicadores de requisitos de contraseña',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Requisitos de contraseña:'), findsOneWidget);
      expect(find.text('Mínimo 6 caracteres'), findsOneWidget);
      expect(find.text('Al menos 1 mayúscula'), findsOneWidget);
      expect(find.text('Al menos 1 número'), findsOneWidget);
    });

    testWidgets('PantallaRegistro actualiza indicadores al escribir contraseña',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Act
      final campoContraseña = find.byHint('Al menos 6 caracteres');
      await tester.enterText(campoContraseña, 'Test123');
      await tester.pumpAndSettle();

      // Assert - Debería mostrar los requisitos cumplidos
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('PantallaRegistro valida campos requeridos',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Act - Intentar registrarse sin datos
      await tester.tap(find.text('Crear Cuenta'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('El nombre es requerido'), findsWidgets);
      expect(find.text('El email es requerido'), findsWidgets);
    });

    testWidgets('PantallaRegistro tiene botón crear cuenta',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.text('Crear Cuenta'), findsOneWidget);
    });

    testWidgets('PantallaRegistro tiene enlace a login',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.text('Inicia sesión'), findsOneWidget);
    });
  });
}

// Mock del ServicioAutenticacion
class MockServicioAutenticacion implements ServicioAutenticacion {
  @override
  Future<Usuario> registrarse({
    required String email,
    required String contraseña,
    required String nombreMostrado,
  }) async {
    return Usuario(
      id: 'usuario-123',
      email: email,
      nombreMostrado: nombreMostrado,
      creadoEn: DateTime.now(),
    );
  }

  @override
  Future<Usuario> iniciarSesion({
    required String email,
    required String contraseña,
  }) async {
    return Usuario(
      id: 'usuario-123',
      email: email,
      nombreMostrado: 'Usuario Test',
      creadoEn: DateTime.now(),
    );
  }

  @override
  Future<void> cerrarSesion() async {}

  @override
  Usuario? obtenerUsuarioActual() {
    return null;
  }

  @override
  Stream<Usuario?> obtenerStreamUsuario() {
    return Stream.value(null);
  }

  @override
  Future<void> enviarEnlaceRecuperacionContraseña({
    required String email,
  }) async {}
}
