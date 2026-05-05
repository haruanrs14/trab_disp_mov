import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../app_routes.dart';
import '../app_theme.dart';
import '../models/tarefa.dart';
import '../providers/tarefa_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/device_badge.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tarefa = ModalRoute.of(context)!.settings.arguments as Tarefa;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da OS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.form, arguments: tarefa),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Excluir OS'),
                  content: Text('Deseja excluir "${tarefa.titulo}"?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                await context.read<TarefaProvider>().deletar(tarefa.id!);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoChip(label: 'OS #${tarefa.id}'),
            const SizedBox(height: 16),
            Text(tarefa.titulo, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            DeviceBadge(tipo: tarefa.tipoDispositivo),
            const SizedBox(height: 20),
            _InfoRow(icon: Icons.description_outlined, label: 'Descrição', value: tarefa.descricao),
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Data prevista',
              value: DateFormat('dd/MM/yyyy').format(tarefa.dataPrevista),
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: tarefa.importante ? Icons.priority_high : Icons.low_priority,
              label: 'Urgente',
              value: tarefa.importante ? 'Sim' : 'Não',
              valueColor: tarefa.importante ? AppTheme.primaryColor : null,
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: tarefa.realizada ? Icons.check_circle : Icons.pending_outlined,
              label: 'Status',
              value: tarefa.realizada ? 'Concluída' : 'Pendente',
              valueColor: tarefa.realizada ? Colors.green : Colors.orange,
            ),
            const Spacer(),
            if (!tarefa.realizada)
              CustomButton(
                label: 'Marcar como Concluído',
                icon: Icons.check,
                color: Colors.green,
                onPressed: () async {
                  await context.read<TarefaProvider>().marcarConcluida(tarefa);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.valueColor});

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}
