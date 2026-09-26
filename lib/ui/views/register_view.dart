import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';
import 'package:pastillero_inteligente/ui/layouts/auth/auth_layout.dart';
import 'package:pastillero_inteligente/utils/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _especialidadCtrl = TextEditingController();
  final _cedulaCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final ok = await auth.register({
      'nombre': _nombreCtrl.text.trim(),
      'especialidad': _especialidadCtrl.text.trim(),
      'cedula': _cedulaCtrl.text.trim(),
      'email': _correoCtrl.text.trim(),
      'password': _passCtrl.text,
    });

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medico registrado correctamente'),
          backgroundColor: AppColors.primary,
        ),
      );
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Error al registrar'),
          backgroundColor: AppColors.alert,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return AuthLayout(
      titulo: 'Registro de Medico',
      subtitulo: 'Crea tu cuenta en Pastillero Inteligente',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) => Validators.requerido(v, campo: 'Nombre'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _especialidadCtrl,
              decoration: const InputDecoration(
                labelText: 'Especialidad',
                prefixIcon: Icon(Icons.medical_services_outlined),
              ),
              validator: (v) =>
                  Validators.requerido(v, campo: 'Especialidad'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cedulaCtrl,
              decoration: const InputDecoration(
                labelText: 'Cedula / Licencia medica',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (v) => Validators.requerido(v, campo: 'Cedula'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _correoCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electronico',
                hintText: 'ejemplo@dominio.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: Validators.correo,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contrasena',
                hintText: 'Minimo 8 caracteres',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: Validators.password,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: auth.isLoading ? null : _registrar,
              child: auth.isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Crear Cuenta'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text(
                'Ya tienes cuenta? Inicia sesion',
                style: TextStyle(color: AppColors.primaryDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}