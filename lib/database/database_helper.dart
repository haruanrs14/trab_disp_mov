import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tarefa.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'geekhouse.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        dataPrevista TEXT NOT NULL,
        importante INTEGER NOT NULL DEFAULT 0,
        realizada INTEGER NOT NULL DEFAULT 0,
        tipoDispositivo TEXT NOT NULL
      )
    ''');
  }

  Future<List<Tarefa>> getTarefas() async {
    final database = await db;
    final maps = await database.query('tarefas', orderBy: 'dataPrevista ASC');
    return maps.map(Tarefa.fromMap).toList();
  }

  Future<int> insertTarefa(Tarefa tarefa) async {
    final database = await db;
    return database.insert('tarefas', tarefa.toMap());
  }

  Future<int> updateTarefa(Tarefa tarefa) async {
    final database = await db;
    return database.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<int> deleteTarefa(int id) async {
    final database = await db;
    return database.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}
