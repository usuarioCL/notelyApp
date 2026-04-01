import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Clase que centraliza la configuración de todos los proveedores
/// Usada en main.dart con MultiProvider
class ProveedoresAplicacion {
  static List<SingleChildWidget> obtenerProveedores() {
    return [
      // Aquí irán los proveedores de:
      // - Autenticación
      // - Notas
      // - Categorías
      // etc.
    ];
  }
}
