import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 100)();
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get taskName => text()();

  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();

  IntColumn get categoryId => integer().references(Categories, #id)();
}

@DriftDatabase(tables: [Categories, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  // CRUD for Category

  Future<int> insertCategory(CategoriesCompanion category) =>
      into(categories).insert(category);

  Future<List<Category>> getAllCategories() => select(categories).get();

  Future deleteCategory(int id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();

  Future<void> updateCategoryById(int categoryId, String newTitle) {
    return (update(categories)..where((c) => c.id.equals(categoryId))).write(
      CategoriesCompanion(
        title: Value(newTitle),
      ),
    );
  }

  Future<String?> getCategoryTitleById(int categoryId) {
    return (select(categories)..where((c) => c.id.equals(categoryId))).map((row) => row.title).getSingleOrNull();
  }

  // CRUD for Tasks
  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);

  Future<List<Task>> getAllTasks() => select(tasks).get();

  Future deleteTask(int id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  Future updateTask(Task task) => update(tasks).replace(task);

  // Fetch tasks by category
  Future<List<Task>> getTasksByCategory(int categoryId) {
    return (select(tasks)..where((t) => t.categoryId.equals(categoryId))).get();
  }

  //Change isChecked Value
  Future<void> updateTaskCheckedStatus(int taskId, bool isChecked) {
    return (update(tasks)..where((t) => t.id.equals(taskId))).write(TasksCompanion(isChecked: Value(isChecked)));
  }

  //Update Task Name
  Future<void> updateTaskNameById(int taskId, String newTaskName) {
    return (update(tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        taskName: Value(newTaskName),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
