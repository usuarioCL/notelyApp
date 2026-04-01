import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:notely_app/screens/pantalla_ajustes.dart';
import 'package:notely_app/services/servicio_autenticacion.dart';
import 'package:notely_app/models/user.dart';

void main() {
  group('PantallaAjustes - Widget Tests with Security', () {
    late MockServicioAutenticacion mockServicio;

    setUp(() {
      mockServicio = MockServicioAutenticacion();
    });

    Widget crearWidgetDeTest({Usuario? usuario}) {
      return MultiProvider(
        providers: [
          Provider<ServicioAutenticacion>((ref) => mockServicio),
          StreamProvider<Usuario?>(
            (ref) => Stream.value(usuario),
            initialData: usuario,
          ),
        ],
        child: MaterialApp(
          home: const PantallaAjustes(),
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/ajustes',
                builder: (context, state) => const PantallaAjustes(),
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Login')),
                ),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('PantallaAjustes muestra usuario cuando está autenticado',
        (WidgetTester tester) async {
      // Arrange
      final usuario = createTestUsuario();
      await tester.pumpWidget(crearWidgetDeTest(usuario: usuario));

      // Assert
      expect(find.text('Mi perfil'), findsOneWidget);
      expect(find.text(usuario.nombreMostrado), findsOneWidget);
      expect(find.text(usuario.email), findsOneWidget);
    });

    testWidgets('PantallaAjustes muestra mensaje cuando no hay usuario',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest(usuario: null));

      // Assert
      expect(find.text('No hay usuario autenticado'), findsOneWidget);
      expect(find.text('Ir a iniciar sesión'), findsOneWidget);
    });

    testWidgets('PantallaAjustes tiene botón cerrar sesión',
        (WidgetTester tester) async {
      // Arrange
      final usuario = createTestUsuario();
      await tester.pumpWidget(crearWidgetDeTest(usuario: usuario));

      // Assert
      expect(find.text('Cerrar sesión'), findsOneWidget);
    });

    testWidgets('PantallaAjustes muestra diálogo de confirmación al cerrar sesión',
        (WidgetTester tester) async {
      // Arrange
      final usuario = createTestUsuario();
      await tester.pumpWidget(crearWidgetDeTest(usuario: usuario));

      // Act
      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();

      // Assert - Debe mostrar el diálogo
      expect(find.text('¿Estás seguro'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('PantallaAjustes cancela logout correctamente',
        (WidgetTester tester) async {
      // Arrange
      final usuario = createTestUsuario();
      await tester.pumpWidget(crearWidgetDeTest(usuario: usuario));

      // Act
      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // Assert - Debe seguir en la pantalla
      expect(find.text('Mi perfil'), findsOneWidget);
    });

    testWidgets('PantallaAjustes tiene botón acerca de', (WidgetTester tester) async {
      // Arrange
      final usuario = createTestUsuario();
      await tester.pumpWidget(crearWidgetDeTest(usuario: usuario));

      // Assert
      expect(find.text('Acerca de'), findsOneWidget);
    });

    testWidgets('PantallaAjustes muestra diálogo acerca de', (WidgetTester tester) async {
      // Arrange
      final usuario = createTestUsuario();
      await tester.pumpWidget(crearWidgetDeTest(usuario: usuario));

      // Act
      await tester.tap(find.text('Acerca de'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Acerca de Notely'), findsOneWidget);
      expect(find.text('Notely v0.1.0'), findsOneWidget);
    });

    testWidgets('PantallaAjustes muestra información del usuario correctamente',
        (WidgetTester tester) async {
      // Arrange
      final usuario = Usuario(
        id: 'user-123',
        email: 'test@example.com',
        nombreMostrado: 'Juan Pérez',
        creadoEn: DateTime(2024, 1, 15),
      );
      await tester.pumpWidget(crearWidgetDeTest(usuario: usuario));

      // Assert
      expect(find.text('Juan Pérez'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('15/1/2024'), findsOneWidget);
    });

    testWidgets('PantallaAjustes muestra opciones próximas',
        (WidgetTester tester) async {
      // Arrange
      final usuario = createTestUsuario();
      await tester.pumpWidget(crearWidgetDeTest(usuario: usuario));

      // Assert
      expect(find.text('Apariencia'), findsOneWidget);
      expect(find.text('Notificaciones'), findsOneWidget);
    });
  });
}

class MockServicioAutenticacion implements ServicioAutenticacion {
  bool llamadoCerrarSesion = false;

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
    llamadoCerrarSesion = true;
  }

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
  }) async {
    throw UnimplementedError();
  }
}

Usuario createTestUsuario() {
  return Usuario(
    id: 'usuario-123',
    email: 'test@example.com',
    nombreMostrado: 'Usuario Test',
    creadoEn: DateTime.now(),
  );
}
