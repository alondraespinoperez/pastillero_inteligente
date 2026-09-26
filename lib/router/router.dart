import 'package:go_router/go_router.dart';

import 'package:pastillero_inteligente/ui/views/acerca_view.dart';
import 'package:pastillero_inteligente/ui/views/dashboard_view.dart';
import 'package:pastillero_inteligente/ui/views/login_view.dart';
import 'package:pastillero_inteligente/ui/views/paciente_detalle_view.dart';
import 'package:pastillero_inteligente/ui/views/paciente_registro_view.dart';
import 'package:pastillero_inteligente/ui/views/perfil_view.dart';
import 'package:pastillero_inteligente/ui/views/recordatorios_view.dart';
import 'package:pastillero_inteligente/ui/views/register_view.dart';
import 'package:pastillero_inteligente/ui/views/splash_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardView(),
    ),
    GoRoute(
      path: '/paciente/nuevo',
      builder: (context, state) => const PacienteRegistroView(),
    ),
    GoRoute(
      path: '/paciente/editar/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return PacienteRegistroView(pacienteId: id);
      },
    ),
    GoRoute(
      path: '/paciente/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return PacienteDetalleView(pacienteId: id);
      },
    ),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => const PerfilView(),
    ),
    GoRoute(
      path: '/acerca',
      builder: (context, state) => const AcercaView(),
    ),
    GoRoute(
      path: '/recordatorios',
      builder: (context, state) => const RecordatoriosView(),
    ),
  ],
);