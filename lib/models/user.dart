import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para un Usuario
///
/// Almacena información del usuario autenticado
class Usuario {
  final String id;              // ID único (Firebase Auth UID)
  final String email;           // Email del usuario
  final String nombreMostrado;  // Nombre mostrado del usuario
  final DateTime creadoEn;      // Fecha de creación de cuenta

  Usuario({
    required this.id,
    required this.email,
    required this.nombreMostrado,
    required this.creadoEn,
  });

  /// Convierte el modelo a JSON para Firestore
  Map<String, dynamic> aJson() {
    return {
      'id': id,
      'email': email,
      'nombreMostrado': nombreMostrado,
      'creadoEn': Timestamp.fromDate(creadoEn),
    };
  }

  /// Crea un modelo desde JSON de Firestore
  factory Usuario.desdeJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nombreMostrado: json['nombreMostrado'] ?? 'Usuario',
      creadoEn: (json['creadoEn'] as Timestamp).toDate(),
    );
  }

  /// Crea una copia con cambios específicos
  Usuario copiarCon({
    String? id,
    String? email,
    String? nombreMostrado,
    DateTime? creadoEn,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      nombreMostrado: nombreMostrado ?? this.nombreMostrado,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  String toString() => 'Usuario(id: $id, email: $email, nombreMostrado: $nombreMostrado)';
}
