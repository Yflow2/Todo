
import 'package:flutter/material.dart';
import 'package:restapi/classes/title_list.dart';
import 'package:restapi/pages/task_detail.dart';

class TaskMenu extends StatefulWidget {
  const TaskMenu({super.key});

  @override
  State<TaskMenu> createState() => _TaskMenuState();
}

class _TaskMenuState extends State<TaskMenu> {

  TextEditingController textController = TextEditingController();

  static List<TitleList> titles = [
    TitleList(title: "Aniket"),
    TitleList(title: "Sartan")
  ];

  void addTitle(){
    if(textController.text.isNotEmpty){
      setState(() {
        titles.add(TitleList(title:textController.text));
        textController.clear();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        body: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: MediaQuery.of(context).size.width * 0.06,vertical: MediaQuery.of(context).size.width * 0.08),
          child: SafeArea(
            child: Container(
              child: Column(

                children: [

                  //Top Part Task
                  Container(
                    color: Colors.green,
                    height: 120,
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
                                    style: TextStyle(
                                        fontSize: 30
                                    ),
                                  ),
                                  Text("Create your categorized tasks"),
                                ],
                              ),
                          
                              // Edit Button
                              Positioned(
                                top: 1,
                                right: 1,
                                child: IconButton(onPressed: ()=>{
                                  // Logic for edit
                                }, icon: const Icon(Icons.edit)),
                              )
                            ],
                          ),
                        )

                      ],
                    ),
                  ),

                  //Gap 1
                  const SizedBox(height: 20,),

                  //ListView
                  Expanded(
                    child: Container(
                      color: Colors.yellow,
                      child: ListView.builder(
                        itemCount: titles.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(titles[index].title),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {
                              setState(() {
                                titles.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Deleted Task"),duration: Duration(seconds: 2),)
                              );
                            },

                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete this Task?"),
                                    content: Text("Task title - ${titles[index].title}"),
                                    actions: [

                                      // Cancel Delete
                                      TextButton(onPressed: ()=>{
                                        //Delete Item Cancel
                                        Navigator.of(context).pop(false)
                                      }, child: const Text("Cancel")),

                                      // Accept Delete
                                      TextButton(onPressed: () {
                                        //Delete Item Accept
                                        Navigator.of(context).pop(true);


                                      }, child: const Text("Delete task"))
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.all(5),
                                child: ListTile(
                                  title: Text(titles[index].title),
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskDetail(
                                              title:titles[index].title
                                          ))),
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),  // This makes space for FAB
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
                icon: const Icon(Icons.calendar_month, color: Colors.blueAccent, size: 30.0),
                onPressed: () {
                  // Action for Calendar button
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.blueAccent, size: 30.0),
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
              return await showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text("Want to add new title?"),
                  content: TextField(controller: textController,decoration: const InputDecoration(hintText: "Eg: Grocerries"),),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: ()=>{ Navigator.of(context).pop() }, child: const Text("Cancel")),
                        TextButton(onPressed: () {
                          Navigator.of(context).pop(true);
                          //Add title name
                          addTitle();
                        }, child: const Text("Add"))
                      ],
                    )
                  ],
                );
              },);
            },
            child: const Icon(Icons.add, color: Colors.white,size: 30,),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      ),
    );
  }


}
