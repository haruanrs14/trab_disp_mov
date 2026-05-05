class Tarefa {
  final int? id;
  final String titulo;
  final String descricao;
  final DateTime dataPrevista;
  final bool importante;
  final bool realizada;
  final String tipoDispositivo;

  const Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataPrevista,
    required this.importante,
    required this.realizada,
    required this.tipoDispositivo,
  });

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      dataPrevista: DateTime.parse(map['dataPrevista'] as String),
      importante: (map['importante'] as int) == 1,
      realizada: (map['realizada'] as int) == 1,
      tipoDispositivo: map['tipoDispositivo'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'dataPrevista': dataPrevista.toIso8601String().substring(0, 10),
      'importante': importante ? 1 : 0,
      'realizada': realizada ? 1 : 0,
      'tipoDispositivo': tipoDispositivo,
    };
  }

  Tarefa copyWith({
    int? id,
    String? titulo,
    String? descricao,
    DateTime? dataPrevista,
    bool? importante,
    bool? realizada,
    String? tipoDispositivo,
  }) {
    return Tarefa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      dataPrevista: dataPrevista ?? this.dataPrevista,
      importante: importante ?? this.importante,
      realizada: realizada ?? this.realizada,
      tipoDispositivo: tipoDispositivo ?? this.tipoDispositivo,
    );
  }
}
