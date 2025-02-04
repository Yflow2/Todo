import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restapi/pages/task_menu.dart';

import '../classes/taskitem.dart';

class TaskDetail extends StatefulWidget {
  final String title;

  const TaskDetail({super.key, required this.title});

  @override
  State<TaskDetail> createState() => TaskDetailState();
}

class TaskDetailState extends State<TaskDetail> {
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
        //Need to add refresh
        taskCategory.tasks.add(TaskItem(itemName: textController.text));
        textController.clear();
      });
    }
  }

  Future displayBottomSheet(BuildContext context,int index, String title) {
    return showModalBottomSheet(
      context: context,
      barrierColor: Colors.grey.withValues(alpha: 0.8),
      backgroundColor: Colors.white,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 180,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Delete task?",style: TextStyle(fontSize: 30,color: Colors.black)),
                SizedBox(height: 15,),
                Text("Are you sure you want to delete: $title",style: TextStyle(fontSize: 15,color: Colors.black)),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 120,child: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 10,backgroundColor: Color(0xFFF5F5F5)) ,onPressed: ()=>{ Navigator.pop(context) }, child: Text("No",style: TextStyle(color: Colors.black,fontSize: 20),))),
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 10,backgroundColor: Color(0xFFF5F5F5)),onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          taskCategory.tasks.removeAt(index);
                        });
                        }, child: Text("Yes",style: TextStyle(color: Colors.red,fontSize: 20,),)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future displayBottomSheetFotText(BuildContext context, String title) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.grey.withValues(alpha: 0.8),
      backgroundColor: Colors.white,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom ),
          child: SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: textController,
                    decoration:
                    const InputDecoration(border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                            width: 2.0
                        )
                    ),hintText: "Eg: Grocerries"),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 120,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor: const Color(0xFFF5F5F5)),
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text(
                                "No",
                                style:
                                TextStyle(color: Colors.black, fontSize: 20),
                              ))),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor: Color(0xFFF5F5F5)),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                addItem();
                              });
                            },
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
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
                        secondary: IconButton(onPressed: () {

                          displayBottomSheet(context,index,taskCategory.tasks[index].itemName);
                          //Delete item
                        }, icon: const Icon(Icons.delete,size: 25,color: Colors.red,)),
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
          onPressed: () {
            displayBottomSheetFotText(context,"Add new Item");
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
