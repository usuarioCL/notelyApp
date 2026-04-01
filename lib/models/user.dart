import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para un Usuario
///
/// Almacena información del usuario autenticado
class User {
  final String id;              // ID único (Firebase Auth UID)
  final String email;           // Email del usuario
  final String displayName;     // Nombre mostrado
  final DateTime createdAt;     // Fecha de creación de cuenta

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  /// Convierte el modelo a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Crea un modelo desde JSON de Firestore
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? 'Usuario',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Crea una copia con cambios específicos
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'User(id: $id, email: $email, displayName: $displayName)';
}
