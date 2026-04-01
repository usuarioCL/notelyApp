import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para una Nota
///
/// Representa una nota de texto simple con:
/// - Contenido: título y texto plano
/// - Metadatos: fechas de creación y actualización
/// - Categoría: para organización básica
/// - Soft delete: para recuperación posterior
class Note {
  final String id;              // ID único generado por Firebase
  final String userId;          // Usuario propietario
  final String title;           // Título de la nota
  final String content;         // Contenido (texto plano - MVP)
  final String category;        // Categoría para organizar (nuevo)
  final DateTime createdAt;     // Fecha de creación
  final DateTime updatedAt;     // Última actualización
  final bool isDeleted;         // Soft delete (no borrar físicamente)

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  /// Convierte el modelo a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isDeleted': isDeleted,
    };
  }

  /// Crea un modelo desde JSON de Firestore
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? 'Sin título',
      content: json['content'] ?? '',
      category: json['category'] ?? 'General',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  /// Crea una copia con cambios específicos (copyWith pattern)
  Note copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  String toString() => 'Note(id: $id, title: $title, category: $category)';
}
