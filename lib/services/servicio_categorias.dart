/// Servicio de categorías
///
/// Gestiona las categorías disponibles para las notas
class ServicioCategorias {
  /// Categorías predefinidas para el MVP
  static const List<String> categoriasDisponibles = [
    'General',
    'Personal',
    'Trabajo',
    'Ideas',
  ];

  /// Obtiene todas las categorías disponibles
  List<String> obtenerCategorias() {
    return List.from(categoriasDisponibles);
  }

  /// Verifica si una categoría es válida
  bool esCategoriasValida(String categoria) {
    return categoriasDisponibles.contains(categoria);
  }

  /// Obtiene la categoría por defecto
  String obtenerCategoriaDefault() {
    return categoriasDisponibles.first;
  }
}
