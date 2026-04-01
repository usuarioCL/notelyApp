/// Utilidades de validación para formularios
class Validadores {
  /// Valida que el email tenga formato correcto
  /// Retorna un mensaje de error o null si es válido
  static String? validarEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'El email es requerido';
    }

    // Expresión regular básica para email
    final regexEmail = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!regexEmail.hasMatch(email)) {
      return 'Por favor, ingresa un email válido';
    }

    return null;
  }

  /// Valida que la contraseña cumpla los requisitos mínimos
  /// Retorna un mensaje de error o null si es válida
  static String? validarContraseña(String? contraseña) {
    if (contraseña == null || contraseña.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (contraseña.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    // Verificar que tenga al menos una mayúscula
    if (!contraseña.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una mayúscula';
    }

    // Verificar que tenga al menos un número
    if (!contraseña.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un número';
    }

    return null;
  }

  /// Valida que la contraseña y su confirmación coincidan
  static String? validarConfirmacionContraseña(
    String? contraseña,
    String? confirmacion,
  ) {
    if (confirmacion == null || confirmacion.isEmpty) {
      return 'Debes confirmar la contraseña';
    }

    if (contraseña != confirmacion) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  /// Valida que el nombre mostrado no esté vacío
  static String? validarNombreMostrado(String? nombre) {
    if (nombre == null || nombre.isEmpty) {
      return 'El nombre es requerido';
    }

    if (nombre.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    if (nombre.length > 50) {
      return 'El nombre no puede exceder 50 caracteres';
    }

    return null;
  }
}
