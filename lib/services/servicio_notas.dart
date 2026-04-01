import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

/// Servicio de notas usando Firestore
///
/// Gestiona:
/// - Crear nuevas notas
/// - Obtener notas del usuario
/// - Actualizar notas
/// - Eliminar notas (soft delete)
/// - Búsqueda y filtrado
class ServicioNotas {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _coleccion = 'notas';

  /// Crea una nueva nota
  ///
  /// Retorna el ID de la nota creada
  Future<String> crearNota({
    required String usuarioId,
    required String titulo,
    required String contenido,
    required String categoria,
  }) async {
    try {
      final ahora = DateTime.now();
      final notaNueva = Nota(
        id: _firestore.collection(_coleccion).doc().id,
        usuarioId: usuarioId,
        titulo: titulo,
        contenido: contenido,
        categoria: categoria,
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      await _firestore
          .collection(_coleccion)
          .doc(notaNueva.id)
          .set(notaNueva.aJson());

      return notaNueva.id;
    } catch (e) {
      throw Exception('Error al crear nota: $e');
    }
  }

  /// Obtiene todas las notas de un usuario
  ///
  /// Parámetros opcionales:
  /// - categoria: filtrar por categoría
  /// - ordenadoPor: campo para ordenar (defecto: "actualizadoEn")
  Future<List<Nota>> obtenerNotasUsuario({
    required String usuarioId,
    String? categoria,
    String ordenadoPor = 'actualizadoEn',
  }) async {
    try {
      var query = _firestore
          .collection(_coleccion)
          .where('usuarioId', isEqualTo: usuarioId)
          .where('eliminado', isEqualTo: false)
          .orderBy(ordenadoPor, descending: true);

      // Filtrar por categoría si se proporciona
      if (categoria != null) {
        query = query.where('categoria', isEqualTo: categoria) as Query;
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Nota.desdeJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener notas: $e');
    }
  }

  /// Obtiene stream de notas (actualizaciones en tiempo real)
  Stream<List<Nota>> obtenerStreamNotasUsuario({
    required String usuarioId,
    String? categoria,
  }) {
    try {
      var query = _firestore
          .collection(_coleccion)
          .where('usuarioId', isEqualTo: usuarioId)
          .where('eliminado', isEqualTo: false)
          .orderBy('actualizadoEn', descending: true);

      if (categoria != null) {
        query = query.where('categoria', isEqualTo: categoria) as Query;
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => Nota.desdeJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw Exception('Error al obtener stream de notas: $e');
    }
  }

  /// Obtiene una nota por su ID
  Future<Nota?> obtenerNota(String notaId) async {
    try {
      final doc = await _firestore.collection(_coleccion).doc(notaId).get();

      if (!doc.exists) return null;

      final nota = Nota.desdeJson(doc.data()!);

      // No retornar si está eliminada
      if (nota.eliminado) return null;

      return nota;
    } catch (e) {
      throw Exception('Error al obtener nota: $e');
    }
  }

  /// Actualiza una nota existente
  Future<void> actualizarNota({
    required String notaId,
    String? titulo,
    String? contenido,
    String? categoria,
  }) async {
    try {
      final actualizaciones = <String, dynamic>{
        'actualizadoEn': Timestamp.now(),
      };

      if (titulo != null) actualizaciones['titulo'] = titulo;
      if (contenido != null) actualizaciones['contenido'] = contenido;
      if (categoria != null) actualizaciones['categoria'] = categoria;

      await _firestore
          .collection(_coleccion)
          .doc(notaId)
          .update(actualizaciones);
    } catch (e) {
      throw Exception('Error al actualizar nota: $e');
    }
  }

  /// Elimina una nota (soft delete)
  ///
  /// Marca la nota como eliminada sin borrarla físicamente
  Future<void> eliminarNota(String notaId) async {
    try {
      await _firestore.collection(_coleccion).doc(notaId).update({
        'eliminado': true,
        'actualizadoEn': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Error al eliminar nota: $e');
    }
  }

  /// Restaura una nota eliminada
  Future<void> restaurarNota(String notaId) async {
    try {
      await _firestore.collection(_coleccion).doc(notaId).update({
        'eliminado': false,
        'actualizadoEn': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Error al restaurar nota: $e');
    }
  }

  /// Busca notas por título o contenido
  Future<List<Nota>> buscarNotas({
    required String usuarioId,
    required String termino,
  }) async {
    try {
      final notas = await obtenerNotasUsuario(usuarioId: usuarioId);

      // Filtro simple en memoria (para MVP)
      // En producción, usar búsqueda de Firestore
      return notas
          .where((nota) =>
              nota.titulo.toLowerCase().contains(termino.toLowerCase()) ||
              nota.contenido.toLowerCase().contains(termino.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar notas: $e');
    }
  }
}
