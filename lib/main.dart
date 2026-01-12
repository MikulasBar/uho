import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uho/core/theme.dart';
import 'package:uho/providers/settings_provider.dart';
import 'package:uho/router/app_router.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider())
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
        theme: AppTheme.main,
      ),
    );
  }
}
