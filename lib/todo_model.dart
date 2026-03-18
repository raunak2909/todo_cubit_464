import 'package:todo_cubit_464/db_helper.dart';

class TodoModel {
  int? tid; ///auto increment (optional)
  String tTitle;
  String tRemark;
  bool tIsCompleted;
  int tCreatedAt;

  TodoModel({
    this.tid,
    required this.tTitle,
    required this.tRemark,
    required this.tIsCompleted,
    required this.tCreatedAt,
  });

  ///fromMap (Database -> Map -> Model -> UI)
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      tid: map[DBHelper.COLUMN_TODO_ID],
      tTitle: map[DBHelper.COLUMN_TODO_TITLE],
      tRemark: map[DBHelper.COLUMN_TODO_REMARK],
      tIsCompleted: map[DBHelper.COLUMN_TODO_IS_COMPLETED] == 1 ,
      tCreatedAt: int.parse(map[DBHelper.COLUMN_TODO_CREATED_AT]),
    );
  }

  ///toMap (UI -> Model -> Map -> Database)
  Map<String, dynamic> toMap(){
    return {
      DBHelper.COLUMN_TODO_TITLE : tTitle,
      DBHelper.COLUMN_TODO_REMARK : tRemark,
      DBHelper.COLUMN_TODO_IS_COMPLETED : tIsCompleted ? 1 : 0,
      DBHelper.COLUMN_TODO_CREATED_AT : tCreatedAt.toString(),
    };
  }
}
