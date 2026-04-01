import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          // Sección de perfil
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi perfil'),
            onTap: () {
              // TODO: Ir a perfil del usuario
            },
          ),
          const Divider(),

          // Sección de preferencias
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Apariencia'),
            onTap: () {
              // TODO: Abrir opciones de tema
            },
          ),

          // Cerrar sesión
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              // TODO: Implementar cerrar sesión
            },
          ),
        ],
      ),
    );
  }
}
