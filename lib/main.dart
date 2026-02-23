import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/providers/settings_provider.dart';
import 'package:uho/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://nswrjvuucaieszkfqsoi.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5zd3JqdnV1Y2FpZXN6a2Zxc29pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgyNDEzNDksImV4cCI6MjA4MzgxNzM0OX0.7tB24ZhvDLkuMt_SJTQobGQyLzQiZj2jPiZotfR6sls", 
  );

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
        theme: UhoTheme.main,
      ),
    );
  }
}
