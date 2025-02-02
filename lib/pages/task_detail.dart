

import 'package:flutter/material.dart';

class TaskDetail extends StatefulWidget {
  var title;

  TaskDetail({super.key, required this.title});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
      ),
    );
  }
}

