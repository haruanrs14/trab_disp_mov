import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/tarefa.dart';

class TarefaProvider extends ChangeNotifier {
  List<Tarefa> _tarefas = [];

  List<Tarefa> get todas => _tarefas;

  List<Tarefa> get urgentes =>
      _tarefas.where((t) => t.importante && !t.realizada).toList();

  List<Tarefa> get concluidas => _tarefas.where((t) => t.realizada).toList();

  List<Tarefa> get atrasadas {
    final hoje = DateTime.now();
    final hoje0 = DateTime(hoje.year, hoje.month, hoje.day);
    return _tarefas
        .where((t) => !t.realizada && t.dataPrevista.isBefore(hoje0))
        .toList();
  }

  Tarefa? get proximaTarefa {
    final pendentes = _tarefas.where((t) => !t.realizada).toList();
    if (pendentes.isEmpty) return null;
    pendentes.sort((a, b) => a.dataPrevista.compareTo(b.dataPrevista));
    return pendentes.first;
  }

  Future<void> init() async {
    _tarefas = await DatabaseHelper.instance.getTarefas();
    notifyListeners();
  }

  Future<void> adicionar(Tarefa tarefa) async {
    final id = await DatabaseHelper.instance.insertTarefa(tarefa);
    _tarefas.add(tarefa.copyWith(id: id));
    _tarefas.sort((a, b) => a.dataPrevista.compareTo(b.dataPrevista));
    notifyListeners();
  }

  Future<void> atualizar(Tarefa tarefa) async {
    await DatabaseHelper.instance.updateTarefa(tarefa);
    final index = _tarefas.indexWhere((t) => t.id == tarefa.id);
    if (index != -1) {
      _tarefas[index] = tarefa;
      _tarefas.sort((a, b) => a.dataPrevista.compareTo(b.dataPrevista));
      notifyListeners();
    }
  }

  Future<void> marcarConcluida(Tarefa tarefa) async {
    await atualizar(tarefa.copyWith(realizada: true));
  }

  Future<void> deletar(int id) async {
    await DatabaseHelper.instance.deleteTarefa(id);
    _tarefas.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
