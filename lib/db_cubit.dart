import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit_464/db_helper.dart';
import 'package:todo_cubit_464/db_state.dart';
import 'package:todo_cubit_464/todo_model.dart';

class DBCubit extends Cubit<DBState> {
  DBHelper dbHelper;
  DBCubit({required this.dbHelper}) : super(DBState(mTodo: []));

  void insertTodo({required TodoModel newTodo}) async{
    bool isAdded = await dbHelper.addTodo(newTodo: newTodo);
    if(isAdded){
      List<TodoModel> allTodo = await dbHelper.fetchAllTodo();
      emit(DBState(mTodo: allTodo));
    }
  }

  fetchInitialTodo() async{
    List<TodoModel> allTodo = await dbHelper.fetchAllTodo();
    emit(DBState(mTodo: allTodo));
  }

  toggleTodo({required bool isCompleted, required int id}) async{
    bool isUpdated = await dbHelper.toggleTodo(isCompleted: isCompleted, id: id);
    if(isUpdated){
      List<TodoModel> allTodo = await dbHelper.fetchAllTodo();
      emit(DBState(mTodo: allTodo));
    }
  }

}
