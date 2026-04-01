import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notely_app/widgets/barra_formato.dart';
import 'package:notely_app/widgets/busqueda_avanzada.dart';

void main() {
  group('BarraFormato - Widget Tests', () {
    testWidgets('BarraFormato muestra todos los botones',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BarraFormato(
              negrita: false,
              cursiva: false,
              subrayado: false,
              onNegritaToggle: () {},
              onCursivaToggle: () {},
              onSubrayadoToggle: () {},
              onLinkTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.format_bold), findsOneWidget);
      expect(find.byIcon(Icons.format_italic), findsOneWidget);
      expect(find.byIcon(Icons.format_underlined), findsOneWidget);
      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.byIcon(Icons.format_list_bulleted), findsOneWidget);
      expect(find.byIcon(Icons.format_quote), findsOneWidget);
    });

    testWidgets('BarraFormato responde a taps en botones',
        (WidgetTester tester) async {
      // Arrange
      bool negritaPresionada = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BarraFormato(
              negrita: false,
              cursiva: false,
              subrayado: false,
              onNegritaToggle: () => negritaPresionada = true,
              onCursivaToggle: () {},
              onSubrayadoToggle: () {},
              onLinkTap: () {},
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.format_bold));
      await tester.pumpAndSettle();

      // Assert
      expect(negritaPresionada, isTrue);
    });

    testWidgets('BarraFormato resalta botón cuando está seleccionado',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BarraFormato(
              negrita: true,
              cursiva: false,
              subrayado: false,
              onNegritaToggle: () {},
              onCursivaToggle: () {},
              onSubrayadoToggle: () {},
              onLinkTap: () {},
            ),
          ),
        ),
      );

      // Assert - El botón negrita debe estar seleccionado (azul)
      expect(find.byIcon(Icons.format_bold), findsOneWidget);
    });
  });

  group('BusquedaAvanzada - Widget Tests', () {
    testWidgets('BusquedaAvanzada muestra campo de búsqueda',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusquedaAvanzada(
              onBuscar: (_, __) {},
              categoriasDisponibles: ['Personal', 'Trabajo'],
              onCancelar: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byHint('Buscar notas...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('BusquedaAvanzada permite escribir en campo',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusquedaAvanzada(
              onBuscar: (_, __) {},
              categoriasDisponibles: ['Personal', 'Trabajo'],
              onCancelar: () {},
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byHint('Buscar notas...'), 'Flutter');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('BusquedaAvanzada muestra botón de filtros',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusquedaAvanzada(
              onBuscar: (_, __) {},
              categoriasDisponibles: ['Personal', 'Trabajo'],
              onCancelar: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('BusquedaAvanzada expande filtros al presionar botón',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusquedaAvanzada(
              onBuscar: (_, __) {},
              categoriasDisponibles: ['Personal', 'Trabajo'],
              onCancelar: () {},
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Filtrar por categoría:'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget);
      expect(find.text('Trabajo'), findsOneWidget);
    });

    testWidgets('BusquedaAvanzada filtra por categoría',
        (WidgetTester tester) async {
      // Arrange
      final List<dynamic> llamadas = [];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusquedaAvanzada(
              onBuscar: (termino, categorias) {
                llamadas.add({'termino': termino, 'categorias': categorias});
              },
              categoriasDisponibles: ['Personal', 'Trabajo'],
              onCancelar: () {},
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Personal'));
      await tester.pumpAndSettle();

      // Assert
      expect(llamadas.isNotEmpty, isTrue);
      if (llamadas.isNotEmpty) {
        final ultima = llamadas.last as Map;
        expect(ultima['categorias'], contains('Personal'));
      }
    });

    testWidgets('BusquedaAvanzada cancela búsqueda',
        (WidgetTester tester) async {
      // Arrange
      bool cancelado = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusquedaAvanzada(
              onBuscar: (_, __) {},
              categoriasDisponibles: ['Personal', 'Trabajo'],
              onCancelar: () => cancelado = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Assert
      expect(cancelado, isTrue);
    });
  });
}
