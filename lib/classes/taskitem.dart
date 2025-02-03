
class TaskItem {
  bool isChecked;
  String itemName;

  TaskItem({this.isChecked = false,required this.itemName});
}

class TaskCategory{
  String title;
  List<TaskItem> tasks;

  TaskCategory({required this.title, List<TaskItem>? tasks}) : tasks = tasks ?? [];
}