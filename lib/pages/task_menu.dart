import 'package:flutter/material.dart';
import 'package:restapi/classes/title_list.dart';
import 'package:restapi/pages/task_detail.dart';

class TaskMenu extends StatefulWidget {
  const TaskMenu({super.key});

  @override
  State<TaskMenu> createState() => TaskMenuState();
}

class TaskMenuState extends State<TaskMenu> {
  TextEditingController textController = TextEditingController();

  static List<TitleList> titles = [
    TitleList(title: "Aniket"),
    TitleList(title: "Sartan")
  ];

  void addTitle() {
    if (textController.text.isNotEmpty) {
      setState(() {
        titles.add(TitleList(title: textController.text));
        textController.clear();
        titles.sort((a, b) => a.title.compareTo(b.title));
      });
    }
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
                                addTitle();
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

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsetsDirectional.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: MediaQuery.of(context).size.width * 0.08),
          child: SafeArea(
            child: Container(
              child: Column(
                children: [
                  //Top Part Task
                  Container(
                    height: 100,
                    child: Row(
                      children: [
                        // Task Text
                        Expanded(
                          child: Stack(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tasks",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text("Create your categorized tasks"),
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

                  //ListView
                  Expanded(
                    child: ListView.builder(
                        itemCount: titles.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(titles[index].title),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {
                              setState(() {
                                titles.removeAt(index);
                                TaskDetailState.taskitems.removeWhere(
                                    (taskTitle) =>
                                        taskTitle.title ==
                                        titles[index].title);
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Deleted Task"),
                                duration: Duration(seconds: 2),
                              ));
                            },
                            confirmDismiss: (direction) async {
                              return await displayBottomSheet(context,index,"${titles[index].title}");
                            },
                            child: Card(
                              color: const Color(0xFFF5F5F5),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.all(5),
                                child: ListTile(
                                  title: Text(titles[index].title),
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskDetail(
                                              title: titles[index].title))),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
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
                icon: const Icon(Icons.home,
                    color: Colors.blueAccent, size: 30.0),
                onPressed: () {
                  // Action for Home button
                },
              ),
              IconButton(
                icon: const Icon(Icons.search,
                    color: Colors.blueAccent, size: 40.0),
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
                icon: const Icon(Icons.more_horiz,
                    color: Colors.blueAccent, size: 30.0),
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
            onPressed:() {
              displayBottomSheetFotText(context,"What do you want to add?");
            } ,
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
