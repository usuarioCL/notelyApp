import 'package:flutter/material.dart';

/// Pantalla de editor de notas
///
/// Funcionalidades:
/// - Editar título y contenido
/// - Seleccionar categoría
/// - Guardar nota
/// - Cancelar cambios
class EditorNota extends StatefulWidget {
  /// ID de la nota (null si es nueva)
  final String? notaId;

  const EditorNota({Key? key, this.notaId}) : super(key: key);

  @override
  State<EditorNota> createState() => _EditorNotaState();
}

class _EditorNotaState extends State<EditorNota> {
  late TextEditingController controladorTitulo;
  late TextEditingController controladorContenido;
  String categoriaSeleccionada = 'General';

  final String categorias = 'General,Personal,Trabajo,Ideas';

  @override
  void initState() {
    super.initState();
    controladorTitulo = TextEditingController();
    controladorContenido = TextEditingController();

    // Si es edición, cargar datos
    if (widget.notaId != null) {
      _cargarNota();
    }
  }

  @override
  void dispose() {
    controladorTitulo.dispose();
    controladorContenido.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notaId != null ? 'Editar nota' : 'Nueva nota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _guardarNota,
            tooltip: 'Guardar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de título
              TextField(
                controller: controladorTitulo,
                style: Theme.of(context).textTheme.headlineSmall,
                decoration: const InputDecoration(
                  hintText: 'Título de la nota',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),

              // Selector de categoría
              _construirSelectorCategoria(),
              const SizedBox(height: 16),

              // Campo de contenido
              TextField(
                controller: controladorContenido,
                maxLines: null,
                minLines: 10,
                decoration: InputDecoration(
                  hintText: 'Escribe tu nota aquí...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el selector de categoría
  Widget _construirSelectorCategoria() {
    return DropdownButton<String>(
      value: categoriaSeleccionada,
      onChanged: (String? nuevaCategoria) {
        if (nuevaCategoria != null) {
          setState(() {
            categoriaSeleccionada = nuevaCategoria;
          });
        }
      },
      items: categorias
          .split(',')
          .map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat),
              ))
          .toList(),
    );
  }

  void _cargarNota() {
    // TODO: Cargar datos de la nota desde Firebase
    print('Cargar nota: ${widget.notaId}');
  }

  void _guardarNota() {
    // TODO: Guardar nota en Firebase
    print('Guardar nota');
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
