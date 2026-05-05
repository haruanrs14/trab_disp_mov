import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_routes.dart';
import '../providers/tarefa_provider.dart';
import '../widgets/task_card.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ordens de Serviço'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Todas'),
              Tab(text: 'Urgentes'),
              Tab(text: 'Concluídas'),
              Tab(text: 'Atrasadas'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TarefaList(tipo: _ListTipo.todas),
            _TarefaList(tipo: _ListTipo.urgentes),
            _TarefaList(tipo: _ListTipo.concluidas),
            _TarefaList(tipo: _ListTipo.atrasadas),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.form),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

enum _ListTipo { todas, urgentes, concluidas, atrasadas }

class _TarefaList extends StatelessWidget {
  const _TarefaList({required this.tipo});

  final _ListTipo tipo;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TarefaProvider>();

    final tarefas = switch (tipo) {
      _ListTipo.todas => provider.todas,
      _ListTipo.urgentes => provider.urgentes,
      _ListTipo.concluidas => provider.concluidas,
      _ListTipo.atrasadas => provider.atrasadas,
    };

    if (tarefas.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('Nenhuma OS aqui.', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        final tarefa = tarefas[index];
        return TaskCard(
          tarefa: tarefa,
          onTap: () => Navigator.pushNamed(context, AppRoutes.detail, arguments: tarefa),
          onDismissed: () => context.read<TarefaProvider>().deletar(tarefa.id!),
        );
      },
    );
  }
}
