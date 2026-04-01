import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../services/servicio_autenticacion.dart';
import '../utils/validadores.dart';

/// Pantalla de inicio de sesión
/// Permite al usuario autenticarse con email y contraseña
class PantallaLogin extends StatefulWidget {
  const PantallaLogin({Key? key}) : super(key: key);

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _contraseñaController = TextEditingController();

  bool _cargando = false;
  bool _mostrarContraseña = false;
  String? _mensajeError;

  @override
  void dispose() {
    _emailController.dispose();
    _contraseñaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      final servicio = context.read<ServicioAutenticacion>();

      await servicio.iniciarSesion(
        email: _emailController.text.trim(),
        contraseña: _contraseñaController.text,
      );

      if (!mounted) return;

      // Navegar a la pantalla de inicio
      context.go('/');
    } catch (e) {
      setState(() {
        _mensajeError = _procesarErrorInicio(e);
      });
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  String _procesarErrorInicio(dynamic error) {
    final mensaje = error.toString();

    if (mensaje.contains('user-not-found')) {
      return 'Usuario no encontrado. Verifica tu email.';
    } else if (mensaje.contains('wrong-password')) {
      return 'Contraseña incorrecta. Intenta de nuevo.';
    } else if (mensaje.contains('too-many-requests')) {
      return 'Demasiados intentos fallidos. Intenta más tarde.';
    }

    return 'Error al iniciar sesión. Intenta de nuevo.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Encabezado
                Icon(
                  Icons.note_outlined,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'Notely',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Organiza tus notas y tus ideas',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 48),

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
                  child: Column(
                    children: [
                      // Campo de email
                      TextFormField(
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
                      const SizedBox(height: 16),

                      // Campo de contraseña
                      TextFormField(
                        controller: _contraseñaController,
                        enabled: !_cargando,
                        obscureText: !_mostrarContraseña,
                        decoration: InputDecoration(
                          hintText: 'Tu contraseña',
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _mostrarContraseña
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _mostrarContraseña = !_mostrarContraseña;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La contraseña es requerida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      // Enlace "Olvidé mi contraseña"
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _cargando
                              ? null
                              : () {
                                  context.push('/recuperar-contraseña',
                                      extra: _emailController.text);
                                },
                          child: const Text('¿Olvidaste tu contraseña?'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botón de iniciar sesión
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : _iniciarSesion,
                    child: _cargando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Iniciar Sesión'),
                  ),
                ),
                const SizedBox(height: 16),

                // Enlace a registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta?'),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: _cargando
                          ? null
                          : () {
                              context.push('/registro');
                            },
                      child: const Text('Regístrate aquí'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
