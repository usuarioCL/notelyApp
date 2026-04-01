import 'package:flutter/material.dart';

/// Widget para barra de herramientas de formato de texto
/// Proporciona botones para: bold, itálica, subrayado, links
class BarraFormato extends StatelessWidget {
  final bool negrita;
  final bool cursiva;
  final bool subrayado;
  final VoidCallback onNegritaToggle;
  final VoidCallback onCursivaToggle;
  final VoidCallback onSubrayadoToggle;
  final VoidCallback onLinkTap;

  const BarraFormato({
    Key? key,
    required this.negrita,
    required this.cursiva,
    required this.subrayado,
    required this.onNegritaToggle,
    required this.onCursivaToggle,
    required this.onSubrayadoToggle,
    required this.onLinkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              // Botón Negrita
              _BotoFormato(
                icono: Icons.format_bold,
                tooltip: 'Negrita (Ctrl+B)',
                seleccionado: negrita,
                onTap: onNegritaToggle,
              ),
              const SizedBox(width: 8),

              // Botón Cursiva
              _BotoFormato(
                icono: Icons.format_italic,
                tooltip: 'Cursiva (Ctrl+I)',
                seleccionado: cursiva,
                onTap: onCursivaToggle,
              ),
              const SizedBox(width: 8),

              // Botón Subrayado
              _BotoFormato(
                icono: Icons.format_underlined,
                tooltip: 'Subrayado (Ctrl+U)',
                seleccionado: subrayado,
                onTap: onSubrayadoToggle,
              ),
              const SizedBox(width: 12),

              // Separador
              Container(
                width: 1,
                height: 24,
                color: Colors.grey[400],
              ),
              const SizedBox(width: 12),

              // Botón Link
              _BotoFormato(
                icono: Icons.link,
                tooltip: 'Insertar enlace',
                seleccionado: false,
                onTap: onLinkTap,
              ),
              const SizedBox(width: 8),

              // Botón Listas
              _BotoFormato(
                icono: Icons.format_list_bulleted,
                tooltip: 'Lista con viñetas',
                seleccionado: false,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Próximamente')),
                  );
                },
              ),
              const SizedBox(width: 8),

              // Botón Citas
              _BotoFormato(
                icono: Icons.format_quote,
                tooltip: 'Cita',
                seleccionado: false,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Próximamente')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget para botón individual de formato
class _BotoFormato extends StatelessWidget {
  final IconData icono;
  final String tooltip;
  final bool seleccionado;
  final VoidCallback onTap;

  const _BotoFormato({
    required this.icono,
    required this.tooltip,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: seleccionado ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icono,
              size: 20,
              color: seleccionado ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
