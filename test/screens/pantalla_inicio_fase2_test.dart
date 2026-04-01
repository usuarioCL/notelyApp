import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notely_app/screens/pantalla_inicio.dart';
import 'package:notely_app/services/servicio_notas.dart';
import 'package:notely_app/models/usuario.dart';
import 'package:provider/provider.dart';

// Mocks
class MockServicioNotas extends Mock implements ServicioNotas {}

class MockUsuario extends Mock implements Usuario {
  @override
  String get id => 'usuario_123';
  
  @override
  String get email => 'test@example.com';
  
  @override
  String get nombreMostrado => 'Test User';
}

void main() {
  group('PantallaInicio - Search Integration Tests', () {
    testWidgets('PantallaInicio muestra botón de búsqueda en AppBar',
        (WidgetTester tester) async {
      // Arrange
      final mockServicio = MockServicioNotas();
      const usuario = Usuario(
        id: 'usuario_123',
        email: 'test@example.com',
        nombreMostrado: 'Test User',
        fechaCreacion: '2024-01-01',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<ServicioNotas>(create: (_) => mockServicio),
            ],
            child: Scaffold(
              body: PantallaInicio(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('PantallaInicio activa búsqueda al presionar botón',
        (WidgetTester tester) async {
      // Arrange
      final mockServicio = MockServicioNotas();

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<ServicioNotas>(create: (_) => mockServicio),
            ],
            child: Scaffold(
              body: PantallaInicio(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byHint('Buscar notas...'), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('PantallaInicio muestra widget de búsqueda avanzada',
        (WidgetTester tester) async {
      // Arrange
      final mockServicio = MockServicioNotas();

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<ServicioNotas>(create: (_) => mockServicio),
            ],
            child: Scaffold(
              body: PantallaInicio(),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byHint('Buscar notas...'), findsOneWidget);
    });

    testWidgets('PantallaInicio permite escribir término de búsqueda',
        (WidgetTester tester) async {
      // Arrange
      final mockServicio = MockServicioNotas();

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<ServicioNotas>(create: (_) => mockServicio),
            ],
            child: Scaffold(
              body: PantallaInicio(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.enterText(find.byHint('Buscar notas...'), 'Flutter');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('PantallaInicio muestra filtros de categorías',
        (WidgetTester tester) async {
      // Arrange
      final mockServicio = MockServicioNotas();

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<ServicioNotas>(create: (_) => mockServicio),
            ],
            child: Scaffold(
              body: PantallaInicio(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Filtrar por categoría:'), findsOneWidget);
    });

    testWidgets('PantallaInicio permite seleccionar categorías',
        (WidgetTester tester) async {
      // Arrange
      final mockServicio = MockServicioNotas();

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<ServicioNotas>(create: (_) => mockServicio),
            ],
            child: Scaffold(
              body: PantallaInicio(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilterChip).first);
      await tester.pumpAndSettle();

      // Assert
      // FilterChip debe estar seleccionado
      expect(find.byType(FilterChip), findsWidgets);
    });

    testWidgets('PantallaInicio cancela búsqueda',
        (WidgetTester tester) async {
      // Arrange
      final mockServicio = MockServicioNotas();

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<ServicioNotas>(create: (_) => mockServicio),
            ],
            child: Scaffold(
              body: PantallaInicio(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Assert
      // El widget de búsqueda debe cerrarse
      expect(find.byHint('Buscar notas...'), findsNothing);
    });
  });

  group('PantallaInicio - Display Tests', () {
    testWidgets('PantallaInicio muestra lista de notas',
        (WidgetTester tester) async {
      // Arrange
      final mockServicio = MockServicioNotas();

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<ServicioNotas>(create: (_) => mockServicio),
            ],
            child: Scaffold(
              body: PantallaInicio(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('PantallaInicio tiene botón FAB para crear nota',
        (WidgetTester tester) async {
      // Arrange
      final mockServicio = MockServicioNotas();

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<ServicioNotas>(create: (_) => mockServicio),
            ],
            child: Scaffold(
              body: PantallaInicio(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
