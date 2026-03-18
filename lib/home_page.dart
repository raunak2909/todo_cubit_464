import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit_464/add_todo_page.dart';
import 'package:todo_cubit_464/db_cubit.dart';
import 'package:todo_cubit_464/db_helper.dart';
import 'package:todo_cubit_464/db_state.dart';
import 'package:todo_cubit_464/todo_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    context.read<DBCubit>().fetchInitialTodo();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: BlocBuilder<DBCubit, DBState>(builder: (_, state){
        List<TodoModel> allTodo = state.mTodo;
        return allTodo.isNotEmpty
            ? ListView.builder(
          itemCount: allTodo.length,
          itemBuilder: (_, index) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: allTodo[index].tIsCompleted,
              onChanged: (value){
                ///update todo's isCompleted
                context.read<DBCubit>().toggleTodo(isCompleted: value ?? false, id: allTodo[index].tid!);
              },
              title: Text(allTodo[index].tTitle),
              subtitle: Text(allTodo[index].tRemark),
            );
          },
        )
            : Center(child: Text("No Todos yet!!"));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoPage()),
          );
        }, child: Icon(Icons.add),
      ),
    );
  }
}
