import 'package:flutter/material.dart';

/// Pantalla de inicio - Listado de notas
/// 
/// Funcionalidades:
/// - Mostrar listado de notas
/// - Filtrar por categoría
/// - Botón para crear nueva nota
/// - Acceso a ajustes
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({Key? key}) : super(key: key);

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  // Categoría seleccionada para filtrado
  String categoriaSeleccionada = 'General';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis notas'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _irAjustes(),
          ),
        ],
      ),
      body: const Center(
        child: Text('Pantalla de inicio en desarrollo...'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nueva nota',
        onPressed: _crearNuevaNota,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _crearNuevaNota() {
    // TODO: Navegar a EditorNota sin ID
    print('Crear nueva nota');
  }

  void _irAjustes() {
    // TODO: Navegar a ajustes
    print('Ir a ajustes');
  }
}
