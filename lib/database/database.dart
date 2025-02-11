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
  int get schemaVersion => 1;

  // CRUD for Category
  Future<int> insertCategory(CategoriesCompanion category) =>
      into(categories).insert(category);

  Future<List<Category>> getAllCategories() => select(categories).get();

  Future deleteCategory(int id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();

  Future updateCategory(Category category) =>
      update(categories).replace(category);

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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
