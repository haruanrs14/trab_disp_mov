import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_routes.dart';
import 'app_theme.dart';
import 'providers/tarefa_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/list_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TarefaProvider()..init(),
      child: const GeekHouseApp(),
    ),
  );
}

class GeekHouseApp extends StatelessWidget {
  const GeekHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeekHouse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (_) => const WelcomeScreen(),
        AppRoutes.list: (_) => const ListScreen(),
        AppRoutes.detail: (_) => const DetailScreen(),
        AppRoutes.form: (_) => const FormScreen(),
      },
    );
  }
}
