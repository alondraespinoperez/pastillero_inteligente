import 'package:go_router/go_router.dart';

import 'package:pastillero_inteligente/ui/views/dashboard_view.dart';
import 'package:pastillero_inteligente/ui/views/login_view.dart';
import 'package:pastillero_inteligente/ui/views/register_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
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
  ],
);