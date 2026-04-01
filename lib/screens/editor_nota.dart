import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../services/index.dart';

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
  bool cargando = false;
  bool editando = false;

  final List<String> categorias = ['General', 'Personal', 'Trabajo', 'Ideas'];

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
    return WillPopScope(
      onWillPop: () async {
        if (controladorTitulo.text.isNotEmpty ||
            controladorContenido.text.isNotEmpty) {
          return await _mostrarDialogoSalir(context) ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.notaId != null ? 'Editar nota' : 'Nueva nota'),
          elevation: 0,
          actions: [
            if (cargando)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
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
                  enabled: !cargando,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    hintText: 'Título de la nota',
                    border: InputBorder.none,
                    enabled: !cargando,
                  ),
                ),
                const SizedBox(height: 16),

                // Selector de categoría
                _construirSelectorCategoria(),
                const SizedBox(height: 16),

                // Campo de contenido
                TextField(
                  controller: controladorContenido,
                  enabled: !cargando,
                  maxLines: null,
                  minLines: 15,
                  decoration: InputDecoration(
                    hintText: 'Escribe tu nota aquí...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabled: !cargando,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye el selector de categoría
  Widget _construirSelectorCategoria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoría',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: categoriaSeleccionada,
          isExpanded: true,
          onChanged: cargando
              ? null
              : (String? nuevaCategoria) {
                  if (nuevaCategoria != null) {
                    setState(() {
                      categoriaSeleccionada = nuevaCategoria;
                    });
                  }
                },
          items: categorias
              .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Future<void> _cargarNota() async {
    if (widget.notaId == null) return;

    setState(() => cargando = true);

    try {
      final servicioNotas = context.read<ServicioNotas>();
      final nota = await servicioNotas.obtenerNota(widget.notaId!);

      if (nota != null) {
        setState(() {
          controladorTitulo.text = nota.titulo;
          controladorContenido.text = nota.contenido;
          categoriaSeleccionada = nota.categoria;
          editando = true;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nota no encontrada')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar nota: $e')),
        );
      }
    } finally {
      setState(() => cargando = false);
    }
  }

  Future<void> _guardarNota() async {
    if (controladorTitulo.text.isEmpty && controladorContenido.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La nota debe tener al menos un título o contenido'),
        ),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      final usuarioAsync = context.read<AsyncValue<Usuario?>>();
      final servicioNotas = context.read<ServicioNotas>();

      final usuarioActual = usuarioAsync.maybeWhen(
        data: (usuario) => usuario,
        orElse: () => null,
      );

      if (usuarioActual == null) {
        throw Exception('Usuario no autenticado');
      }

      if (editando && widget.notaId != null) {
        // Actualizar nota existente
        await servicioNotas.actualizarNota(
          notaId: widget.notaId!,
          titulo: controladorTitulo.text,
          contenido: controladorContenido.text,
          categoria: categoriaSeleccionada,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nota actualizada')),
          );
          context.pop();
        }
      } else {
        // Crear nueva nota
        await servicioNotas.crearNota(
          usuarioId: usuarioActual.id,
          titulo: controladorTitulo.text,
          contenido: controladorContenido.text,
          categoria: categoriaSeleccionada,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nota guardada')),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      setState(() => cargando = false);
    }
  }

  Future<bool?> _mostrarDialogoSalir(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar cambios'),
        content: const Text('Tienes cambios sin guardar. ¿Descartar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuar editando'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Descartar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
