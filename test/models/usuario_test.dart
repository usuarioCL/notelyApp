import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notely_app/models/index.dart';

void main() {
  group('Modelo Usuario', () {
    // Datos de prueba
    final ahora = DateTime.now();
    final usuarioJson = {
      'id': 'usuario-123',
      'email': 'usuario@example.com',
      'nombreMostrado': 'Juan Pérez',
      'creadoEn': Timestamp.fromDate(ahora),
    };

    test('Crear usuario con constructor', () {
      final usuario = Usuario(
        id: 'usuario-123',
        email: 'usuario@example.com',
        nombreMostrado: 'Juan Pérez',
        creadoEn: ahora,
      );

      expect(usuario.id, equals('usuario-123'));
      expect(usuario.email, equals('usuario@example.com'));
      expect(usuario.nombreMostrado, equals('Juan Pérez'));
    });

    test('Convertir usuario a JSON', () {
      final usuario = Usuario(
        id: 'usuario-123',
        email: 'usuario@example.com',
        nombreMostrado: 'Juan Pérez',
        creadoEn: ahora,
      );

      final json = usuario.aJson();

      expect(json['id'], equals('usuario-123'));
      expect(json['email'], equals('usuario@example.com'));
      expect(json['nombreMostrado'], equals('Juan Pérez'));
    });

    test('Crear usuario desde JSON', () {
      final usuario = Usuario.desdeJson(usuarioJson);

      expect(usuario.id, equals('usuario-123'));
      expect(usuario.email, equals('usuario@example.com'));
      expect(usuario.nombreMostrado, equals('Juan Pérez'));
    });

    test('Copiar usuario con cambios', () {
      final usuario = Usuario(
        id: 'usuario-123',
        email: 'usuario@example.com',
        nombreMostrado: 'Juan Pérez',
        creadoEn: ahora,
      );

      final usuarioModificado = usuario.copiarCon(
        nombreMostrado: 'Juan Carlos Pérez',
      );

      expect(usuarioModificado.id, equals(usuario.id));
      expect(usuarioModificado.nombreMostrado, equals('Juan Carlos Pérez'));
      expect(usuarioModificado.email, equals(usuario.email));
    });

    test('String representation de usuario', () {
      final usuario = Usuario(
        id: 'usuario-123',
        email: 'usuario@example.com',
        nombreMostrado: 'Juan Pérez',
        creadoEn: ahora,
      );

      final str = usuario.toString();
      expect(str, contains('usuario-123'));
      expect(str, contains('usuario@example.com'));
      expect(str, contains('Juan Pérez'));
    });

    test('Manejo de JSON con campos faltantes', () {
      final jsonIncompleto = {
        'id': 'usuario-123',
        'creadoEn': Timestamp.fromDate(ahora),
      };

      final usuario = Usuario.desdeJson(jsonIncompleto);

      expect(usuario.email, equals(''));
      expect(usuario.nombreMostrado, equals('Usuario'));
    });
  });
}
