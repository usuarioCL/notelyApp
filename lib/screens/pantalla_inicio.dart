import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../services/index.dart';
import '../widgets/busqueda_avanzada.dart';

/// Pantalla de inicio - Listado de notas
///
/// Funcionalidades:
/// - Mostrar listado de notas en tiempo real
/// - Filtrar por categoría
/// - Botón para crear nueva nota
/// - Acceso a ajustes
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({Key? key}) : super(key: key);

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  String categoriaSeleccionada = 'Todas';
  bool enBusqueda = false;
  String terminoBusqueda = '';
  List<String> categoriasSeleccionadas = [];

  final List<String> categorias = ['Todas', 'General', 'Personal', 'Trabajo', 'Ideas'];

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AsyncValue<Usuario?>>();
    final servicioNotas = context.read<ServicioNotas>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis notas'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => setState(() => enBusqueda = !enBusqueda),
            tooltip: 'Búsqueda avanzada',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _irAjustes(context),
            tooltip: 'Ajustes',
          ),
        ],
      ),
      body: Column(
        children: [
          // Búsqueda avanzada si está activa
          if (enBusqueda)
            BusquedaAvanzada(
              onBuscar: (termino, categoriasFiltro) {
                setState(() {
                  terminoBusqueda = termino;
                  categoriasSeleccionadas = categoriasFiltro;
                });
              },
              categoriasDisponibles:
                  categorias.where((c) => c != 'Todas').toList(),
              onCancelar: () {
                setState(() {
                  enBusqueda = false;
                  terminoBusqueda = '';
                  categoriasSeleccionadas = [];
                });
              },
            ),

          // Contenido principal
          Expanded(
            child: usuario.when(
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
                  const Text('Inicia sesión para continuar'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navegar a pantalla de login
                    },
                    child: const Text('Iniciar sesión'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Selector de categoría
              _construirSelectorCategoria(),

              // Lista de notas
              Expanded(
                child: _construirListaNotas(
                  servicioNotas,
                  usuarioActual,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nueva nota',
        onPressed: () => _crearNuevaNota(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _construirSelectorCategoria() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text('Categoría: ', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _categoriaPastilla('Todas'),
                  _categoriaPastilla('General'),
                  _categoriaPastilla('Personal'),
                  _categoriaPastilla('Trabajo'),
                  _categoriaPastilla('Ideas'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoriaPastilla(String categoria) {
    final seleccionada = categoriaSeleccionada == categoria;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(categoria),
        selected: seleccionada,
        onSelected: (_) {
          setState(() {
            categoriaSeleccionada = categoria;
          });
        },
      ),
    );
  }

  Widget _construirListaNotas(
    ServicioNotas servicioNotas,
    Usuario usuario,
  ) {
    final categoria = categoriaSeleccionada == 'Todas' 
        ? null 
        : categoriaSeleccionada;

    return StreamBuilder<List<Nota>>(
      stream: servicioNotas.obtenerStreamNotasUsuario(
        usuarioId: usuario.id,
        categoria: categoria,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Error al cargar notas'),
              ],
            ),
          );
        }

        final notas = snapshot.data ?? [];

        if (notas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.note_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  categoriaSeleccionada == 'Todas'
                      ? 'No hay notas aún'
                      : 'No hay notas en $categoriaSeleccionada',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: notas.length,
          itemBuilder: (context, index) {
            final nota = notas[index];
            return _construirElementoNota(context, nota);
          },
        );
      },
    );
  }

  Widget _construirElementoNota(BuildContext context, Nota nota) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(
          nota.titulo.isEmpty ? 'Sin título' : nota.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              nota.contenido.isEmpty ? 'Sin contenido' : nota.contenido,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    nota.categoria,
                    style: const TextStyle(fontSize: 12),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                const Spacer(),
                Text(
                  _formatearFecha(nota.actualizadoEn),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () => _editarNota(context, nota.id),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _eliminarNota(context, nota.id),
        ),
      ),
    );
  }

  void _crearNuevaNota(BuildContext context) {
    context.push('/editor-nota');
  }

  void _editarNota(BuildContext context, String notaId) {
    context.push('/editor-nota?id=$notaId');
  }

  void _eliminarNota(BuildContext context, String notaId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: const Text('¿Estás seguro de que deseas eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final servicioNotas = context.read<ServicioNotas>();
              servicioNotas.eliminarNota(notaId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nota eliminada')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _irAjustes(BuildContext context) {
    context.push('/ajustes');
  }

  String _formatearFecha(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);

    if (diferencia.inMinutes < 60) {
      return 'Hace ${diferencia.inMinutes} min';
    } else if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours} h';
    } else if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays} días';
    } else {
      return '${fecha.day}/${fecha.month}/${fecha.year}';
    }
  }
}
