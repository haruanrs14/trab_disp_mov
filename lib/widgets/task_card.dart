import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarefa.dart';
import '../app_theme.dart';
import 'device_badge.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.tarefa, required this.onTap, this.onDismissed});

  final Tarefa tarefa;
  final VoidCallback onTap;
  final VoidCallback? onDismissed;

  bool get _atrasada {
    final hoje = DateTime.now();
    final hoje0 = DateTime(hoje.year, hoje.month, hoje.day);
    return !tarefa.realizada && tarefa.dataPrevista.isBefore(hoje0);
  }

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tarefa.titulo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: tarefa.realizada ? TextDecoration.lineThrough : null,
                        color: tarefa.realizada ? Colors.grey : null,
                      ),
                    ),
                  ),
                  if (tarefa.importante && !tarefa.realizada)
                    const Icon(Icons.priority_high, color: AppTheme.primaryColor, size: 20),
                  if (tarefa.realizada)
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  if (_atrasada)
                    const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  DeviceBadge(tipo: tarefa.tipoDispositivo),
                  const Spacer(),
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: _atrasada ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(tarefa.dataPrevista),
                    style: TextStyle(
                      fontSize: 13,
                      color: _atrasada ? Colors.orange : Colors.grey[600],
                      fontWeight: _atrasada ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (onDismissed == null) return card;

    return Dismissible(
      key: ValueKey(tarefa.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
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
      },
      onDismissed: (_) => onDismissed!(),
      child: card,
    );
  }
}
