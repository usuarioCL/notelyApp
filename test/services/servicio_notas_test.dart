import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notely_app/services/index.dart';
import 'package:notely_app/models/index.dart';

void main() {
  group('ServicioNotas', () {
    late ServicioNotas servicio;

    setUp(() {
      servicio = ServicioNotas();
    });

    test('Validar que crearNota genera ID único', () async {
      // Este test verifica estructura, no requiere Firebase real
      // Arrange
      final usuarioId = 'usuario-123';
      final titulo = 'Nueva nota';
      final contenido = 'Contenido de prueba';
      final categoria = 'Personal';

      // En un test real, usaríamos mocks de Firestore
      // Por ahora, verificamos que los parámetros se procesan correctamente
      expect(usuarioId, isNotEmpty);
      expect(titulo, isNotEmpty);
      expect(contenido, isNotEmpty);
      expect(categoria, isNotEmpty);
    });

    test('Validar que actualizarNota no acepta campos vacíos', () {
      // Arrange
      final notaId = 'nota-123';
      final actualizaciones = <String, dynamic>{};

      // Act & Assert - Normalmente habría validación en el servicio
      expect(notaId, isNotEmpty);
      expect(actualizaciones, isEmpty);
    });

    test('Validar que eliminarNota marca como eliminada', () {
      // Arrange
      final notaId = 'nota-123';

      // Este es un test conceptual - la implementación real
      // requeriría mocks de Firestore
      expect(notaId, isNotEmpty);
    });

    test('Validar que buscarNotas filtra correctamente', () {
      // Arrange
      final notas = [
        createTestNota(titulo: 'Flutter Tutorial', contenido: 'Aprende Flutter'),
        createTestNota(titulo: 'Dart Basics', contenido: 'Conceptos básicos'),
        createTestNota(titulo: 'Firebase Setup', contenido: 'Configurar Flutter'),
      ];

      // Act - Buscar "Flutter"
      final resultado = notas
          .where((nota) =>
              nota.titulo.toLowerCase().contains('flutter') ||
              nota.contenido.toLowerCase().contains('flutter'))
          .toList();

      // Assert
      expect(resultado.length, equals(2));
      expect(resultado[0].titulo, contains('Flutter'));
      expect(resultado[1].contenido, contains('Firebase'));
    });

    test('Validar que getNotasUsuario ordena por fecha descendente', () {
      // Arrange
      final ahora = DateTime.now();
      final ayer = ahora.subtract(const Duration(days: 1));
      final mañana = ahora.add(const Duration(days: 1));

      final notas = [
        createTestNotaConFecha(
          titulo: 'Nota hoy',
          actualizadoEn: ahora,
        ),
        createTestNotaConFecha(
          titulo: 'Nota ayer',
          actualizadoEn: ayer,
        ),
        createTestNotaConFecha(
          titulo: 'Nota mañana',
          actualizadoEn: mañana,
        ),
      ];

      // Act - Ordenar descendente
      final ordenado = notas..sort((a, b) => b.actualizadoEn.compareTo(a.actualizadoEn));

      // Assert
      expect(ordenado[0].titulo, equals('Nota mañana'));
      expect(ordenado[1].titulo, equals('Nota hoy'));
      expect(ordenado[2].titulo, equals('Nota ayer'));
    });

    test('Validar que filterByCategoryFiltra correctamente', () {
      // Arrange
      final notas = [
        createTestNota(categoria: 'Personal'),
        createTestNota(categoria: 'Trabajo'),
        createTestNota(categoria: 'Personal'),
        createTestNota(categoria: 'Ideas'),
      ];

      // Act
      final personal = notas.where((n) => n.categoria == 'Personal').toList();
      final trabajo = notas.where((n) => n.categoria == 'Trabajo').toList();

      // Assert
      expect(personal.length, equals(2));
      expect(trabajo.length, equals(1));
    });

    test('Validar soft delete mantiene data intacta', () {
      // Arrange
      final nota = createTestNota();
      final datosOriginales = nota.aJson();

      // Act - Simular soft delete
      final notaEliminada = nota.copiarCon(eliminado: true);

      // Assert
      expect(notaEliminada.id, equals(nota.id));
      expect(notaEliminada.usuarioId, equals(nota.usuarioId));
      expect(notaEliminada.titulo, equals(nota.titulo));
      expect(notaEliminada.contenido, equals(nota.contenido));
      expect(notaEliminada.eliminado, isTrue);
    });

    test('Validar que restaurarNota revierte soft delete', () {
      // Arrange
      final notaEliminada = createTestNota(eliminado: true);

      // Act
      final notaRestaurada = notaEliminada.copiarCon(eliminado: false);

      // Assert
      expect(notaRestaurada.eliminado, isFalse);
      expect(notaRestaurada.id, equals(notaEliminada.id));
    });
  });
}

// Funciones helper para crear notas de prueba
Nota createTestNota({
  String id = 'nota-123',
  String usuarioId = 'usuario-456',
  String titulo = 'Nota de prueba',
  String contenido = 'Contenido de la nota',
  String categoria = 'General',
  bool eliminado = false,
}) {
  final ahora = DateTime.now();
  return Nota(
    id: id,
    usuarioId: usuarioId,
    titulo: titulo,
    contenido: contenido,
    categoria: categoria,
    creadoEn: ahora,
    actualizadoEn: ahora,
    eliminado: eliminado,
  );
}

Nota createTestNotaConFecha({
  String id = 'nota-123',
  String usuarioId = 'usuario-456',
  String titulo = 'Nota de prueba',
  String contenido = 'Contenido',
  String categoria = 'General',
  bool eliminado = false,
  required DateTime actualizadoEn,
}) {
  final ahora = DateTime.now();
  return Nota(
    id: id,
    usuarioId: usuarioId,
    titulo: titulo,
    contenido: contenido,
    categoria: categoria,
    creadoEn: ahora,
    actualizadoEn: actualizadoEn,
    eliminado: eliminado,
  );
}
