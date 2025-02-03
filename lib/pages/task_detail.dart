import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../classes/taskitem.dart';

class TaskDetail extends StatefulWidget {
  final String title;

  const TaskDetail({super.key, required this.title});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  TextEditingController textController = TextEditingController();

  static List<TaskCategory> taskitems = [
    TaskCategory(
        title: "Aniket",
        tasks: [TaskItem(itemName: "Paani piyo", isChecked: true)]),
    TaskCategory(title: "Vinayak", tasks: [
      TaskItem(itemName: "Paani piyo", isChecked: true),
      TaskItem(itemName: "Paani piyo", isChecked: true)
    ]),
    TaskCategory(title: "Ramayan", tasks: [
      TaskItem(itemName: "Paani piyo", isChecked: true),
      TaskItem(itemName: "Paani piyo", isChecked: true),
      TaskItem(itemName: "Paani piyo", isChecked: true)
    ]),
  ];

  late TaskCategory taskCategory;
  bool exists = false;

  @override
  void initState() {
    super.initState();
    taskCategory = taskitems.firstWhere(
      (category) => category.title == widget.title,
      orElse: () => TaskCategory(title: widget.title),
    );
  }

  void addItem() {
    if(textController.text.isNotEmpty){
      setState(() {
        taskitems.add(taskCategory);
        taskCategory.tasks.add(TaskItem(itemName: textController.text));
        textController.clear();
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 20),
          child: Column(
            children: [
              //Top Part
              Container(
                height: 100,
                child: Row(
                  children: [
                    // Task Text
                    Expanded(
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(fontSize: 30),
                              ),
                              const Text("3 out of 10 tasks")
                            ],
                          ),

                          // Edit Button
                          Positioned(
                            top: 1,
                            right: 1,
                            child: IconButton(
                                onPressed: () => {
                                      // Logic for edit
                                    },
                                icon: const Icon(Icons.edit)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              //ListBuilder
              Expanded(
                child: ListView.builder(
                  itemCount: taskCategory.tasks.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
                      ),
                      child: CheckboxListTile(
                        title: Text(taskCategory.tasks[index].itemName),
                        value: taskCategory.tasks[index].isChecked,
                        onChanged: (value) {
                          setState(() {
                            taskCategory.tasks[index].isChecked =
                                value ?? false;
                          });
                        },
                        activeColor: Colors.green,
                        tileColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFF5F5F5),
        shape: const CircularNotchedRectangle(), // This makes space for FAB
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.blueAccent, size: 30.0),
              onPressed: () {
                // Action for Home button
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.blueAccent, size: 40.0),
              onPressed: () {
                // Action for Search button
              },
            ),
            const SizedBox(width: 48), // Space for FAB
            IconButton(
              icon: const Icon(Icons.calendar_month,
                  color: Colors.blueAccent, size: 30.0),
              onPressed: () {
                // Action for Calendar button
              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.more_horiz, color: Colors.blueAccent, size: 30.0),
              onPressed: () {
                // Action for More button
              },
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          shape: const CircleBorder(),
          onPressed: () async {
            // Add new title Dialog box
            return await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Want to add new task?"),
                  content: TextField(
                    controller: textController,
                    decoration:
                        const InputDecoration(hintText: "Eg: Potato"),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => {Navigator.of(context).pop()},
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              //Add title name
                              addItem();
                            },
                            child: const Text("Add"))
                      ],
                    )
                  ],
                );
              },
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


}
