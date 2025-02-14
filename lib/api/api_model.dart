class TodoResponse {
  final List<TodoList> todos;
  final int total;
  final int skip;
  final int limit;

  TodoResponse({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory TodoResponse.fromJson(Map<String, dynamic> json) {
    List<TodoList> todos = (json['todos'] as List)
        .map((item) => TodoList.fromJson(item))
        .toList();

    return TodoResponse(
        todos: todos,
        total: json['total'],
        skip: json['skip'],
        limit: json['limit']);
  }
}

class TodoList {
  int id;
  String todo;
  bool completed;
  int userId;

  TodoList(
      {required this.id,
      required this.todo,
      required this.completed,
      required this.userId});

  factory TodoList.fromJson(Map<String, dynamic> json) {
    return TodoList(
        id: json['id'],
        todo: json['todo'],
        completed: json['completed'],
        userId: json['userId']);
  }
}
