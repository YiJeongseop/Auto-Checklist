import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../main.dart';

String _tasksStorage = 'tasks4';
String _isCompletedStorage = 'isCompleted4';
String _useTimeStorage = 'useTime4';
String _timesStorage = 'times4';
String _checkedDateTimeStorage = 'checkedDateTime4';

class TaskController extends GetxController {
  RxList<String> tasks = <String>[].obs;
  RxList<bool> isCompleted = <bool>[].obs;
  RxList<bool> useTime = <bool>[].obs;
  RxList<String> times = <String>[].obs;
  RxList<DateTime> checkedDateTime = <DateTime>[].obs;

  RxInt editingIndex = (-1).obs;
  RxString editingContent = ''.obs;

  _fetchData() async {
    final tasks = prefs.getStringList(_tasksStorage) ?? [];
    this.tasks.value = tasks;

    final isCompleted = prefs.getStringList(_isCompletedStorage) ?? [];
    this.isCompleted.value = isCompleted.map((value) {
      return (value == 'true') ? true : false;
    }).toList();

    final useTime = prefs.getStringList(_useTimeStorage) ?? [];
    this.useTime.value = useTime.map((value) {
      return (value == 'true') ? true : false;
    }).toList();

    final times = prefs.getStringList(_timesStorage) ?? [];
    this.times.value = times;

    final checkedDateTime = prefs.getStringList(_checkedDateTimeStorage) ?? [];
    this.checkedDateTime.value = checkedDateTime.map((formattedDate) {
      return DateTime.parse(formattedDate);
    }).toList();
  }

  saveData(bool saveTasks, bool saveIsCompleted, bool saveUseTime, bool saveTimes, bool saveCheckedDateTime) {
    if (saveTasks) {
      prefs.setStringList(_tasksStorage, tasks);
    }

    if (saveIsCompleted) {
      List<String> temp = isCompleted.toList().map((value) {
        return (value == true) ? "true" : "false";
      }).toList();

      prefs.setStringList(_isCompletedStorage, temp);
    }

    if (saveUseTime) {
      List<String> temp = useTime.toList().map((value) {
        return (value == true) ? "true" : "false";
      }).toList();

      prefs.setStringList(_useTimeStorage, temp);
    }

    if (saveTimes) {
      prefs.setStringList(_timesStorage, times);
    }

    if (saveCheckedDateTime) {
      List<String> temp = checkedDateTime.map((datetime) {
        return DateFormat('yyyy-MM-dd HH:mm').format(datetime);
      }).toList();

      prefs.setStringList(_checkedDateTimeStorage, temp);
    }
  }

  @override
  void onInit() {
    _fetchData();
    // print(tasks);
    // print(isCompleted);
    // print(useTime);
    // print(times);
    // print(checkedDateTime);
    super.onInit();
  }

  void firstAddTask() {
    tasks.add('');
    isCompleted.add(false);
    useTime.add(false);
    times.add('------------');
    checkedDateTime.add(DateTime.utc(1969, 7, 20, 20, 18));
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    isCompleted.removeAt(index);
    useTime.removeAt(index);
    times.removeAt(index);
    checkedDateTime.removeAt(index);
  }

  void beCompleted(int index) {
    isCompleted[index] = true;
  }

  void beNotCompleted(int index) {
    isCompleted[index] = false;
  }

  void doUseTime(int index) {
    useTime[index] = true;
  }

  void doNotUseTime(int index) {
    useTime[index] = false;
  }
}
