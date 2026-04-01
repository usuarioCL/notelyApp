import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

/// Servicio de autenticación usando Firebase Auth
///
/// Gestiona:
/// - Registro de usuarios
/// - Inicio de sesión
/// - Cierre de sesión
/// - Obtener usuario actual
class ServicioAutenticacion {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene el usuario actualmente autenticado
  Usuario? obtenerUsuarioActual() {
    final usuarioAuth = _auth.currentUser;
    if (usuarioAuth == null) return null;

    return Usuario(
      id: usuarioAuth.uid,
      email: usuarioAuth.email ?? '',
      nombreMostrado: usuarioAuth.displayName ?? 'Usuario',
      creadoEn: usuarioAuth.metadata.creationTime ?? DateTime.now(),
    );
  }

  /// Stream del usuario autenticado
  Stream<Usuario?> obtenerStreamUsuario() {
    return _auth.authStateChanges().asyncMap((usuarioAuth) async {
      if (usuarioAuth == null) return null;

      // Obtener datos adicionales de Firestore
      final doc = await _firestore.collection('usuarios').doc(usuarioAuth.uid).get();
      if (doc.exists) {
        return Usuario.desdeJson(doc.data()!);
      }

      // Si no existe en Firestore, crear usuario
      final usuarioNuevo = Usuario(
        id: usuarioAuth.uid,
        email: usuarioAuth.email ?? '',
        nombreMostrado: usuarioAuth.displayName ?? 'Usuario',
        creadoEn: usuarioAuth.metadata.creationTime ?? DateTime.now(),
      );

      await _guardarUsuarioEnFirestore(usuarioNuevo);
      return usuarioNuevo;
    });
  }

  /// Registra un nuevo usuario
  ///
  /// Parámetros:
  /// - email: correo del usuario
  /// - contraseña: contraseña
  /// - nombreMostrado: nombre para mostrar
  ///
  /// Retorna el usuario creado o lanza excepción
  Future<Usuario> registrarse({
    required String email,
    required String contraseña,
    required String nombreMostrado,
  }) async {
    try {
      final resultado = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: contraseña,
      );

      await resultado.user?.updateDisplayName(nombreMostrado);

      final usuarioNuevo = Usuario(
        id: resultado.user!.uid,
        email: email,
        nombreMostrado: nombreMostrado,
        creadoEn: DateTime.now(),
      );

      await _guardarUsuarioEnFirestore(usuarioNuevo);
      return usuarioNuevo;
    } on FirebaseAuthException catch (e) {
      throw _procesarErrorAutenticacion(e);
    }
  }

  /// Inicia sesión con email y contraseña
  Future<Usuario> iniciarSesion({
    required String email,
    required String contraseña,
  }) async {
    try {
      final resultado = await _auth.signInWithEmailAndPassword(
        email: email,
        password: contraseña,
      );

      final doc = await _firestore
          .collection('usuarios')
          .doc(resultado.user!.uid)
          .get();

      if (doc.exists) {
        return Usuario.desdeJson(doc.data()!);
      }

      throw Exception('Usuario no encontrado en Firestore');
    } on FirebaseAuthException catch (e) {
      throw _procesarErrorAutenticacion(e);
    }
  }

  /// Cierra la sesión actual
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  /// Envía un enlace de recuperación de contraseña al email especificado
  ///
  /// Parámetros:
  /// - email: correo del usuario para recuperar contraseña
  ///
  /// Lanza excepción si hay error
  Future<void> enviarEnlaceRecuperacionContraseña({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _procesarErrorAutenticacion(e);
    }
  }

  /// Guarda el usuario en Firestore
  Future<void> _guardarUsuarioEnFirestore(Usuario usuario) async {
    await _firestore.collection('usuarios').doc(usuario.id).set(
          usuario.aJson(),
          SetOptions(merge: true),
        );
  }

  /// Procesa errores de autenticación de Firebase
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
