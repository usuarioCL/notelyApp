import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/pantalla_inicio.dart';
import '../screens/editor_nota.dart';
import '../screens/pantalla_ajustes.dart';
import '../screens/pantalla_login.dart';
import '../screens/pantalla_registro.dart';
import '../screens/pantalla_recuperar_contraseña.dart';
import 'guards_autenticacion.dart';

class RutasAplicacion {
  // Rutas nombradas (para referencia en la app)
  static const String inicio = '/';
  static const String login = '/login';
  static const String registro = '/registro';
  static const String recuperarContraseña = '/recuperar-contraseña';
  static const String editorNota = '/editor-nota';
  static const String ajustes = '/ajustes';

  static GoRouter obtenerConfigRutas() {
    return GoRouter(
      initialLocation: login,
      redirect: GuardAutenticacion.redirectAutenticacion,
      refreshListenable: _RefreshNotifier(),
      routes: [
        // Rutas de autenticación
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const PantallaLogin(),
        ),
        GoRoute(
          path: registro,
          name: 'registro',
          builder: (context, state) => const PantallaRegistro(),
        ),
        GoRoute(
          path: recuperarContraseña,
          name: 'recuperarContraseña',
          builder: (context, state) {
            final email = state.extra as String?;
            return PantallaRecuperarContraseña(emailInicial: email);
          },
        ),
        
        // Rutas principales
        GoRoute(
          path: inicio,
          name: 'inicio',
          builder: (context, state) => const PantallaInicio(),
          routes: [
            // Ruta para crear/editar nota
            GoRoute(
              path: 'editor-nota',
              name: 'editorNota',
              builder: (context, state) {
                // Parámetro opcional: ID de nota (null para crear)
                final notaId = state.uri.queryParameters['id'];
                return EditorNota(notaId: notaId);
              },
            ),
            // Ruta para ajustes
            GoRoute(
              path: 'ajustes',
              name: 'ajustes',
              builder: (context, state) => const PantallaAjustes(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text('Ruta no encontrada: ${state.error}'),
        ),
      ),
    );
  }
}

/// Notifier para que GoRouter reaccione a cambios de autenticación
/// Esto permite que el redirect se ejecute cuando el usuario se autentica/desautentica
class _RefreshNotifier extends ChangeNotifier {
  _RefreshNotifier() {
    // Notificar cambios cuando sea necesario
    // En una implementación real, podrías escuchar cambios del servicio aquí
  }
}
