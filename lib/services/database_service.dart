import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  static Database? _database;

  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {

    String path = join(
      await getDatabasesPath(),
      'feed_management.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''
        CREATE TABLE feeds(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          quantity INTEGER,
          supplier TEXT,
          price REAL
        )
        ''');

        await db.execute('''
        CREATE TABLE suppliers(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          phone TEXT,
          email TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE orders(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          feedName TEXT,
          quantity INTEGER,
          supplier TEXT,
          total REAL,
          orderDate TEXT,
          status TEXT
        )
        ''');
      },
    );
  }
}