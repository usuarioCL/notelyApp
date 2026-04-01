import 'package:flutter_test/flutter_test.dart';
import 'package:notely_app/utils/validadores.dart';

void main() {
  group('Validadores', () {
    group('validarEmail', () {
      test('Retorna error si email está vacío', () {
        final resultado = Validadores.validarEmail(null);
        expect(resultado, isNotNull);
        expect(resultado, contains('requerido'));
      });

      test('Retorna error si email es inválido', () {
        final resultado = Validadores.validarEmail('email_invalido');
        expect(resultado, isNotNull);
        expect(resultado, contains('válido'));
      });

      test('Retorna null si email es válido', () {
        final resultado = Validadores.validarEmail('usuario@ejemplo.com');
        expect(resultado, isNull);
      });

      test('Acepta emails con dominios válidos', () {
        final emails = [
          'test@gmail.com',
          'user.name@empresa.co.uk',
          'admin+tag@dominio.info',
        ];

        for (final email in emails) {
          expect(Validadores.validarEmail(email), isNull,
              reason: 'Email válido rechazado: $email');
        }
      });

      test('Rechaza emails sin @ o con formato inválido', () {
        final emailsInvalidos = [
          'notiene@punto',
          '@sinusuario.com',
          'usuario@',
          'usuario @ejemplo.com',
        ];

        for (final email in emailsInvalidos) {
          expect(Validadores.validarEmail(email), isNotNull,
              reason: 'Email inválido aceptado: $email');
        }
      });
    });

    group('validarContraseña', () {
      test('Retorna error si contraseña está vacía', () {
        final resultado = Validadores.validarContraseña(null);
        expect(resultado, isNotNull);
        expect(resultado, contains('requerida'));
      });

      test('Retorna error si tiene menos de 6 caracteres', () {
        final resultado = Validadores.validarContraseña('Abc12');
        expect(resultado, isNotNull);
        expect(resultado, contains('6 caracteres'));
      });

      test('Retorna error si no tiene mayúscula', () {
        final resultado = Validadores.validarContraseña('abcdef123');
        expect(resultado, isNotNull);
        expect(resultado, contains('mayúscula'));
      });

      test('Retorna error si no tiene número', () {
        final resultado = Validadores.validarContraseña('Abcdef');
        expect(resultado, isNotNull);
        expect(resultado, contains('número'));
      });

      test('Retorna null si contraseña es válida', () {
        final resultado = Validadores.validarContraseña('Contraseña123');
        expect(resultado, isNull);
      });

      test('Valida contraseñas complejas correctamente', () {
        final contraseñasValidas = [
          'Admin123',
          'MyPass456',
          'Test@Pass789',
          'Segura999',
        ];

        for (final contraseña in contraseñasValidas) {
          expect(Validadores.validarContraseña(contraseña), isNull,
              reason: 'Contraseña válida rechazada: $contraseña');
        }
      });
    });

    group('validarConfirmacionContraseña', () {
      test('Retorna error si confirmación está vacía', () {
        final resultado = Validadores.validarConfirmacionContraseña(
          'Contraseña123',
          null,
        );
        expect(resultado, isNotNull);
        expect(resultado, contains('confirmar'));
      });

      test('Retorna error si no coinciden', () {
        final resultado = Validadores.validarConfirmacionContraseña(
          'Contraseña123',
          'Contraseña456',
        );
        expect(resultado, isNotNull);
        expect(resultado, contains('coinciden'));
      });

      test('Retorna null si coinciden', () {
        final resultado = Validadores.validarConfirmacionContraseña(
          'Contraseña123',
          'Contraseña123',
        );
        expect(resultado, isNull);
      });
    });

    group('validarNombreMostrado', () {
      test('Retorna error si nombre está vacío', () {
        final resultado = Validadores.validarNombreMostrado(null);
        expect(resultado, isNotNull);
        expect(resultado, contains('requerido'));
      });

      test('Retorna error si tiene menos de 2 caracteres', () {
        final resultado = Validadores.validarNombreMostrado('A');
        expect(resultado, isNotNull);
        expect(resultado, contains('2 caracteres'));
      });

      test('Retorna error si excede 50 caracteres', () {
        final nombre = 'A' * 51;
        final resultado = Validadores.validarNombreMostrado(nombre);
        expect(resultado, isNotNull);
        expect(resultado, contains('50 caracteres'));
      });

      test('Retorna null si nombre es válido', () {
        final nombres = ['Juan', 'María García', 'John Smith', 'Usuario123'];
        for (final nombre in nombres) {
          expect(Validadores.validarNombreMostrado(nombre), isNull);
        }
      });
    });
  });
}
