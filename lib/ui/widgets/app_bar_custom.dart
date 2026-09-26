import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';
import 'package:pastillero_inteligente/utils/dialogs.dart';

class AppBarCustom extends StatefulWidget implements PreferredSizeWidget {
  final String titulo;

  const AppBarCustom({super.key, required this.titulo});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarCustom> createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {
  late Timer _timer;
  DateTime _ahora = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _ahora = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final hora = DateFormat('HH:mm:ss').format(_ahora);
    final fecha = DateFormat("EEE d MMM yyyy", 'es').format(_ahora);

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: SizedBox(
        height: kToolbarHeight,
        child: Stack(
          children: [
            // ─── IZQUIERDA: menú + título ───────────────
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Builder(
                      builder: (ctx) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () =>
                            Scaffold.of(ctx).openDrawer(),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.titulo,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── CENTRO: VITACODE clickeable ───────────
            Positioned.fill(
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => context.go('/dashboard'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: const Text(
                        'VITACODE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ─── DERECHA: reloj + doctor ────────────────
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Reloj SIN ícono, centrado
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            hora,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            fecha,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Menú doctor
                    PopupMenuButton<String>(
                      offset: const Offset(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 'perfil') {
                          context.go('/perfil');
                        } else if (value == 'logout') {
                          mostrarDialogoLogout(context);
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          enabled: false,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                auth.nombreMedico ?? 'Doctor',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                auth.correo ??
                                    'medico@vitacode.com',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                          value: 'perfil',
                          child: Row(
                            children: [
                              Icon(Icons.person_outline,
                                  size: 20,
                                  color: AppColors.textPrimary),
                              SizedBox(width: 10),
                              Text('Mi Perfil'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout,
                                  size: 20,
                                  color: AppColors.alert),
                              SizedBox(width: 10),
                              Text(
                                'Cerrar Sesion',
                                style: TextStyle(
                                    color: AppColors.alert),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white
                                  .withValues(alpha: 0.25),
                              child: Text(
                                (auth.nombreMedico ?? 'D')
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}