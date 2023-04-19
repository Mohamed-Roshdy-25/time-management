import 'package:get/get.dart';
import 'package:time_managing/db/db_helper.dart';
import 'package:time_managing/models/task_model.dart';

class TaskController extends GetxController{
  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<void> addTask(Task task) async {
    await DbHelper.insert(task);
    await getTasks();
  }

  Future<void> getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.get();
    taskList.assignAll(tasks.map((task) => Task.fromJson(task)).toList());
  }

  Future<void> deleteTask(Task task) async {
     await DbHelper.delete(task);
     await getTasks();
  }

  Future<void> markTaskCompleted(int? id) async {
     await DbHelper.update(id);
     await getTasks();
  }
}