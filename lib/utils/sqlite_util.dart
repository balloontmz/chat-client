import 'dart:async';

import 'package:chat/utils/log_util.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteUtil {
  final Future<Database> database;

  factory SqliteUtil() => _getInstance();
  static SqliteUtil get instance => _getInstance();
  static SqliteUtil _instance;

  SqliteUtil._internal(this.database);

  static SqliteUtil _getInstance() {
    if (_instance == null) {
      _instance = new SqliteUtil._internal(_getDatabase());
    }
    return _instance;
  }

  ///获取chat 数据库
  static Future<Database> _getDatabase() async {
    return openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'chat.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        Log.i("常见聊天室列表");
        await db.execute("""
        CREATE TABLE chat_group
        (
            id INT NOT NULL PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
        )
        """);

        Log.i("常见消息列表");
        await db.execute("""
        CREATE TABLE chat_msg
        (
            id INT NOT NULL PRIMARY KEY,
            msg VARCHAR(255) NOT NULL,
            user_id INT NOT NULL,
            group_Id INT NOT NULL,
            type TINYINT NOT NULL,
        )
        """);

        Log.i("常见用户列表");
        await db.execute("""
        CREATE TABLE chat_user
        (
            id INT NOT NULL PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
        )
        """);

        Log.i("创建用户聊天室表");
        await db.execute("""
        CREATE TABLE chat_user_group
        (
            id INT NOT NULL PRIMARY KEY,
            user_id INT NOT NULL,
            group_id INT NOT NULL
        )
        """);
        return;
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
}
