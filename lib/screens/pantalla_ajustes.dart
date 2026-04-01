import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../services/index.dart';

/// Pantalla de ajustes
///
/// Funcionalidades:
/// - Información del usuario
/// - Cerrar sesión con confirmación
/// - Opciones generales
class PantallaAjustes extends StatefulWidget {
  const PantallaAjustes({Key? key}) : super(key: key);

  @override
  State<PantallaAjustes> createState() => _PantallaAjustesState();
}

class _PantallaAjustesState extends State<PantallaAjustes> {
  bool _cargando = false;

  Future<void> _cerrarSesion() async {
    // Mostrar diálogo de confirmación
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() => _cargando = true);

      try {
        final servicio = context.read<ServicioAutenticacion>();
        await servicio.cerrarSesion();

        if (!mounted) return;

        // El redirect guard en rutas.dart detectará la ausencia de usuario
        // y redirigirá automáticamente a /login
        context.go('/login');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión cerrada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al cerrar sesión: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _cargando = false);
        }
      }
    }
  }

  void _mostrarDialogoAcerca() {
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
            SizedBox(height: 12),
            Text(
              'Stack: Flutter + Firebase + Provider + GoRouter',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
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

  @override
  Widget build(BuildContext context) {
    // Obtener usuario actual del StreamProvider
    final usuario = context.watch<Usuario?>();

    if (usuario == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ajustes'),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.login, size: 48),
              const SizedBox(height: 16),
              const Text('No hay usuario autenticado'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Ir a iniciar sesión'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        elevation: 0,
      ),
      body: ListView(
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
                  subtitle: Text(usuario.nombreMostrado),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: Text(usuario.email),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Miembro desde'),
                  subtitle: Text(_formatearFecha(usuario.creadoEn)),
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
            onTap: _cargando
                ? null
                : () {
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
            onTap: _cargando
                ? null
                : () {
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
            onTap: _cargando ? null : _mostrarDialogoAcerca,
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
            enabled: !_cargando,
            onTap: _cargando ? null : _cerrarSesion,
          ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              'Versión 0.1.0',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}
