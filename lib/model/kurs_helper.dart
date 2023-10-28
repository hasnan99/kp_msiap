  import 'package:sqflite/sqflite.dart';
  import 'package:path/path.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:flutter/services.dart';
  import 'kurs.dart';

  class DatabaseHelper {
    static final DatabaseHelper _instance = DatabaseHelper._internal();

    factory DatabaseHelper() => _instance;

    DatabaseHelper._internal();

    static Database? _database;

    Future<Database> get database async {
      if (_database != null) return _database!;

      _database = await _initDatabase();
      return _database!;
    }

    Future<Database> _initDatabase() async {
      final documentsDirectory = await getDatabasesPath();
      final path = join(documentsDirectory, 'exchange_rates.db');

      return await openDatabase(path, version: 1, onCreate: _createDb);
    }

    Future<void> _createDb(Database db, int version) async {
      await db.execute('''
        CREATE TABLE exchange_rates(
          year INTEGER PRIMARY KEY,
          rate REAL
        )
      ''');
    }

    Future<void> insertExchangeRate(ExchangeRate exchangeRate) async {
      final db = await database;
      await db.insert('exchange_rates', exchangeRate.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<List<ExchangeRate>> getExchangeRates() async {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('exchange_rates');
      return List.generate(maps.length, (i) {
        return ExchangeRate.fromMap(maps[i]);
      });
    }

    Future<void> deleteExchangeRate(int year) async {
      final db = await database;
      await db.delete(
        'exchange_rates',
        where: 'year = ?',
        whereArgs: [year],
      );
    }

    Future<void> initializeDatabase() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isDatabaseInitialized = prefs.getBool('isDatabaseInitialized') ?? false;

      if (!isDatabaseInitialized) {
        final db = await database;
        final String initialDataSQL = await rootBundle.loadString('assets/kurs.sql');
        final List<String> sqlStatements = initialDataSQL.split(';');
        for (final statement in sqlStatements) {
          if (statement.trim().isNotEmpty) {
            try {
              await db.execute(statement);
              print("Database Berhasil");
            } catch (e) {
              print('Error executing SQL statement: $e');
            }
          }
        }
        await prefs.setBool('isDatabaseInitialized', true);
      }
    }


  }
