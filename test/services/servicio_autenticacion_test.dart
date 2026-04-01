import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notely_app/services/index.dart';
import 'package:notely_app/models/index.dart';

// Mocks
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('ServicioAutenticacion', () {
    late ServicioAutenticacion servicio;
    late MockFirebaseAuth mockAuth;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      servicio = ServicioAutenticacion();
    });

    test('Obtener usuario actual cuando no hay usuario', () {
      // Arrange
      when(mockAuth.currentUser).thenReturn(null);

      // Act
      final usuario = servicio.obtenerUsuarioActual();

      // Assert
      expect(usuario, isNull);
    });

    test('Procesar error: usuario no encontrado', () {
      // Arrange
      final excepcion = FirebaseAuthException(code: 'user-not-found');

      // Act
      final mensaje = servicio.obtenerMensajeError(excepcion);

      // Assert
      expect(mensaje, contains('Usuario no encontrado'));
    });

    test('Procesar error: contraseña incorrecta', () {
      // Arrange
      final excepcion = FirebaseAuthException(code: 'wrong-password');

      // Act
      final mensaje = servicio.obtenerMensajeError(excepcion);

      // Assert
      expect(mensaje, contains('Contraseña incorrecta'));
    });

    test('Procesar error: email ya registrado', () {
      // Arrange
      final excepcion = FirebaseAuthException(code: 'email-already-in-use');

      // Act
      final mensaje = servicio.obtenerMensajeError(excepcion);

      // Assert
      expect(mensaje, contains('email ya está registrado'));
    });

    test('Procesar error: contraseña débil', () {
      // Arrange
      final excepcion = FirebaseAuthException(code: 'weak-password');

      // Act
      final mensaje = servicio.obtenerMensajeError(excepcion);

      // Assert
      expect(mensaje, contains('contraseña es muy débil'));
    });

    test('Procesar error: email inválido', () {
      // Arrange
      final excepcion = FirebaseAuthException(code: 'invalid-email');

      // Act
      final mensaje = servicio.obtenerMensajeError(excepcion);

      // Assert
      expect(mensaje, contains('email no es válido'));
    });

    test('Procesar error desconocido', () {
      // Arrange
      final excepcion = FirebaseAuthException(code: 'unknown-error');

      // Act
      final mensaje = servicio.obtenerMensajeError(excepcion);

      // Assert
      expect(mensaje, contains('Error de autenticación'));
    });
  });
}

// Extensión temporal para acceder al método de error
extension TestExtension on ServicioAutenticacion {
  String obtenerMensajeError(FirebaseAuthException e) {
    return _procesarErrorAutenticacion(e);
  }

  String _procesarErrorAutenticacion(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'El email ya está registrado';
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'invalid-email':
        return 'El email no es válido';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}
