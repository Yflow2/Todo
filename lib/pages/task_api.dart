import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restapi/database/database.dart';
import '../api/api_model.dart';
import '../api/api_service.dart';

//ignore: must_be_immutable
class TaskApi extends StatefulWidget {
  AppDatabase database;

  TaskApi(this.database, {super.key});

  @override
  State<TaskApi> createState() => _TaskApiState();
}

class _TaskApiState extends State<TaskApi> {

  late Future<List<Todo>> todosFuture;

  @override
  void initState() {
    super.initState();
    fetchTodos();
    todosFuture = loadTodos();
  }

  Future<List<Todo>> loadTodos(){
    return widget.database.getAllTodos();
  }

  Future<void> fetchTodos() async {
    final client = ApiClient(Dio());
    try {
       final response = await client.getTodo();
       List<TodoList> todos = response.todos;

       for (var todo in todos){
         await widget.database.insertTodo(TodosCompanion(
           id: dr.Value(todo.id),
           todo: dr.Value(todo.todo),
           completed: dr.Value(todo.completed),
           userId: dr.Value(todo.userId),
         ));
       }
    } catch (e) {
      throw Exception("Failed to load API");
    }
  }

  Future<void> changeCheckBox(int id, bool valForCheck) async {
    await widget.database.checkBoxUpdate(id, valForCheck);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Todo List')),
        body: FutureBuilder<List<Todo>>(
          future: todosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final todos = snapshot.data!;
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo.todo),
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (value) {
                        final valForCheck = value ?? false;
                        setState(() {
                          changeCheckBox(todo.id,valForCheck);
                          todosFuture = loadTodos();
                        });
                        //Check Box on checked function handle
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              todosFuture = loadTodos();
            });
          },
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
