import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../services/servicio_autenticacion.dart';
import '../utils/validadores.dart';

/// Pantalla para recuperar contraseña olvidada
/// Envía un enlace de reseteo al email del usuario
class PantallaRecuperarContraseña extends StatefulWidget {
  final String? emailInicial;

  const PantallaRecuperarContraseña({
    Key? key,
    this.emailInicial,
  }) : super(key: key);

  @override
  State<PantallaRecuperarContraseña> createState() =>
      _PantallaRecuperarContraseñaState();
}

class _PantallaRecuperarContraseñaState extends State<PantallaRecuperarContraseña> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _cargando = false;
  bool _enviado = false;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    if (widget.emailInicial != null) {
      _emailController.text = widget.emailInicial!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _enviarEnlaceRecuperacion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      final servicio = context.read<ServicioAutenticacion>();

      await servicio.enviarEnlaceRecuperacionContraseña(
        email: _emailController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _enviado = true;
          _cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        _mensajeError = _procesarError(e);
        _cargando = false;
      });
    }
  }

  String _procesarError(dynamic error) {
    final mensaje = error.toString();

    if (mensaje.contains('user-not-found')) {
      return 'No existe un usuario con este email.';
    } else if (mensaje.contains('invalid-email')) {
      return 'El email no es válido.';
    } else if (mensaje.contains('too-many-requests')) {
      return 'Demasiados intentos. Intenta más tarde.';
    }

    return 'Error al enviar el enlace de recuperación.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_enviado) ...[
                  // Contenido antes de enviar
                  Text(
                    'Recupera tu contraseña',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa tu email y te enviaremos un enlace para resetear tu contraseña.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Mensaje de error
                  if (_mensajeError != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _mensajeError!,
                              style: TextStyle(color: Colors.red[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_mensajeError != null) const SizedBox(height: 16),

                  // Formulario
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _emailController,
                      enabled: !_cargando,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'correo@ejemplo.com',
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: Validadores.validarEmail,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botón de envío
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _enviarEnlaceRecuperacion,
                      child: _cargando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Enviar Enlace'),
                    ),
                  ),
                ] else ...[
                  // Contenido después de enviar
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Icon(
                          Icons.mail_outline,
                          size: 80,
                          color: Colors.green[600],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '¡Enlace Enviado!',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Hemos enviado un enlace de recuperación a:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _emailController.text,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            'Revisa tu bandeja de entrada y sigue las instrucciones del enlace. '
                            'Si no ves el email, verifica tu carpeta de spam.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.blue[900],
                                    ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('Volver a Inicio de Sesión'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
