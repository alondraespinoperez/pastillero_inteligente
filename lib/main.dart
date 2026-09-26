import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/providers/paciente_provider.dart';
import 'package:pastillero_inteligente/router/router.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(const PastilleroInteligenteApp());
}

class PastilleroInteligenteApp extends StatelessWidget {
  const PastilleroInteligenteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PacienteProvider()),
      ],
      child: MaterialApp.router(
        title: 'Pastillero Inteligente - VitaCode',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}