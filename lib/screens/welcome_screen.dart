import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../app_routes.dart';
import '../app_theme.dart';
import '../providers/tarefa_provider.dart';
import '../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TarefaProvider>();
    final proxima = provider.proximaTarefa;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Image.asset('assets/images/logo.png', height: 110),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'GeekHouse',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Assistência Técnica',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              if (proxima != null) ...[
                const Text(
                  'Próxima OS',
                  style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proxima.titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd/MM/yyyy').format(proxima.dataPrevista),
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.devices, color: Colors.white70, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            proxima.tipoDispositivo,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Nenhuma OS pendente.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ],
              const Spacer(),
              CustomButton(
                label: 'Ver todas as OS',
                icon: Icons.list_alt,
                color: Colors.white,
                foregroundColor: const Color.fromARGB(255, 19, 19, 19),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.list),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
