import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';
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

  // This variable stores the time the user recently checked.
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
    _firstCheck();
    _setupTimer();
    super.onInit();
  }

  // This function runs only the first time the app is turned on.
  // Compare the time they recently checked with the time they want the check turned off.
  void _firstCheck() {
    final currentTime = DateTime.now();
    for(int i = 0; i < tasks.length; i++){
      if(useTime[i] == true || isCompleted[i] == true){
        for(int j = 0; j <= 8; j+=4){
          try{
            int hour = int.parse(times[i].substring(j, j+2));
            int minute = int.parse(times[i].substring(j+2, j+4));
            Duration difference = currentTime.difference(checkedDateTime[i]);
            int daysDifference = difference.inDays;

            // There are three things to consider.
            // 1. Checked at least 2 days ago.
            if(daysDifference > 1){
              isCompleted[i] = false;
              break;
            }

            // 2. Checked 1 day ago.
            // Do not turn off the check only when the time they checked is later than the time they want the check turned off
            // and the current time is earlier than the time they want the check turned off.
            else if(daysDifference == 1){
              if(hour < checkedDateTime[i].hour || (hour == checkedDateTime[i].hour && minute <= checkedDateTime[i].minute)){
                if(hour > currentTime.hour || (hour == currentTime.hour && minute > currentTime.minute)){
                  continue;
                } else{
                  isCompleted[i] = false;
                  break;
                }
              } else {
                isCompleted[i] = false;
                break;
              }
            }

            // 3. Checked today.
            else {
              if(hour < currentTime.hour || (hour == currentTime.hour && minute <= currentTime.minute)){
                if(hour < checkedDateTime[i].hour || (hour == checkedDateTime[i].hour && minute <= checkedDateTime[i].minute)){
                  continue;
                } else {
                  isCompleted[i] = false;
                  break;
                }
              }
            }
          } catch(e){
            continue;
          }
        }
      }
    }
  }

  void _setupTimer() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      final currentTime = DateTime.now();
      for(int i = 0; i < tasks.length; i++){
        if(useTime[i] == true || isCompleted[i] == true){
          for(int j = 0; j <= 8; j+=4){
            try{
              int hour = int.parse(times[i].substring(j, j+2));
              int minute = int.parse(times[i].substring(j+2, j+4));
              if(currentTime.hour == hour && currentTime.minute == minute){
                isCompleted[i] = false;
                break;
              }
            } catch(e){
              continue;
            }
          }
        }
      }
    });
  }

  void firstAddTask() {
    tasks.add('');
    isCompleted.add(false);
    useTime.add(false);

    // Users can save three times when they want the check turned off.
    // Example) 080012001800
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
