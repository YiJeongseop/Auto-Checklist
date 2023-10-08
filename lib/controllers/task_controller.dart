import 'package:get/get.dart';

import '../main.dart';

class TaskController extends GetxController {
  RxList<String> tasks = <String>[].obs;
  RxList<bool> isCompleted = <bool>[].obs;
  RxInt editingIndex = (-1).obs;
  RxString editingContent = ''.obs;

  _fetchData() async {
    final tasks = prefs.getStringList('tasks') ?? [];
    this.tasks.value = tasks;
    final isCompleted = prefs.getStringList('isCompleted') ?? [];
    this.isCompleted.value = isCompleted.map((value){
      return (value == 'true') ? true : false;
    }).toList();
  }

  saveData({required int isTasks}) {
    List<String> temp = isCompleted.toList().map((value){
      return (value == true) ? "true" : "false";
    }).toList();

    if(isTasks == 1){
      prefs.setStringList('tasks', tasks);
    }else if(isTasks == 0){
      prefs.setStringList('isCompleted', temp);
    } else{
      prefs.setStringList('tasks', tasks);
      prefs.setStringList('isCompleted', temp);
    }
  }

  @override
  void onInit() {
    _fetchData();
    print("onInit!");
    super.onInit();
  }

  void addTask(String task, bool completed) {
    tasks.add(task);
    isCompleted.add(completed);
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    isCompleted.removeAt(index);
  }

  void beCompleted(int index) {
    isCompleted[index] = true;
  }

  void beNotCompleted(int index) {
    isCompleted[index] = false;
  }
}

