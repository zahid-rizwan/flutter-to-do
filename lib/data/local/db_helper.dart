import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();
  static final String TABLE_USER = "users";
  static final String COLUMN_USER_USER_ID = "user_id";
  static final String COLUMN_USER_USER_NAME = "username";
  static final String COLUMN_USER_USER_PASSWORD = "password";
  static final String COLUMN_USER_USER_EMAIL = "email";
  static final String TABLE_TASK = "tasks";
  static final String COLUMN_TASK_TASK_ID = "task_id";
  static final String COLUMN_TASK_USER_ID = "user_id";
  static final String COLUMN_TODO_TASK_NAME = "task_name";
  static final String COLUMN_TODO_TASK_DESCRIPTION = "task_description";
  static final String COLUMN_TODO_TASK_STATUS = "task_status";
  static final String COLUMN_TODO_TASK_CREATED_AT = "created_at";
  static final String COLUMN_TODO_TASK_COMPLETION_DATE = "completion_date";

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationCacheDirectory();
    String dbPath = join(appDir.path, "noteDB.db");

    return await openDatabase(dbPath, onCreate: (db, version) async {
      // Log creating the user table
      print("Creating user table...");
      await db.execute("CREATE TABLE IF NOT EXISTS $TABLE_USER ("
          "$COLUMN_USER_USER_ID INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$COLUMN_USER_USER_NAME TEXT, "
          "$COLUMN_USER_USER_PASSWORD TEXT, "
          "$COLUMN_USER_USER_EMAIL TEXT)");

      // Check if user table is created
      var checkUserTable = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='$TABLE_USER'");
      print('User table exists: ${checkUserTable.isNotEmpty}');

      // Log creating the task table
      print("Creating task table...");
      await db.execute("CREATE TABLE IF NOT EXISTS $TABLE_TASK ("
          "$COLUMN_TASK_TASK_ID INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$COLUMN_TASK_USER_ID INTEGER, "
          "$COLUMN_TODO_TASK_DESCRIPTION TEXT, "
          "$COLUMN_TODO_TASK_NAME TEXT, "
          "$COLUMN_TODO_TASK_STATUS TEXT, "
          "$COLUMN_TODO_TASK_CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
          "$COLUMN_TODO_TASK_COMPLETION_DATE DATE, "
          "FOREIGN KEY ($COLUMN_TASK_USER_ID) REFERENCES $TABLE_USER($COLUMN_USER_USER_ID) ON DELETE CASCADE)");

      // Check if task table is created
      var checkTaskTable = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='$TABLE_TASK'");
      print('Task table exists: ${checkTaskTable.isNotEmpty}');
    }, version: 1);
  }


  Future<bool> addUser(
      {required String username,
      required String password,
      required String email}) async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_USER, {
      COLUMN_USER_USER_NAME: username,
      COLUMN_USER_USER_PASSWORD: password,
      COLUMN_USER_USER_EMAIL: email
    });
    return rowsEffected > 0;
  }
  Future<List<Map<String,dynamic>>> getAllUser() async {
    var db = await getDB();
    return await db.query(TABLE_USER);
  }
  Future<void> logDatabaseSchema() async {
    var db = await getDB();
    var result = await db.rawQuery('SELECT name, sql FROM sqlite_master WHERE type="table"');
    result.forEach((row) {
      print('Table: ${row['name']}, SQL: ${row['sql']}');
    });
  }
  Future<bool> addTask({
    required int userId,
    required String taskName,
    required String taskDescription,
    required String taskStatus,
    String? completionDate,
  }) async {
    var db = await getDB();

    int rowsAffected = await db.insert(TABLE_TASK, {
      COLUMN_TASK_USER_ID: userId,
      COLUMN_TODO_TASK_NAME: taskName,
      COLUMN_TODO_TASK_DESCRIPTION: taskDescription,
      COLUMN_TODO_TASK_STATUS: taskStatus,
      COLUMN_TODO_TASK_COMPLETION_DATE: completionDate, // optional
    });

    return rowsAffected > 0;
  }
  Future<List<Map<String, dynamic>>> getAllTasks() async {
    var db = await getDB();
    return await db.query(TABLE_TASK); // Query to get all tasks from the 'tasks' table
  }
  Future<Map<String, dynamic>?> getUserByEmailAndPassword(String email, String password) async {
    final db = await getDB();
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first; // Return the first match.
    }
    return null; // No match found.
  }
  Future<List<Map<String, dynamic>>> fetchTasksByUserId(int userId) async {
    final db = await getDB();
    return await db.query('tasks', where: 'user_id = ?', whereArgs: [userId]);
  }
  Future<bool> deleteTask({required int taskId}) async {
    var db=await getDB();
    int rowEffected=await db.delete(TABLE_TASK,where: "$COLUMN_TASK_TASK_ID = ?" ,whereArgs: ["$taskId"]);
    return rowEffected>0 ;
  }
  Future<bool> updateTask({required String name,required String desc,required String date,required int taskId}) async {
    var db=await getDB();
    int rowEffected=await db.update(TABLE_TASK, {COLUMN_TODO_TASK_NAME:name,COLUMN_TODO_TASK_DESCRIPTION:desc,COLUMN_TODO_TASK_COMPLETION_DATE:date},where: "$COLUMN_TASK_TASK_ID= $taskId");
    return rowEffected>0;
  }

}
