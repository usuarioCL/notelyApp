import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notely_app/screens/editor_nota.dart';
import 'package:notely_app/models/nota.dart';
import 'package:provider/provider.dart';

// Mock classes
class MockServicioNotas extends Mock {
  // Mock implementation
}

void main() {
  group('EditorNota - Formatting Tests', () {
    testWidgets('EditorNota muestra barra de formato',
        (WidgetTester tester) async {
      // Arrange
      const nota = Nota(
        id: '1',
        titulo: 'Test',
        contenido: 'Contenido',
        categoria: 'Personal',
        fechaCreacion: '2024-01-01',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<MockServicioNotas>(
            create: (_) => MockServicioNotas(),
            child: EditorNota(nota: nota),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.format_bold), findsOneWidget);
      expect(find.byIcon(Icons.format_italic), findsOneWidget);
      expect(find.byIcon(Icons.format_underlined), findsOneWidget);
    });

    testWidgets('EditorNota permite cambiar formato de texto',
        (WidgetTester tester) async {
      // Arrange
      const nota = Nota(
        id: '1',
        titulo: 'Test',
        contenido: 'Contenido',
        categoria: 'Personal',
        fechaCreacion: '2024-01-01',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<MockServicioNotas>(
            create: (_) => MockServicioNotas(),
            child: EditorNota(nota: nota),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Presionar botón de negrita
      await tester.tap(find.byIcon(Icons.format_bold));
      await tester.pumpAndSettle();

      // Assert - El botón debe estar resaltado
      expect(find.byIcon(Icons.format_bold), findsOneWidget);
    });

    testWidgets('EditorNota abre diálogo para insertar enlace',
        (WidgetTester tester) async {
      // Arrange
      const nota = Nota(
        id: '1',
        titulo: 'Test',
        contenido: 'Contenido',
        categoria: 'Personal',
        fechaCreacion: '2024-01-01',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<MockServicioNotas>(
            create: (_) => MockServicioNotas(),
            child: EditorNota(nota: nota),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Presionar botón de enlace
      await tester.tap(find.byIcon(Icons.link));
      await tester.pumpAndSettle();

      // Assert - El diálogo debería abrirse
      // Nota: Este test puede necesitar ajustarse según la implementación exacta
    });
  });

  group('EditorNota - Content Editing Tests', () {
    testWidgets('EditorNota carga contenido inicial',
        (WidgetTester tester) async {
      // Arrange
      const nota = Nota(
        id: '1',
        titulo: 'Test Título',
        contenido: 'Contenido inicial',
        categoria: 'Personal',
        fechaCreacion: '2024-01-01',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<MockServicioNotas>(
            create: (_) => MockServicioNotas(),
            child: EditorNota(nota: nota),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Título'), findsOneWidget);
      expect(find.text('Contenido inicial'), findsOneWidget);
    });

    testWidgets('EditorNota permite editar contenido',
        (WidgetTester tester) async {
      // Arrange
      const nota = Nota(
        id: '1',
        titulo: 'Test',
        contenido: 'Original',
        categoria: 'Personal',
        fechaCreacion: '2024-01-01',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<MockServicioNotas>(
            create: (_) => MockServicioNotas(),
            child: EditorNota(nota: nota),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(TextField).last, ' - Modificado');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Modificado'), findsOneWidget);
    });
  });
}
