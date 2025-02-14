import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../api/api_model.dart';
import '../api/api_service.dart';

class TaskApi extends StatefulWidget {
  const TaskApi({super.key});

  @override
  State<TaskApi> createState() => _TaskApiState();
}

class _TaskApiState extends State<TaskApi> {
  late Future<Todo> todosFuture;

  @override
  void initState() {
    super.initState();
    todosFuture = fetchTodos();
  }

  Future<Todo> fetchTodos() async {
    final client = ApiClient(Dio());
    try {
       final response = await client.getTodo();
       return response;
    } catch (e) {
      throw Exception("Failed to load API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Todo List')),
        body: FutureBuilder<Todo>(
          future: todosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final todo = snapshot.data!;
              return Center(child: Text(
                todo.todo
              ),);
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              todosFuture = fetchTodos();
            });
          },
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
