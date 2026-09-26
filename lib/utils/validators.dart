class Validators {
  static String? correo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu correo';
    }

    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.com$');

    if (!regex.hasMatch(value.trim())) {
      return 'Correo invalido (debe terminar en .com)';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu contrasena';
    }

    if (value.length < 8) {
      return 'Minimo 8 caracteres';
    }

    return null;
  }

  static String? requerido(String? value, {String campo = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$campo es requerido';
    }
    return null;
  }
}