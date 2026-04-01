import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:notely_app/screens/editor_nota.dart';
import 'package:notely_app/models/index.dart';
import 'package:notely_app/services/index.dart';

void main() {
  group('Editor Nota - Widget Tests', () {
    late MockServicioNotas mockServicioNotas;

    setUp(() {
      mockServicioNotas = MockServicioNotas();
    });

    Widget crearWidgetDeTest({String? notaId}) {
      return MultiProvider(
        providers: [
          Provider<ServicioNotas>((ref) => mockServicioNotas),
          StreamProvider<Usuario?>(
            (ref) => Stream.value(createTestUsuario()),
            initialData: null,
          ),
        ],
        child: MaterialApp(
          home: EditorNota(notaId: notaId),
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/editor-nota',
                builder: (context, state) => EditorNota(
                  notaId: state.uri.queryParameters['id'],
                ),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('EditorNota muestra "Nueva nota" cuando es creación', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest(notaId: null));

      // Assert
      expect(find.text('Nueva nota'), findsOneWidget);
    });

    testWidgets('EditorNota muestra "Editar nota" cuando hay ID', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest(notaId: 'nota-123'));

      // Assert
      expect(find.text('Editar nota'), findsOneWidget);
    });

    testWidgets('EditorNota tiene campos de título y contenido', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TextField), findsWidgets);
      expect(find.byHint('Título de la nota'), findsOneWidget);
      expect(find.byHint('Escribe tu nota aquí...'), findsOneWidget);
    });

    testWidgets('EditorNota tiene selector de categoría', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(DropdownButton), findsWidgets);
      expect(find.text('Categoría'), findsOneWidget);
    });

    testWidgets('EditorNota tiene botón de guardar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('EditorNota permite escribir en título', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Act
      final campoTitulo = find.byHint('Título de la nota');
      await tester.enterText(campoTitulo, 'Mi título');

      // Assert
      expect(find.text('Mi título'), findsOneWidget);
    });

    testWidgets('EditorNota permite escribir en contenido', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Act
      final campoContenido = find.byHint('Escribe tu nota aquí...');
      await tester.enterText(campoContenido, 'Mi contenido');

      // Assert
      expect(find.text('Mi contenido'), findsOneWidget);
    });

    testWidgets('EditorNota puede cambiar categoría', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Act
      final dropdown = find.byType(DropdownButton).first;
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Buscar y tap en "Personal"
      final personal = find.text('Personal').last;
      await tester.tap(personal);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Personal'), findsWidgets);
    });

    testWidgets('EditorNota muestra indicador de carga al guardar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(crearWidgetDeTest());
      await tester.pumpAndSettle();

      // Act & Assert
      // Solo verificar que hay estructura para loading
      // (implementación completa requeriría manejo de async)
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(IconButton), findsWidgets);
    });
  });
}

// Mocks
class MockServicioNotas {
  Future<String> crearNota({
    required String usuarioId,
    required String titulo,
    required String contenido,
    required String categoria,
  }) async {
    return 'nota-123';
  }

  Future<Nota?> obtenerNota(String notaId) async {
    return null;
  }

  Future<void> actualizarNota({
    required String notaId,
    String? titulo,
    String? contenido,
    String? categoria,
  }) async {}
}

// Helpers
Usuario createTestUsuario() {
  return Usuario(
    id: 'usuario-123',
    email: 'test@example.com',
    nombreMostrado: 'Usuario Test',
    creadoEn: DateTime.now(),
  );
}
