import 'package:auto_checklist/controllers/task_controller.dart';
import 'package:flutter/material.dart';

enum ButtonFeature {add, uncheck, check, edit, save, delete, noTime, time}

const List<String> hourList = ['--', '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10',
  '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23'];
const List<String> minuteList = ['--', '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10',
  '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26',
  '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42',
  '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59'];

IconButton iconButton({
  required IconData iconData,
  required ButtonFeature buttonFeature,
  required TaskController taskController,
  int index = -1,
  double size = 22,
}) {
  return IconButton(
    onPressed: () {
      if(buttonFeature == ButtonFeature.add){
        taskController.firstAddTask();
        taskController.saveData(true, true, true, true, true);
      }
      else if(buttonFeature == ButtonFeature.uncheck){
        taskController.beNotCompleted(index);
        taskController.saveData(false, true, false, false, false);
      }
      else if(buttonFeature == ButtonFeature.check){
        taskController.beCompleted(index);
        taskController.checkedDateTime[index] = DateTime.now();
        taskController.saveData(false, true, false, false, true);
      }
      else if(buttonFeature == ButtonFeature.edit){
        taskController.editingIndex.value = index;
        taskController.editingContent.value = taskController.tasks[index];
      }
      else if(buttonFeature == ButtonFeature.save){
        taskController.tasks[index] = taskController.editingContent.value;
        taskController.saveData(true, false, false, false, false);
        taskController.editingIndex.value = -1;
      }
      else if(buttonFeature == ButtonFeature.delete){
        taskController.removeTask(index);
        taskController.saveData(true, true, true, true, true);
        taskController.editingIndex.value = -1;
      }
      else if(buttonFeature == ButtonFeature.noTime){
        taskController.doNotUseTime(index);
        taskController.saveData(false, false, true, false, false);
      }
      else if(buttonFeature == ButtonFeature.time){
        taskController.doUseTime(index);
        taskController.saveData(false, false, true, false, false);
      }
    },
    icon: Icon(
      iconData,
      size: size,
      color: Colors.black54,
    ),
    padding: const EdgeInsets.only(top: 2),
    splashRadius: 15,
  );
}

Container timeContainer({
  required TaskController taskController,
  required int index,
  required BuildContext context,
  required int order,
}) {

  // num is used in the value of DropdownButton.
  int num;
  if(order == 1){
    num = 2;
  } else if(order == 2){
    num = 6;
  } else{
    num = 10;
  }

  return Container(
    height: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: Colors.black12, width: 2),
    ),
    child: Row(
      children: [
        const SizedBox(width: 5),
        DropdownButton(
          underline: const SizedBox.shrink(),
          iconSize: 0,
          dropdownColor: Colors.white,
          value: taskController.times[index].substring(num - 2, num),
          items: hourList.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (item) {
            if(order == 1){
              taskController.times[index] = item! + taskController.times[index].substring(2);
            } else if(order == 2){
              taskController.times[index] = taskController.times[index].substring(0, 4) +
                  item! + taskController.times[index].substring(6);
            } else if(order == 3){
              taskController.times[index] = taskController.times[index].substring(0, 8) +
                  item! + taskController.times[index].substring(10);
            }
            taskController.saveData(false, false, false, true, false);
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
        const Text(" : "),
        DropdownButton(
          underline: const SizedBox.shrink(),
          iconSize: 0,
          dropdownColor: Colors.white,
          value: taskController.times[index].substring(num, num + 2),
          items: minuteList.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (item) {
            if(order == 1){
              taskController.times[index] = taskController.times[index].substring(0, 2) +
                  item! + taskController.times[index].substring(4);
            } else if(order == 2){
              taskController.times[index] = taskController.times[index].substring(0, 6) +
                  item! + taskController.times[index].substring(8);
            } else if(order == 3){
              taskController.times[index] = taskController.times[index].substring(0, 10) + item!;
            }
            taskController.saveData(false, false, false, true, false);
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
        const SizedBox(width: 5),
      ],
    ),
  );
}
