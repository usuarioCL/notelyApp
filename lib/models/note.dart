import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para una Nota
///
/// Representa una nota de texto simple con:
/// - Contenido: título y texto plano
/// - Metadatos: fechas de creación y actualización
/// - Categoría: para organización básica
/// - Soft delete: para recuperación posterior
class Nota {
  final String id;              // ID único generado por Firebase
  final String usuarioId;       // ID del usuario propietario
  final String titulo;          // Título de la nota
  final String contenido;       // Contenido (texto plano - MVP)
  final String categoria;       // Categoría para organizar
  final DateTime creadoEn;      // Timestamp de creación
  final DateTime actualizadoEn; // Timestamp de última actualización
  final bool eliminado;         // Flag para soft delete

  Nota({
    required this.id,
    required this.usuarioId,
    required this.titulo,
    required this.contenido,
    required this.categoria,
    required this.creadoEn,
    required this.actualizadoEn,
    this.eliminado = false,
  });

  /// Convierte el modelo a JSON para Firestore
  Map<String, dynamic> aJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'titulo': titulo,
      'contenido': contenido,
      'categoria': categoria,
      'creadoEn': Timestamp.fromDate(creadoEn),
      'actualizadoEn': Timestamp.fromDate(actualizadoEn),
      'eliminado': eliminado,
    };
  }

  /// Crea un modelo desde JSON de Firestore
  factory Nota.desdeJson(Map<String, dynamic> json) {
    return Nota(
      id: json['id'] ?? '',
      usuarioId: json['usuarioId'] ?? '',
      titulo: json['titulo'] ?? 'Sin título',
      contenido: json['contenido'] ?? '',
      categoria: json['categoria'] ?? 'General',
      creadoEn: (json['creadoEn'] as Timestamp).toDate(),
      actualizadoEn: (json['actualizadoEn'] as Timestamp).toDate(),
      eliminado: json['eliminado'] ?? false,
    );
  }

  /// Crea una copia con cambios específicos (copyWith pattern)
  Nota copiarCon({
    String? id,
    String? usuarioId,
    String? titulo,
    String? contenido,
    String? categoria,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    bool? eliminado,
  }) {
    return Nota(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      titulo: titulo ?? this.titulo,
      contenido: contenido ?? this.contenido,
      categoria: categoria ?? this.categoria,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      eliminado: eliminado ?? this.eliminado,
    );
  }

  @override
  String toString() => 'Nota(id: $id, titulo: $titulo, categoria: $categoria)';
}

  @override
  String toString() => 'Note(id: $id, title: $title, category: $category)';
}
