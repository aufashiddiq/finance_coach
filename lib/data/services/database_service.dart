import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const String _databaseName = 'finance_coach.db';
  static const int _databaseVersion = 1;

  // Tables
  static const String tableTransactions = 'transactions';
  static const String tableBudgets = 'budgets';
  static const String tableGoals = 'goals';

  Database? _database;

  Future<void> initialize() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, _databaseName);

      _database = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
      );

      debugPrint('Database initialized successfully');
    } catch (e) {
      debugPrint('Database initialization error: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create transactions table
    await db.execute('''
      CREATE TABLE $tableTransactions (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        isExpense INTEGER NOT NULL
      )
    ''');

    // Create budgets table
    await db.execute('''
      CREATE TABLE $tableBudgets (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        period TEXT NOT NULL,
        startDate TEXT NOT NULL
      )
    ''');

    // Create goals table
    await db.execute('''
      CREATE TABLE $tableGoals (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        name TEXT NOT NULL,
        targetAmount REAL NOT NULL,
        currentAmount REAL NOT NULL,
        deadline TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }

  // Add methods for CRUD operations on tables
  // These methods will be implemented as needed
}
