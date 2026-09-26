import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';

Future<void> mostrarDialogoLogout(BuildContext context) async {
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text('Cerrar Sesion'),
      content: const Text('¿Seguro que deseas cerrar sesion?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.alert,
            minimumSize: const Size(100, 40),
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );

  if (confirmar == true && context.mounted) {
    await context.read<AuthProvider>().logout();
    if (context.mounted) context.go('/login');
  }
}