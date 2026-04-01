import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notely_app/models/index.dart';

void main() {
  group('Modelo Nota', () {
    // Datos de prueba
    final ahora = DateTime.now();
    final notaJson = {
      'id': 'nota-123',
      'usuarioId': 'usuario-456',
      'titulo': 'Mi primera nota',
      'contenido': 'Este es el contenido de la nota',
      'categoria': 'Personal',
      'creadoEn': Timestamp.fromDate(ahora),
      'actualizadoEn': Timestamp.fromDate(ahora),
      'eliminado': false,
    };

    test('Crear nota con constructor', () {
      final nota = Nota(
        id: 'nota-123',
        usuarioId: 'usuario-456',
        titulo: 'Mi primera nota',
        contenido: 'Este es el contenido de la nota',
        categoria: 'Personal',
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      expect(nota.id, equals('nota-123'));
      expect(nota.usuarioId, equals('usuario-456'));
      expect(nota.titulo, equals('Mi primera nota'));
      expect(nota.categoria, equals('Personal'));
      expect(nota.eliminado, equals(false));
    });

    test('Convertir nota a JSON', () {
      final nota = Nota(
        id: 'nota-123',
        usuarioId: 'usuario-456',
        titulo: 'Mi primera nota',
        contenido: 'Contenido',
        categoria: 'Personal',
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      final json = nota.aJson();

      expect(json['id'], equals('nota-123'));
      expect(json['usuarioId'], equals('usuario-456'));
      expect(json['titulo'], equals('Mi primera nota'));
      expect(json['categoria'], equals('Personal'));
      expect(json['eliminado'], equals(false));
    });

    test('Crear nota desde JSON', () {
      final nota = Nota.desdeJson(notaJson);

      expect(nota.id, equals('nota-123'));
      expect(nota.usuarioId, equals('usuario-456'));
      expect(nota.titulo, equals('Mi primera nota'));
      expect(nota.contenido, equals('Este es el contenido de la nota'));
      expect(nota.categoria, equals('Personal'));
      expect(nota.eliminado, equals(false));
    });

    test('Copiar nota con cambios', () {
      final nota = Nota(
        id: 'nota-123',
        usuarioId: 'usuario-456',
        titulo: 'Mi primera nota',
        contenido: 'Contenido',
        categoria: 'Personal',
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      final notaModificada = nota.copiarCon(
        titulo: 'Nota modificada',
        categoria: 'Trabajo',
      );

      expect(notaModificada.id, equals(nota.id));
      expect(notaModificada.titulo, equals('Nota modificada'));
      expect(notaModificada.categoria, equals('Trabajo'));
      expect(notaModificada.contenido, equals(nota.contenido));
    });

    test('String representation de nota', () {
      final nota = Nota(
        id: 'nota-123',
        usuarioId: 'usuario-456',
        titulo: 'Mi nota',
        contenido: 'Contenido',
        categoria: 'Personal',
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      final str = nota.toString();
      expect(str, contains('nota-123'));
      expect(str, contains('Mi nota'));
      expect(str, contains('Personal'));
    });

    test('Valor por defecto: eliminado = false', () {
      final nota = Nota(
        id: 'nota-123',
        usuarioId: 'usuario-456',
        titulo: 'Mi nota',
        contenido: 'Contenido',
        categoria: 'Personal',
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      expect(nota.eliminado, equals(false));
    });

    test('Manejo de JSON con campos faltantes', () {
      final jsonIncompleto = {
        'id': 'nota-123',
        'usuarioId': 'usuario-456',
        'creadoEn': Timestamp.fromDate(ahora),
        'actualizadoEn': Timestamp.fromDate(ahora),
      };

      final nota = Nota.desdeJson(jsonIncompleto);

      expect(nota.titulo, equals('Sin título'));
      expect(nota.contenido, equals(''));
      expect(nota.categoria, equals('General'));
      expect(nota.eliminado, equals(false));
    });
  });
}
