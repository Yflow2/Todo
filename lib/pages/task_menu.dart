import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:restapi/classes/title_list.dart';
import 'package:restapi/database/database.dart';
import 'package:restapi/pages/task_detail.dart';

class TaskMenu extends StatefulWidget {
  const TaskMenu({super.key});

  @override
  State<TaskMenu> createState() => TaskMenuState();
}

class TaskMenuState extends State<TaskMenu> {

  AppDatabase database = AppDatabase();
  late Future<List<Category>> categoryTitleList;
  TextEditingController textController = TextEditingController();

  static List<TitleList> titles = [
    TitleList(title: "Work"),
    TitleList(title:"Personal")
  ];

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

  void addTitle() {
    if (textController.text.isNotEmpty && textController.text.trim() != "") {
      database.insertCategory(CategoriesCompanion(title: dr.Value(textController.text)));
      setState(() {
        categoryTitleList = loadCategoryList();
      });
      textController.clear();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Enter a valid input"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,

      ));
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
                                addTitle();
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
   Future displayBottomSheet(BuildContext context,int index, String title, List<Category> list) {
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
                const Text("Delete this Category?",style: TextStyle(fontSize: 30,color: Colors.black)),
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
                        //Delete Task
                        setState(() {
                              (taskTitle) =>
                          taskTitle.title == list[index].title;
                        });
                        Navigator.pop(context,true);
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

  @override
  void initState() {
    super.initState();
    categoryTitleList = loadCategoryList();
  }

  Widget fetchAndUpdateUi( List<Category> list ){
    return Expanded(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(list[index].id.toString(),),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {
                database.deleteCategory(list[index].id);
                loadCategoryList();
                setState(() {
                  list.removeAt(index);
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                  content: Text("Deleted Task"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
      
                ));
              },
              confirmDismiss: (direction) async {
                return await displayBottomSheet(context,index,list[index].title,list);
              },
              child: Card(
                color: const Color(0xFFF5F5F5),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: ListTile(
                    title: Text(list[index].title),
                    onTap: () async {
                       await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskDetail(
                                  id: list[index].id)));
                       setState(() {
                         categoryTitleList = loadCategoryList();
                       });
                    }
                  ),
                ),
              ),
            );
          }),
    );

  }

  Future<List<Category>> loadCategoryList(){
    return database.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return
      PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06,
                vertical: MediaQuery.of(context).size.width * 0.08),
            child: SafeArea(
              child: Column(
                children: [
                  //Top Part Task
                  SizedBox(
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
                                    "Tasks Category",
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
                                    onPressed: () async {
                                      return showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.white,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return const Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: FractionallySizedBox(
                                              heightFactor: 0.5,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Instructions:",
                                                    style: TextStyle(
                                                      fontSize: 24, // Increased font size
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 50),
                                                  Text(
                                                    "• Tap the ➕ button to add a new item.",
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    "• Swipe right on a title to delete it.",
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    "• Tap a title to open it and add tasks.",
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    "• You can rename the title from that screen.",
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    "• Delete tasks inside the selected title if needed.",
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    "• Edit the title anytime to keep things organized.",
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );


                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.question_mark)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  FutureBuilder(
                      future: categoryTitleList,
                      builder: (context, snapshot) {
                        final checkCategoryList = snapshot.data;
                        final checkCategoryListBool = checkCategoryList?.isNotEmpty;
                        if(checkCategoryListBool == false || checkCategoryList == null){
                          return const Center(child: Text("No Data Available"),);
                        } else if(snapshot.hasError){
                          return const Center(child: Text("Error in creating Error please check line 297 in task_menu"),);
                        } else{
                          return fetchAndUpdateUi(snapshot.data!);
                        }
                      },
                  ),

                  //ListView

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
                  icon: const Icon(Icons.home,
                      color: Colors.blueAccent, size: 30.0),
                  onPressed: () => showSnackBarText(context,"This is Home Page"),
                ),
                IconButton(
                  icon: const Icon(Icons.search,
                      color: Colors.blueAccent, size: 40.0),
                  onPressed: () {
                    // Action for Search button
                  /*  showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );*/
                  },
                ),
                const SizedBox(width: 48), // Space for FAB
                IconButton(
                  icon: const Icon(Icons.calendar_month,
                      color: Colors.blueAccent, size: 30.0),
                  onPressed: () {
                    // Action for Calendar button
                    showSnackBarText(context,"Work in Progress");
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz,
                      color: Colors.blueAccent, size: 30.0),
                  onPressed: () {
                    // Action for More button
                    showSnackBarText(context,"Work in Progress");
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
            ),
      );
  }
}
/*
class CustomSearchDelegate extends SearchDelegate {

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: Colors.blueAccent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none
        ),
        hintStyle: const TextStyle(color: Colors.black)
      )
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear,color: Colors.white,),
        onPressed: () {
          query = ''; // Clears the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search bar
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = TaskMenuState.titles.where((title) =>
        title.title.toLowerCase().contains(query.toLowerCase())).toList();

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(results[index].title),
            onTap: () {
              close(context, results[index].title);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetail(id: results[index].id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = TaskMenuState.titles.where((title) =>
        title.title.toLowerCase().contains(query.toLowerCase())).toList();

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestions[index].title),
            onTap: () {
              close(context, suggestions[index].title);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TaskDetail(title: suggestions[index].title);
                },
              ));
            },
          );
        },
      ),
    );
  }
}*/

