import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../services/index.dart';
import '../models/index.dart';

/// Clase que centraliza la configuración de todos los proveedores
/// Usada en main.dart con MultiProvider
class ProveedoresAplicacion {
  static List<SingleChildWidget> obtenerProveedores() {
    return [
      // **SERVICIOS** - Instancias únicas (Singleton)
      Provider<ServicioAutenticacion>(
        (ref) => ServicioAutenticacion(),
      ),
      Provider<ServicioNotas>(
        (ref) => ServicioNotas(),
      ),
      Provider<ServicioCategorias>(
        (ref) => ServicioCategorias(),
      ),

      // **AUTENTICACIÓN** - Stream de usuario actual
      StreamProvider<Usuario?>(
        (ref) {
          final servicioAuth = ref.watch(
            Provider((ref) => ServicioAutenticacion()),
          );
          return servicioAuth.obtenerStreamUsuario();
        },
        initialData: null,
      ),
    ];
  }
}
