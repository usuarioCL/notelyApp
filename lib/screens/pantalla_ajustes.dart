import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../services/index.dart';

/// Pantalla de ajustes
///
/// Funcionalidades:
/// - Información del usuario
/// - Cerrar sesión
/// - Opciones generales
class PantallaAjustes extends StatelessWidget {
  const PantallaAjustes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AsyncValue<Usuario?>>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        elevation: 0,
      ),
      body: usuario.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
        data: (usuarioActual) {
          if (usuarioActual == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.login, size: 48),
                  const SizedBox(height: 16),
                  const Text('No hay usuario autenticado'),
                ],
              ),
            );
          }

          return ListView(
            children: [
              // Sección de perfil
              Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mi perfil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Nombre'),
                      subtitle: Text(usuarioActual.nombreMostrado),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(usuarioActual.email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Miembro desde'),
                      subtitle: Text(
                        _formatearFecha(usuarioActual.creadoEn),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),

              // Sección de preferencias
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Apariencia'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Próximamente'),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notificaciones'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Próximamente'),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Acerca de'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _mostrarDialogoAcerca(context),
              ),

              const SizedBox(height: 16),
              const Divider(),

              // Cerrar sesión
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => _mostrarDialogoCerrarSesion(context),
              ),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Versión 0.1.0',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final servicioAuth = context.read<ServicioAutenticacion>();
              await servicioAuth.cerrarSesion();
              if (context.mounted) {
                context.go('/');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sesión cerrada')),
                );
              }
            },
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoAcerca(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acerca de Notely'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notely v0.1.0'),
            SizedBox(height: 12),
            Text(
              'Una aplicación de notas multiplataforma con sincronización en tiempo real.',
            ),
            SizedBox(height: 12),
            Text('© 2026 - Todos los derechos reservados'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}
