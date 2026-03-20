import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit_464/db_cubit.dart';
import 'package:todo_cubit_464/db_helper.dart';
import 'package:todo_cubit_464/todo_model.dart';

class AddTodoPage extends StatefulWidget {
  bool isUpdate;
  String title, remark;
  int? id;
  int priority;

  AddTodoPage({
    this.isUpdate = false,
    this.title = "",
    this.remark = "",
    this.id,
    this.priority = 2,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  var titleController = TextEditingController();

  var remarkController = TextEditingController();

  DBHelper? dbHelper;

  int selectedPriority = 2;
  List<String> mPriority = ["Low", "Medium", "High"];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isUpdate) {
      titleController.text = widget.title;
      remarkController.text = widget.remark;
      selectedPriority = widget.priority;
    }

    return Scaffold(
      appBar: AppBar(title: Text('${widget.isUpdate ? 'Update' : 'Add'} Todo')),
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
            StatefulBuilder(
              builder: (context, ss) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(mPriority.length, (index){
                    return RadioMenuButton(
                      value: index,
                      groupValue: selectedPriority,
                      onChanged: (value){
                        selectedPriority = value ?? 0;
                        ss((){});
                      },
                      child: Text(mPriority[index]),
                    );
                  }),
                );
              }
            ),
            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    if (widget.isUpdate) {
                      context.read<DBCubit>().updateTodo(
                        title: titleController.text,
                        remark: remarkController.text,
                        id: widget.id!,
                        priority: selectedPriority
                      );
                    } else {
                      context.read<DBCubit>().insertTodo(
                        newTodo: TodoModel(
                          tPriority: selectedPriority,
                          tTitle: titleController.text,
                          tRemark: remarkController.text,
                          tIsCompleted: false,
                          tCreatedAt: DateTime.now().millisecondsSinceEpoch,
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text(widget.isUpdate ? 'Update' : 'Add'),
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
