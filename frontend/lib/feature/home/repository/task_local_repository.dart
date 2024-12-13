import 'package:frontend/model/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalRepository {
  String tableName = 'tasks';
  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
CREATE TABLE $tableName(
        id TEXT PRIMARY KEY,
        uid TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        hexColor TEXT NOT NULL,
        dueAt TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        isSynced INTEGER NOT NULL
)
''');
      },
    );
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [task.id]);
    db.insert(
      tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();

    for (final task in tasks) {
      batch.insert(
        tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(tableName);
    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (final elemet in result) {
        tasks.add(TaskModel.fromMap(elemet));
      }
      return tasks;
    }
    return [];
  }

  Future<List<TaskModel>> getUnsyncedTasks() async {
    final db = await database;
    final result =
        await db.query(tableName, where: 'isSynced = ?', whereArgs: [0]);
    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (final elemet in result) {
        tasks.add(TaskModel.fromMap(elemet));
      }
      return tasks;
    }
    return [];
  }

  Future<void> updateRowValue(String id, int newValue) async {
    final db = await database;
    await db.update(tableName, {"isSynced": newValue},
        where: 'id = ?', whereArgs: [id]);
  }
}
