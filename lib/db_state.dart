import 'package:todo_cubit_464/todo_model.dart';

abstract class DBState{}

class DBInitialState extends DBState{}
class DBLoadingState extends DBState{}
class DBLoadedState extends DBState{
  List<TodoModel> mTodo;
  DBLoadedState({required this.mTodo});
}
class DBErrorState extends DBState{
  String errorMsg;
  DBErrorState({required this.errorMsg});
}
