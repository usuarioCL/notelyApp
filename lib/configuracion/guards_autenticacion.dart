import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/servicio_autenticacion.dart';

/// Guard para proteger rutas que requieren autenticación
/// 
/// Si el usuario NO está autenticado, redirige a /login
/// Si el usuario SÍ está autenticado, permite el acceso
class GuardAutenticacion {
  /// Verifica si el usuario está autenticado
  static Future<bool> esUsuarioAutenticado(
    GoRouterState state,
    dynamic context,
  ) async {
    try {
      // Acceder al servicio desde Provider
      final servicio = context.read<ServicioAutenticacion>();
      final usuario = servicio.obtenerUsuarioActual();

      // Si no hay usuario, no está autenticado
      if (usuario == null) {
        return false;
      }

      return true;
    } catch (e) {
      // En caso de error, denegar acceso
      return false;
    }
  }

  /// Redirect guard para GoRouter
  /// Se ejecuta antes de navegar a una ruta protegida
  ///
  /// Retorna:
  /// - null: permite el acceso
  /// - String: ruta a la que redirigir (ej: '/login')
  static Future<String?> redirectAutenticacion(
    BuildContext context,
    GoRouterState state,
  ) async {
    try {
      final servicio = context.read<ServicioAutenticacion>();
      final usuario = servicio.obtenerUsuarioActual();

      // Rutas públicas (no requieren autenticación)
      final rutasPublicas = [
        '/login',
        '/registro',
        '/recuperar-contraseña',
      ];

      // Rutas protegidas (requieren autenticación)
      final rutasProtegidas = [
        '/',
        '/ajustes',
      ];

      // Si está en ruta pública pero ya autenticado, redirigir a inicio
      if (rutasPublicas.contains(state.matchedLocation) && usuario != null) {
        return '/';
      }

      // Si está en ruta protegida pero NO autenticado, redirigir a login
      if (rutasProtegidas.contains(state.matchedLocation) && usuario == null) {
        return '/login';
      }

      // Si está en /login y es primera vez, permitir
      if (state.matchedLocation == '/login' && usuario == null) {
        return null;
      }

      // Permitir acceso por defecto
      return null;
    } catch (e) {
      // En caso de error, permitir (se maneja en el app)
      return null;
    }
  }
}
