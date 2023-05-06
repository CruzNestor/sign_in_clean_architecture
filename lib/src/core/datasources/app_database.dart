import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';


class AppDatabase {
  static const String _databaseName = 'myapp.db';
  static const int _databaseVersion = 1;
  
  static Future<Database> open() async {
    final path = await _getPath();
    return await openDatabase(path, version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE)'''
    );
  }

  static Future<String> _getPath() async{
    String path = p.join(await getDatabasesPath(), _databaseName);
    return path;
  }

} 