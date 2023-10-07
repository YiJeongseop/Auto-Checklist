import 'dart:io';
import 'package:auto_checklist/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class WindowsScreen extends StatelessWidget {
  WindowsScreen({Key? key}) : super(key: key);
  final TaskController taskController = Get.put(TaskController());

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
            leading: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                padding: const EdgeInsets.only(top: 2),
                onPressed: () {
                  taskController.addTask(Task(seconds: 0, timeList: []));
                },
                splashRadius: 15,
                icon: const Icon(Icons.add),
              ),
            ),
            actions: [
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
                  () => ListTile(
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(left: 0, right: 0),
                    title: (taskController.editingIndex.value == index)
                        ? TextFormField(
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.only(bottom: 7, top: 7),
                            ),
                            maxLines: null,
                            initialValue:
                                (taskController.tasks[index].content ==
                                        'Add Content')
                                    ? ''
                                    : taskController.tasks[index].content,
                            onChanged: (value) {
                              taskController.editingContent.value = value;
                            },
                          )
                        : Text(
                            taskController.tasks[index].content,
                            style: TextStyle(
                                color: (taskController.tasks[index].content ==
                                        'Add Content')
                                    ? Colors.black38
                                    : Colors.black,
                                decoration: taskController.isCompleted[index]
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                    leading: (taskController.isCompleted[index])
                        ? IconButton(
                            padding: const EdgeInsets.only(top: 2),
                            onPressed: () {
                              taskController.beNotCompleted(index);
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
                                  taskController.tasks[index].content;
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
                              taskController.tasks[index].content =
                                  taskController.editingContent.value;
                              taskController.editingContent.value = '';
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
