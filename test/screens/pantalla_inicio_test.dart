import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:notely_app/screens/pantalla_inicio.dart';
import 'package:notely_app/models/index.dart';
import 'package:notely_app/services/index.dart';

void main() {
  group('Pantalla Inicio - Widget Tests', () {
    late MockServicioNotas mockServicioNotas;
    late MockServicioAutenticacion mockServicioAuth;

    setUp(() {
      mockServicioNotas = MockServicioNotas();
      mockServicioAuth = MockServicioAutenticacion();
    });

    Widget crearWidgetDeTest() {
      return MultiProvider(
        providers: [
          Provider<ServicioNotas>((ref) => mockServicioNotas),
          Provider<ServicioAutenticacion>((ref) => mockServicioAuth),
          StreamProvider<Usuario?>(
            (ref) => Stream.value(createTestUsuario()),
            initialData: null,
          ),
        ],
        child: MaterialApp(
          home: PantallaInicio(),
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => PantallaInicio(),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('PantallaInicio renderiza AppBar con título', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.text('Mis notas'), findsOneWidget);
    });

    testWidgets('PantallaInicio tiene botón flotante para crear nota', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('PantallaInicio tiene ícono de ajustes', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());

      // Assert
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('PantallaInicio muestra selector de categorías', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Assert - Buscar texto de categorías
      expect(find.text('Todas'), findsOneWidget);
      expect(find.text('General'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget);
    });

    testWidgets('PantalmaInicio mensaje vacío cuando no hay notas', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.note_outlined), findsWidgets);
    });

    testWidgets('PantallaInicio puede tapped en categoría', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Personal'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Personal'), findsOneWidget);
    });
  });
}

// Mocks simples
class MockServicioNotas {
  Stream<List<Nota>> obtenerStreamNotasUsuario({
    required String usuarioId,
    String? categoria,
  }) {
    return Stream.value([]);
  }
}

class MockServicioAutenticacion {
  Stream<Usuario?> obtenerStreamUsuario() {
    return Stream.value(null);
  }
}

// Helper
Usuario createTestUsuario() {
  return Usuario(
    id: 'usuario-123',
    email: 'test@example.com',
    nombreMostrado: 'Usuario Test',
    creadoEn: DateTime.now(),
  );
}

Nota createTestNota({
  String titulo = 'Nota de prueba',
  String contenido = 'Contenido',
  String categoria = 'General',
}) {
  return Nota(
    id: 'nota-123',
    usuarioId: 'usuario-456',
    titulo: titulo,
    contenido: contenido,
    categoria: categoria,
    creadoEn: DateTime.now(),
    actualizadoEn: DateTime.now(),
  );
}
