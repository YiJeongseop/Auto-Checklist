import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import '../controllers/task_controller.dart';
import '../controllers/pages_controller.dart';

class WindowsScreen extends StatelessWidget {
  WindowsScreen({Key? key}) : super(key: key);

  final TaskController taskController = Get.put(TaskController());
  final PagesController pagesController = Get.put(PagesController());
  List<String> hourList = ['--', '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10',
  '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23'];
  List<String> minuteList = ['--', '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10',
    '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26',
  '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42',
  '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59'];

  @override
  Widget build(BuildContext context) {
    return DragToResizeArea(
      child: GestureDetector(
        // Prevent the screen from being full when double-clicked.
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          WindowManager.instance.startDragging();
        },

        child: Scaffold(
          backgroundColor: const Color(0xFFFFFFDD),
          appBar: AppBar(
            iconTheme: const IconThemeData(
              size: 30,
              color: Colors.black54,
            ),
            backgroundColor: const Color(0xFFFFFEBB),
            leading: Obx(() => (pagesController.currentPage.value == 0)
                ? Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: IconButton(
                      padding: const EdgeInsets.only(top: 2),
                      onPressed: () {
                        taskController.firstAddTask();
                        taskController.saveData(true, true, true, true, true);
                      },
                      splashRadius: 15,
                      icon: const Icon(Icons.add),
                    ),
                  )
                : const SizedBox.shrink()),
            actions: [
              Obx(
                () => (pagesController.currentPage.value == 0)
                    ? IconButton(
                        padding: const EdgeInsets.only(top: 2),
                        onPressed: () => pagesController.changePage(),
                        splashRadius: 15,
                        icon: const Icon(Icons.timer_outlined),
                      )
                    : IconButton(
                        padding: const EdgeInsets.only(top: 2),
                        onPressed: () => pagesController.changePage(),
                        splashRadius: 15,
                        icon: const Icon(Icons.notes),
                      ),
              ),
              IconButton(
                padding: const EdgeInsets.only(top: 2),
                onPressed: () => exit(0),
                splashRadius: 15,
                icon: const Icon(Icons.close),
              )
            ],
            elevation: 0.0,
            toolbarHeight: 36.0,
          ),
          body: Obx(
            () => ListView.separated(
              itemCount: taskController.tasks.length,
              itemBuilder: (context, index) {
                return Obx(
                  () => (pagesController.currentPage.value == 0)
                      ? ListTile(
                          horizontalTitleGap: 10,
                          contentPadding: const EdgeInsets.only(left: 0, right: 0),
                          title: (taskController.editingIndex.value == index)
                              ? TextFormField(
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(bottom: 7, top: 7),
                                  ),
                                  maxLines: null,
                                  initialValue: taskController.tasks[index],
                                  onChanged: (value) {
                                    taskController.editingContent.value = value;
                                  },
                                )
                              : Text(
                                  taskController.tasks[index],
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: taskController.isCompleted[index]
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                ),
                          leading: (taskController.isCompleted[index])
                              ? IconButton(
                                  padding: const EdgeInsets.only(top: 2),
                                  onPressed: () {
                                    taskController.beNotCompleted(index);
                                    taskController.saveData(false, true, false, false, false);
                                  },
                                  splashRadius: 15,
                                  icon: const Icon(
                                    Icons.check_box_outlined,
                                    size: 22,
                                  ),
                                )
                              : IconButton(
                                  padding: const EdgeInsets.only(top: 2),
                                  onPressed: () {
                                    taskController.beCompleted(index);
                                    taskController.checkedDateTime[index] = DateTime.now();
                                    taskController.saveData(false, true, false, false, true);
                                  },
                                  splashRadius: 15,
                                  icon: const Icon(
                                    Icons.check_box_outline_blank,
                                    size: 22,
                                  ),
                                ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (taskController.editingIndex.value != index)
                                IconButton(
                                  padding: const EdgeInsets.only(top: 2),
                                  onPressed: () {
                                    taskController.editingIndex.value = index;
                                    taskController.editingContent.value =
                                        taskController.tasks[index];
                                  },
                                  splashRadius: 15,
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 22,
                                  ),
                                ),
                              if (taskController.editingIndex.value == index)
                                IconButton(
                                  padding: const EdgeInsets.only(top: 2),
                                  onPressed: () {
                                    taskController.tasks[index] = taskController.editingContent.value;
                                    taskController.saveData(true, false, false, false, false);
                                    taskController.editingIndex.value = -1;
                                  },
                                  splashRadius: 15,
                                  icon: const Icon(
                                    Icons.save_alt,
                                    size: 22,
                                  ),
                                ),
                              IconButton(
                                padding: const EdgeInsets.only(top: 2),
                                onPressed: () {
                                  taskController.removeTask(index);
                                  taskController.saveData(true, true, true, true, true);
                                  taskController.editingIndex.value = -1;
                                },
                                splashRadius: 15,
                                icon: const Icon(
                                  Icons.delete,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListTile(
                          horizontalTitleGap: 10,
                          contentPadding:
                              const EdgeInsets.only(left: 0, right: 0),
                          leading: (taskController.useTime[index])
                              ? IconButton(
                                  padding: const EdgeInsets.only(top: 2),
                                  onPressed: () {
                                    taskController.doNotUseTime(index);
                                    taskController.saveData(false, false, true, false, false);
                                  },
                                  splashRadius: 15,
                                  icon: const Icon(
                                    Icons.check_box_outlined,
                                    size: 22,
                                  ),
                                )
                              : IconButton(
                                  padding: const EdgeInsets.only(top: 2),
                                  onPressed: () {
                                    taskController.doUseTime(index);
                                    taskController.saveData(false, false, true, false, false);
                                  },
                                  splashRadius: 15,
                                  icon: const Icon(
                                    Icons.check_box_outline_blank,
                                    size: 22,
                                  ),
                                ),
                          title: (taskController.useTime[index])
                              ? Row(
                                  children: [
                                    Container(
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
                                            value: taskController.times[index].substring(0, 2),
                                            items: hourList.map((item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (item) {
                                              taskController.times[index] = item! + taskController.times[index].substring(2);
                                              taskController.saveData(false, false, false, true, false);
                                              FocusScope.of(context).requestFocus(FocusNode());
                                            },
                                          ),
                                          const Text(" : "),
                                          DropdownButton(
                                            underline: const SizedBox.shrink(),
                                            iconSize: 0,
                                            dropdownColor: Colors.white,
                                            value: taskController.times[index].substring(2, 4),
                                            items: minuteList.map((item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (item) {
                                              taskController.times[index] = taskController.times[index].substring(0, 2) +
                                                      item! + taskController.times[index].substring(4);
                                              taskController.saveData(false, false, false, true, false);
                                              FocusScope.of(context).requestFocus(FocusNode());
                                            },
                                          ),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 22),
                                    Container(
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
                                            value: taskController.times[index].substring(4, 6),
                                            items: hourList.map((item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (item) {
                                              taskController.times[index] = taskController.times[index].substring(0, 4) +
                                                      item! + taskController.times[index].substring(6);
                                              taskController.saveData(false, false, false, true, false);
                                              FocusScope.of(context).requestFocus(FocusNode());
                                            },
                                          ),
                                          const Text(" : "),
                                          DropdownButton(
                                            underline: const SizedBox.shrink(),
                                            iconSize: 0,
                                            dropdownColor: Colors.white,
                                            value: taskController.times[index].substring(6, 8),
                                            items: minuteList.map((item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (item) {
                                              taskController.times[index] =
                                                  taskController.times[index].substring(0, 6) +
                                                      item! + taskController.times[index].substring(8);
                                              taskController.saveData(false, false, false, true, false);
                                              FocusScope.of(context).requestFocus(FocusNode());
                                            },
                                          ),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 22),
                                    Container(
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
                                            value: taskController.times[index].substring(8, 10),
                                            items: hourList.map((item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (item) {
                                              taskController.times[index] = taskController.times[index].substring(0, 8) +
                                                      item! + taskController.times[index].substring(10);
                                              taskController.saveData(false, false, false, true, false);
                                              FocusScope.of(context).requestFocus(FocusNode());
                                            },
                                          ),
                                          const Text(" : "),
                                          DropdownButton(
                                            underline: const SizedBox.shrink(),
                                            iconSize: 0,
                                            dropdownColor: Colors.white,
                                            value: taskController.times[index].substring(10, 12),
                                            items: minuteList.map((item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (item) {
                                              taskController.times[index] = taskController.times[index].substring(0, 10) + item!;
                                              taskController.saveData(false, false, false, true, false);
                                              FocusScope.of(context).requestFocus(FocusNode());
                                            },
                                          ),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : const Text(
                                  "Disable the time check feature",
                                  style: TextStyle(color: Colors.black54),
                                ),
                        ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 0),
            ),
          ),
        ),
      ),
    );
  }
}
