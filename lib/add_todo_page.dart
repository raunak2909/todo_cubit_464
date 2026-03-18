import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit_464/db_cubit.dart';
import 'package:todo_cubit_464/db_helper.dart';
import 'package:todo_cubit_464/todo_model.dart';

class AddTodoPage extends StatefulWidget {
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  var titleController = TextEditingController();

  var remarkController = TextEditingController();

  DBHelper? dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Todo')),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Enter title here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            SizedBox(height: 11),
            TextField(
              controller: remarkController,
              minLines: 4,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Remark",
                hintText: "Enter remark here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    context.read<DBCubit>().insertTodo(
                      newTodo: TodoModel(
                        tTitle: titleController.text,
                        tRemark: remarkController.text,
                        tIsCompleted: false,
                        tCreatedAt: DateTime.now().millisecondsSinceEpoch,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text('Add'),
                ),
                SizedBox(width: 11),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
