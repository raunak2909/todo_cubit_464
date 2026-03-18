import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_cubit_464/todo_model.dart';

class DBHelper {
  DBHelper._();

  static DBHelper getInstance() => DBHelper._();

  Database? mDB;

  ///DB NAMES
  static String DB_NAME = "todoDB.db";
  static String TABLE_TODO = "todo";

  static String COLUMN_TODO_ID = "t_id";
  static String COLUMN_TODO_TITLE = "t_title";
  static String COLUMN_TODO_REMARK = "t_remark";
  static String COLUMN_TODO_IS_COMPLETED = "t_is_completed";
  static String COLUMN_TODO_CREATED_AT = "t_created_at";

  Future<Database> initDB() async {
    mDB ??= await openDB();
    return mDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, DB_NAME);

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "create table $TABLE_TODO ( $COLUMN_TODO_ID integer primary key autoincrement, $COLUMN_TODO_TITLE text, $COLUMN_TODO_REMARK text, $COLUMN_TODO_IS_COMPLETED integer, $COLUMN_TODO_CREATED_AT text )",
        );
      },
    );
  }

  ///queries
  ///add todo
  Future<bool> addTodo({required TodoModel newTodo}) async {
    var db = await initDB();
    int rowsEffected = await db.insert(TABLE_TODO, newTodo.toMap());
    return rowsEffected > 0;
  }

  Future<List<TodoModel>> fetchAllTodo() async {
    var db = await initDB();
    List<TodoModel> mTodo = [];

    List<Map<String, dynamic>> mData = await db.query(TABLE_TODO);

    for (Map<String, dynamic> eachItem in mData) {
      mTodo.add(TodoModel.fromMap(eachItem));
    }

    return mTodo;
  }

  Future<bool> toggleTodo({required bool isCompleted, required int id}) async {
    var db = await initDB();

    int rowsEffected = await db.update(
      TABLE_TODO,
      {COLUMN_TODO_IS_COMPLETED: isCompleted ? 1 : 0},
      where: "$COLUMN_TODO_ID = ?",
      whereArgs: ["$id"],
    );

    return rowsEffected>0;
  }
}
