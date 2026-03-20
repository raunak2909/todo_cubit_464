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

  int mFilter = 3; /// 0-> low, 1-> med, 2-> high, 3-> all

  @override
  void initState() {
    super.initState();
    context.read<DBCubit>().fetchInitialTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: (){
                context.read<DBCubit>().fetchInitialTodo();
              }, child: Text('All')),
              TextButton(onPressed: (){
                context.read<DBCubit>().fetchInitialTodo(filter: 2);
              }, child: Text('High')),
              TextButton(onPressed: (){
                context.read<DBCubit>().fetchInitialTodo(filter: 1);
              }, child: Text('Med')),
              TextButton(onPressed: (){
                context.read<DBCubit>().fetchInitialTodo(filter: 0);
              }, child: Text('Low')),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<DBCubit, DBState>(
                builder: (_, state) {
                  if(state is DBLoadingState){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if(state is DBErrorState){
                    return Center(
                      child: Text(state.errorMsg),
                    );
                  }

                  if(state is DBLoadedState){
                    List<TodoModel> allTodo = state.mTodo;
                    return allTodo.isNotEmpty
                        ? ListView.builder(
                      itemCount: allTodo.length,
                      itemBuilder: (_, index) {

                        Color bgColor = Colors.white;
                        if(allTodo[index].tPriority==0){
                          bgColor = Colors.blue.shade100;
                        } else if(allTodo[index].tPriority==1){
                          bgColor = Colors.orange.shade100;
                        } else {
                          bgColor = Colors.red.shade100;
                        }

                        return Card(
                          child: CheckboxListTile(
                            tileColor: bgColor,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: allTodo[index].tIsCompleted,
                            onChanged: (value) {
                              ///update todo's isCompleted
                              context.read<DBCubit>().toggleTodo(
                                isCompleted: value ?? false,
                                id: allTodo[index].tid!,
                              );
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(allTodo[index].tTitle),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddTodoPage(
                                          isUpdate: true,
                                          title: allTodo[index].tTitle,
                                          remark: allTodo[index].tRemark,
                                          id: allTodo[index].tid,
                                          priority: allTodo[index].tPriority,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.edit),
                                ),
                              ],
                            ),
                            subtitle: Text(allTodo[index].tRemark),
                          ),
                        );
                      },
                    )
                        : Center(child: Text("No Todos yet!!"));
                  }

                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
