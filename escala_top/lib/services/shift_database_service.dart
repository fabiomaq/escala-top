import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/shift_model.dart';
import 'dart:async';

class ShiftDatabaseService {
  static final ShiftDatabaseService _instance = ShiftDatabaseService._internal();
  static Database? _database;

  factory ShiftDatabaseService() {
    return _instance;
  }

  ShiftDatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'escala_top.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shifts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startDate INTEGER NOT NULL,
        endDate INTEGER NOT NULL,
        shiftPattern TEXT NOT NULL,
        type TEXT NOT NULL,
        notes TEXT
      )
    ''');
  }

  Future<int> insertShift(Shift shift) async {
    final db = await database;
    return await db.insert(
      'shifts',
      shift.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Shift>> getShifts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('shifts');
    return List.generate(maps.length, (i) {
      return Shift.fromMap(maps[i]);
    });
  }

  Future<List<Shift>> getShiftsByMonth(int year, int month) async {
    final db = await database;
    
    // Calcular o primeiro e último dia do mês
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'shifts',
      where: 'startDate >= ? AND startDate <= ?',
      whereArgs: [
        firstDayOfMonth.millisecondsSinceEpoch,
        lastDayOfMonth.millisecondsSinceEpoch
      ],
    );
    
    return List.generate(maps.length, (i) {
      return Shift.fromMap(maps[i]);
    });
  }

  Future<Shift?> getShiftByDate(DateTime date) async {
    final db = await database;
    
    // Início e fim do dia
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'shifts',
      where: 'startDate >= ? AND startDate <= ?',
      whereArgs: [
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch
      ],
    );
    
    if (maps.isNotEmpty) {
      return Shift.fromMap(maps.first);
    }
    
    return null;
  }

  Future<int> updateShift(Shift shift) async {
    final db = await database;
    return await db.update(
      'shifts',
      shift.toMap(),
      where: 'id = ?',
      whereArgs: [shift.id],
    );
  }

  Future<int> deleteShift(int id) async {
    final db = await database;
    return await db.delete(
      'shifts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para limpar histórico antigo (manter apenas 1 ano)
  Future<int> cleanOldHistory() async {
    final db = await database;
    final oneYearAgo = DateTime.now().subtract(Duration(days: 365));
    
    return await db.delete(
      'shifts',
      where: 'startDate < ?',
      whereArgs: [oneYearAgo.millisecondsSinceEpoch],
    );
  }
}
