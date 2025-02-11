import 'package:flutter/material.dart';
import 'package:restapi/database/database.dart';
import 'package:restapi/pages/task_menu.dart';

import '../classes/taskitem.dart';

//ignore: must_be_immutable
class TaskDetail extends StatefulWidget {
  int id;

  TaskDetail({super.key, required this.id});

  @override
  State<TaskDetail> createState() => TaskDetailState();
}

class TaskDetailState extends State<TaskDetail> {

  AppDatabase database = AppDatabase();
  TextEditingController textController = TextEditingController();
  late Future<List<Task>> taskItems;

  static List<TaskCategory> taskitems = [
    TaskCategory(
      title: "Work",
      tasks: [
        TaskItem(itemName: "Send email", isChecked: false),
        TaskItem(itemName: "Finish report", isChecked: true),
      ],
    ),
    TaskCategory(
      title: "Personal",
      tasks: [
        TaskItem(itemName: "Buy groceries", isChecked: false),
        TaskItem(itemName: "Go for a run", isChecked: true),
      ],
    ),
  ];

  late TaskCategory taskCategory;

  @override
  void initState() {
    super.initState();
    taskItems = loadTaskFromDatabase();
/*
    taskCategory = taskitems.firstWhere(
      (category) => category.title == widget.title,
      orElse: () => TaskCategory(title: widget.title),
    );*/
  }

  Future<List<Task>> loadTaskFromDatabase(){
    return database.getTasksByCategory(widget.id);
}

  void showSnackBarText(BuildContext context,String title){
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.removeCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(title),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void addItem() {
    if(textController.text.isNotEmpty && textController.text.trim() != ""){
      setState(() {
        taskCategory.tasks.add(TaskItem(itemName: textController.text));
        taskitems.add(taskCategory);
        //Need to add refresh
        textController.clear();
      });
    } else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Enter a valid input"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,

      ));
    }
  }

  void editItem(){
    if(textController.text.isNotEmpty && textController.text.trim() != ""){
      setState(() {
/*        for(var category in taskitems){
          if(category.title == widget.title){
            category.title = textController.text;
            taskCategory.title = textController.text;
          }
        }
        for(var task in TaskMenuState.titles){
          if(task.title == widget.title){
            task.title = textController.text;
          }
        }
        widget.title = textController.text;*/
        textController.clear();
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Enter a valid input"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,

      ));
    }
}

  Widget fetchAndUpdateUiTasks(List<Task> list){
    return Expanded(
      child: ListView.builder(
        itemCount: list.length,
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
                displayBottomSheet(context,index,list[index].taskName);
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
    );
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
                const Text("Delete task?",style: TextStyle(fontSize: 30,color: Colors.black)),
                const SizedBox(height: 15,),
                Text("Are you sure you want to delete: $title",style: const TextStyle(fontSize: 15,color: Colors.black)),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 120,child: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 10,backgroundColor: const Color(0xFFF5F5F5)) ,onPressed: ()=>{ Navigator.pop(context) }, child: const Text("No",style: TextStyle(color: Colors.black,fontSize: 20),))),
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 10,backgroundColor: const Color(0xFFF5F5F5)),onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          //Delete item from particular title
                          taskCategory.tasks.removeAt(index);
                          loadTaskFromDatabase();
                        });
                        }, child: const Text("Yes",style: TextStyle(color: Colors.red,fontSize: 20,),)),
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
                      style: const TextStyle(fontSize: 20, color: Colors.black)),
                  const SizedBox(
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
                  const SizedBox(height: 30,),
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
                                backgroundColor: const Color(0xFFF5F5F5)),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                addItem();
                              });
                            },
                            child: const Text(
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

  Future displayBottomSheetForUpdate(BuildContext context, String title) {
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
                      style: const TextStyle(fontSize: 20, color: Colors.black)),
                  const SizedBox(
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
                    ),hintText: "New Title"),
                  ),
                  const SizedBox(height: 30,),
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
                                backgroundColor: const Color(0xFFF5F5F5)),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                editItem();
                              });
                            },
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                color: Colors.green,
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
              SizedBox(
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
                                widget.id.toString(),
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
                                onPressed: () {
                                      // Logic for edit
                                  displayBottomSheetForUpdate(context,"Edit your title");
                                    },
                                icon: const Icon(Icons.edit)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              FutureBuilder(
                future: taskItems,
                builder: (context, snapshot) {
                  final checkCategoryList = snapshot.data;
                  final checkCategoryListBool = checkCategoryList?.isNotEmpty;
                  if(checkCategoryListBool == false || checkCategoryList == null){
                    return const Center(child: Text("No Data Available"),);
                  } else if(snapshot.hasError){
                    return const Center(child: Text("Error in creating Error please check line 297 in task_menu"),);
                  } else{
                    return fetchAndUpdateUiTasks(snapshot.data!);
                  }
                },
              ),

              //ListBuilder

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
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const TaskMenu();
                  },
                ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.blueAccent, size: 40.0),
              onPressed: () {
                // Action for Search button
                showSnackBarText(context,"Work in progress");

              },
            ),
            const SizedBox(width: 48), // Space for FAB
            IconButton(
              icon: const Icon(Icons.calendar_month,
                  color: Colors.blueAccent, size: 30.0),
              onPressed: () {
                // Action for Calendar button
                showSnackBarText(context,"Work in progress");

              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.more_horiz, color: Colors.blueAccent, size: 30.0),
              onPressed: () {
                // Action for More button
                showSnackBarText(context,"Work in progress");

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
