import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/pantalla_inicio.dart';
import '../screens/editor_nota.dart';
import '../screens/pantalla_ajustes.dart';

class RutasAplicacion {
  // Rutas nombradas (para referencia en la app)
  static const String inicio = '/';
  static const String editorNota = '/editor-nota';
  static const String ajustes = '/ajustes';

  static GoRouter obtenerConfigRutas() {
    return GoRouter(
      initialLocation: inicio,
      routes: [
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
