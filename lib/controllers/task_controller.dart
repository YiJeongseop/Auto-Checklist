import 'package:get/get.dart';

class TaskController extends GetxController {
  List<Task> tasks = <Task>[].obs;
  List<bool> isCompleted = <bool>[].obs;
  RxInt editingIndex = (-1).obs;
  RxString editingContent = ''.obs;

  void addTask(Task task) {
    tasks.add(task);
    isCompleted.add(task.completed);
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    isCompleted.removeAt(index);
  }

  void beCompleted(int index) {
    tasks[index].completed = true;
    isCompleted[index] = true;
  }

  void beNotCompleted(int index) {
    tasks[index].completed = false;
    isCompleted[index] = false;
  }
}

class Task {
  Task({
    this.content = 'Add Content',
    this.completed = false,
    this.isTimeCheck = false,
    this.seconds = 600,
    required this.timeList,
  });

  String content;
  bool completed;
  final bool isTimeCheck;
  final int seconds;
  final List<String> timeList;
}