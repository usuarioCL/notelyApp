import 'package:flutter/material.dart';

/// Widget de búsqueda avanzada con filtros
class BusquedaAvanzada extends StatefulWidget {
  final Function(String termino, List<String> categorias) onBuscar;
  final List<String> categoriasDisponibles;
  final VoidCallback onCancelar;

  const BusquedaAvanzada({
    Key? key,
    required this.onBuscar,
    required this.categoriasDisponibles,
    required this.onCancelar,
  }) : super(key: key);

  @override
  State<BusquedaAvanzada> createState() => _BusquedaAvanzadaState();
}

class _BusquedaAvanzadaState extends State<BusquedaAvanzada> {
  final _terminoController = TextEditingController();
  final Set<String> _categoriasSeleccionadas = {};
  bool _mostrarFiltros = false;

  @override
  void dispose() {
    _terminoController.dispose();
    super.dispose();
  }

  void _realizarBusqueda() {
    widget.onBuscar(
      _terminoController.text,
      _categoriasSeleccionadas.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Campo de texto
                Expanded(
                  child: TextField(
                    controller: _terminoController,
                    decoration: InputDecoration(
                      hintText: 'Buscar notas...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _terminoController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _terminoController.clear();
                                _realizarBusqueda();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _realizarBusqueda(),
                  ),
                ),
                const SizedBox(width: 8),

                // Botón filtros
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    setState(() => _mostrarFiltros = !_mostrarFiltros);
                  },
                  tooltip: 'Filtros avanzados',
                ),

                // Botón cancelar
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onCancelar,
                  tooltip: 'Cerrar búsqueda',
                ),
              ],
            ),
          ),

          // Filtros expandibles
          if (_mostrarFiltros)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtrar por categoría:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.categoriasDisponibles.map((categoria) {
                      final seleccionada =
                          _categoriasSeleccionadas.contains(categoria);
                      return FilterChip(
                        label: Text(categoria),
                        selected: seleccionada,
                        onSelected: (seleccionado) {
                          setState(() {
                            if (seleccionado) {
                              _categoriasSeleccionadas.add(categoria);
                            } else {
                              _categoriasSeleccionadas.remove(categoria);
                            }
                          });
                          _realizarBusqueda();
                        },
                      );
                    }).toList(),
                  ),

                  if (_categoriasSeleccionadas.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.clear),
                        label: const Text('Limpiar filtros'),
                        onPressed: () {
                          setState(() {
                            _categoriasSeleccionadas.clear();
                          });
                          _realizarBusqueda();
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
