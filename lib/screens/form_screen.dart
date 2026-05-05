import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/tarefa.dart';
import '../providers/tarefa_provider.dart';
import '../widgets/custom_button.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  DateTime? _dataPrevista;
  bool _importante = false;
  String _tipoDispositivo = 'Celular';
  Tarefa? _tarefaOriginal;
  bool _initialized = false;

  static const _tipos = ['Videogame', 'Controle', 'Celular', 'Computador'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _tarefaOriginal = ModalRoute.of(context)?.settings.arguments as Tarefa?;
      if (_tarefaOriginal != null) {
        _tituloController.text = _tarefaOriginal!.titulo;
        _descricaoController.text = _tarefaOriginal!.descricao;
        _dataPrevista = _tarefaOriginal!.dataPrevista;
        _importante = _tarefaOriginal!.importante;
        _tipoDispositivo = _tarefaOriginal!.tipoDispositivo;
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataPrevista ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _dataPrevista = picked);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dataPrevista == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data prevista.')),
      );
      return;
    }

    final provider = context.read<TarefaProvider>();

    final tarefa = Tarefa(
      id: _tarefaOriginal?.id,
      titulo: _tituloController.text.trim(),
      descricao: _descricaoController.text.trim(),
      dataPrevista: _dataPrevista!,
      importante: _importante,
      realizada: _tarefaOriginal?.realizada ?? false,
      tipoDispositivo: _tipoDispositivo,
    );

    if (_tarefaOriginal == null) {
      await provider.adicionar(tarefa);
    } else {
      await provider.atualizar(tarefa);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _tarefaOriginal != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar OS' : 'Nova OS')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o título.' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição do problema', border: OutlineInputBorder()),
              maxLines: 3,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a descrição.' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _tipoDispositivo,
              decoration: const InputDecoration(labelText: 'Tipo de dispositivo', border: OutlineInputBorder()),
              items: _tipos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _tipoDispositivo = v!),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _dataPrevista == null
                    ? 'Selecionar data prevista'
                    : DateFormat('dd/MM/yyyy').format(_dataPrevista!),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Urgente / Importante'),
              subtitle: const Text('Marcará esta OS como prioritária'),
              value: _importante,
              onChanged: (v) => setState(() => _importante = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: isEditing ? 'Salvar alterações' : 'Criar OS',
              icon: isEditing ? Icons.save : Icons.add,
              onPressed: _salvar,
            ),
          ],
        ),
      ),
    );
  }
}
