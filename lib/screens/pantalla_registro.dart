import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../services/servicio_autenticacion.dart';
import '../utils/validadores.dart';

/// Pantalla de registro de nuevos usuarios
/// Permite crear una cuenta con email, contraseña y nombre
class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({Key? key}) : super(key: key);

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nombreController = TextEditingController();
  final _contraseñaController = TextEditingController();
  final _confirmarContraseñaController = TextEditingController();

  bool _cargando = false;
  bool _mostrarContraseña = false;
  bool _mostrarConfirmacion = false;
  String? _mensajeError;

  // Estados de validación de contraseña
  bool _tiene6Caracteres = false;
  bool _tieneMayuscula = false;
  bool _tieneNumero = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nombreController.dispose();
    _contraseñaController.dispose();
    _confirmarContraseñaController.dispose();
    super.dispose();
  }

  void _actualizarValidacionContraseña(String contraseña) {
    setState(() {
      _tiene6Caracteres = contraseña.length >= 6;
      _tieneMayuscula = contraseña.contains(RegExp(r'[A-Z]'));
      _tieneNumero = contraseña.contains(RegExp(r'[0-9]'));
    });
  }

  Future<void> _registrarse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      final servicio = context.read<ServicioAutenticacion>();

      await servicio.registrarse(
        email: _emailController.text.trim(),
        contraseña: _contraseñaController.text,
        nombreMostrado: _nombreController.text.trim(),
      );

      if (!mounted) return;

      // Mostrar confirmación
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Registrado exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Navegar a inicio
      context.go('/');
    } catch (e) {
      setState(() {
        _mensajeError = _procesarErrorRegistro(e);
      });
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  String _procesarErrorRegistro(dynamic error) {
    final mensaje = error.toString();

    if (mensaje.contains('email-already-in-use')) {
      return 'Este email ya está registrado.';
    } else if (mensaje.contains('weak-password')) {
      return 'La contraseña es muy débil.';
    } else if (mensaje.contains('invalid-email')) {
      return 'El formato del email no es válido.';
    } else if (mensaje.contains('operation-not-allowed')) {
      return 'El registro está deshabilitado temporalmente.';
    }

    return 'Error al registrarse. Intenta de nuevo.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
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
                // Encabezado
                Text(
                  'Bienvenido a Notely',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Crea una cuenta para comenzar a organizar tus notas',
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
                  child: Column(
                    children: [
                      // Campo de nombre
                      TextFormField(
                        controller: _nombreController,
                        enabled: !_cargando,
                        decoration: InputDecoration(
                          hintText: 'Tu nombre',
                          labelText: 'Nombre',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: Validadores.validarNombreMostrado,
                      ),
                      const SizedBox(height: 16),

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
                        onChanged: _actualizarValidacionContraseña,
                        decoration: InputDecoration(
                          hintText: 'Al menos 6 caracteres',
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
                        validator: Validadores.validarContraseña,
                      ),
                      const SizedBox(height: 12),

                      // Indicadores de requisitos de contraseña
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Requisitos de contraseña:',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            _CriterioContraseña(
                              cumplido: _tiene6Caracteres,
                              texto: 'Mínimo 6 caracteres',
                            ),
                            _CriterioContraseña(
                              cumplido: _tieneMayuscula,
                              texto: 'Al menos 1 mayúscula',
                            ),
                            _CriterioContraseña(
                              cumplido: _tieneNumero,
                              texto: 'Al menos 1 número',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo de confirmación de contraseña
                      TextFormField(
                        controller: _confirmarContraseñaController,
                        enabled: !_cargando,
                        obscureText: !_mostrarConfirmacion,
                        decoration: InputDecoration(
                          hintText: 'Repite tu contraseña',
                          labelText: 'Confirmar Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _mostrarConfirmacion
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _mostrarConfirmacion = !_mostrarConfirmacion;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) =>
                            Validadores.validarConfirmacionContraseña(
                          _contraseñaController.text,
                          value,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botón de registro
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : _registrarse,
                    child: _cargando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Crear Cuenta'),
                  ),
                ),
                const SizedBox(height: 16),

                // Enlace a login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta?'),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: _cargando
                          ? null
                          : () {
                              context.pop();
                            },
                      child: const Text('Inicia sesión'),
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

/// Widget para mostrar un criterio de contraseña con checkbox
class _CriterioContraseña extends StatelessWidget {
  final bool cumplido;
  final String texto;

  const _CriterioContraseña({
    required this.cumplido,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          cumplido ? Icons.check_circle : Icons.circle_outlined,
          size: 16,
          color: cumplido ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cumplido ? Colors.green[700] : Colors.grey[600],
              ),
        ),
      ],
    );
  }
}
