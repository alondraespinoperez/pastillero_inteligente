import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/router/router.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';

void main() {
  runApp(const PastilleroInteligenteApp());
}

class PastilleroInteligenteApp extends StatelessWidget {
  const PastilleroInteligenteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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