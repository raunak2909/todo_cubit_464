import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit_464/db_helper.dart';
import 'package:todo_cubit_464/db_state.dart';
import 'package:todo_cubit_464/todo_model.dart';

class DBCubit extends Cubit<DBState> {
  DBHelper dbHelper;

  DBCubit({required this.dbHelper}) : super(DBInitialState());

  void insertTodo({required TodoModel newTodo}) async {
    emit(DBLoadingState());
    /*int randomValue = Random().nextInt(5);
    await Future.delayed(Duration(seconds: randomValue));
    print(randomValue);
    */
    bool isAdded = await dbHelper.addTodo(newTodo: newTodo);
    if (isAdded) {
      List<TodoModel> allTodo = await dbHelper.fetchAllTodo();
      emit(DBLoadedState(mTodo: allTodo));
    } else {
      emit(DBErrorState(errorMsg: "Something went wrong!"));
    }
  }

  fetchInitialTodo({int filter = 3}) async {
    emit(DBLoadingState());
    List<TodoModel> allTodo = await dbHelper.fetchAllTodo(filterValue: filter);
    emit(DBLoadedState(mTodo: allTodo));
  }

  toggleTodo({required bool isCompleted, required int id}) async {
    emit(DBLoadingState());
    bool isUpdated = await dbHelper.toggleTodo(
      isCompleted: isCompleted,
      id: id,
    );
    if (isUpdated) {
      List<TodoModel> allTodo = await dbHelper.fetchAllTodo();
      emit(DBLoadedState(mTodo: allTodo));
    } else {
      emit(DBErrorState(errorMsg: "Something went wrong!"));
    }
  }

  updateTodo({
    required String title,
    required String remark,
    required int id,
    required int priority,
  }) async {
    emit(DBLoadingState());
    bool isUpdated = await dbHelper.updateTodo(
      title: title,
      remark: remark,
      id: id,
      priority: priority,
    );
    if (isUpdated) {
      List<TodoModel> allTodo = await dbHelper.fetchAllTodo();
      emit(DBLoadedState(mTodo: allTodo));
    } else {
      emit(DBErrorState(errorMsg: "Something went wrong!"));
    }
  }
}
