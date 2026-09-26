import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';
import 'package:pastillero_inteligente/utils/dialogs.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final location = GoRouterState.of(context).uri.toString();

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    auth.nombreMedico ?? 'Doctor',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'VitaCode Medical',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _item(
              context,
              icon: Icons.dashboard_outlined,
              label: 'Panel Principal',
              route: '/dashboard',
              active: location == '/dashboard',
            ),
            _item(
              context,
              icon: Icons.person_add_alt_1,
              label: 'Nuevo Paciente',
              route: '/paciente/nuevo',
              active: location == '/paciente/nuevo',
            ),
            _item(
              context,
              icon: Icons.notifications_outlined,
              label: 'Recordatorios',
              route: '/recordatorios',
              active: location == '/recordatorios',
            ),
            _item(
              context,
              icon: Icons.person_outline,
              label: 'Mi Perfil',
              route: '/perfil',
              active: location == '/perfil',
            ),
            _item(
              context,
              icon: Icons.info_outline,
              label: 'Acerca de',
              route: '/acerca',
              active: location == '/acerca',
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.alert),
              title: const Text(
                'Cerrar Sesion',
                style: TextStyle(color: AppColors.alert),
              ),
              onTap: () => mostrarDialogoLogout(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool active,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: active ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: active ? AppColors.primary : AppColors.textPrimary,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: active,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}