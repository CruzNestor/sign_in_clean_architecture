import 'package:sqflite/sqflite.dart';

import '../../../../core/datasources/app_database.dart';

typedef MyResponse = Map<String, dynamic>;

abstract class AuthDatabase {
  Future<MyResponse> getUser({required int id});
  Future<MyResponse> signIn({required Map<String, dynamic> data});
  Future<MyResponse> signUp({required Map<String, dynamic> data});
  Future<MyResponse> validateEmail({required Map<String, dynamic> data});
  Future<MyResponse> validateUsername({required Map<String, dynamic> data});
}

class AuthDatabaseImpl implements AuthDatabase {
  static const String _tableName = 'user';

  @override
  Future<MyResponse> getUser({required int id}) async {
    Database db = await AppDatabase.open();
    final result = await db.query(_tableName,
      columns: ['id', 'email', 'username'],
      where: 'id = ?',
      whereArgs: [id]
    );
    return result.isNotEmpty 
      ? {'status': 'success', 'data': result.first} 
      : {'status': 'fail', 'detail': 'Incorrect user or password.'};
  }

  @override
  Future<MyResponse> signIn({required Map<String, dynamic> data}) async {
    Database db = await AppDatabase.open();
    final result = await db.query(_tableName,
      columns: ['id', 'email', 'username'],
      where: 'password = ? AND (username = ? OR email = ?)',
      whereArgs: [data['password'], data['username'], data['username']],
      limit: 1
    );
    return result.isNotEmpty 
      ? {'status': 'success', 'user_id': result.first['id']} 
      : {'status': 'fail', 'detail': 'Incorrect user or password.'};
  }

  @override
  Future<MyResponse> signUp({required Map<String, dynamic> data}) async {
    final db = await AppDatabase.open();
    final email = data['email'].trim().toLowerCase();
    final username = data['username'].trim().toLowerCase();

    String query = "INSERT INTO $_tableName(email, username, password) VALUES(?,?,?)";
    int id = await db.rawInsert(query, [email, username, data['password']]);
    await db.close();

    return id > 0 
      ? {'status': 'success', 'inserted_id': id}
      : {'status': 'fail'};
  }

  @override
  Future<MyResponse> validateEmail({required Map<String, dynamic> data}) async {
    final db = await AppDatabase.open();
    final email = data['email'].trim().toLowerCase();
    final result = await db.query(_tableName,
      columns: ['id'],
      where: 'email = ?', 
      whereArgs: [email]
    );
    await db.close();
    return result.isEmpty 
      ? {'status': 'success'} 
      : {'status': 'fail', 'detail': 'The email already exists.'};
  }

  @override
  Future<MyResponse> validateUsername({required Map<String, dynamic> data}) async {
    final db = await AppDatabase.open();
    final username = data['username'].trim().toLowerCase();
    final result = await db.query(_tableName,
      columns: ['id'],
      where: 'username = ?', 
      whereArgs: [username]
    );
    await db.close();
    return result.isEmpty 
      ? {'status': 'success'} 
      : {'status': 'fail', 'detail': 'The username already exists.'};
  }

} 