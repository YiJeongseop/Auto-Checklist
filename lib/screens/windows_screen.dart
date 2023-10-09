import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import '../controllers/task_controller.dart';
import '../controllers/pages_controller.dart';
import '../widgets/windows_widgets.dart';

class WindowsScreen extends StatelessWidget {
  WindowsScreen({Key? key}) : super(key: key);

  final TaskController taskController = Get.put(TaskController());
  final PagesController pagesController = Get.put(PagesController());

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
            backgroundColor: const Color(0xFFFFFEBB),
            leading: Obx(() => (pagesController.currentPage.value == 0)
                ? Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: iconButton(
                      iconData: Icons.add,
                      buttonFeature: ButtonFeature.add,
                      taskController: taskController,
                      size: 30,
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
                        icon: const Icon(
                          Icons.timer_outlined,
                          color: Colors.black54,
                          size: 30,
                        ),
                      )
                    : IconButton(
                        padding: const EdgeInsets.only(top: 2),
                        onPressed: () => pagesController.changePage(),
                        splashRadius: 15,
                        icon: const Icon(
                          Icons.notes,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
              ),
              IconButton(
                padding: const EdgeInsets.only(top: 2),
                onPressed: () => exit(0),
                splashRadius: 15,
                icon: const Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 30,
                ),
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
                              ? iconButton(
                                  iconData: Icons.check_box_outlined,
                                  buttonFeature: ButtonFeature.uncheck,
                                  taskController: taskController,
                                  index: index,
                                )
                              : iconButton(
                                  iconData: Icons.check_box_outline_blank,
                                  buttonFeature: ButtonFeature.check,
                                  taskController: taskController,
                                  index: index,
                                ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (taskController.editingIndex.value != index)
                                iconButton(
                                  iconData: Icons.edit,
                                  buttonFeature: ButtonFeature.edit,
                                  taskController: taskController,
                                  index: index,
                                ),
                              if (taskController.editingIndex.value == index)
                                iconButton(
                                  iconData: Icons.save_alt,
                                  buttonFeature: ButtonFeature.save,
                                  taskController: taskController,
                                  index: index,
                                ),
                              iconButton(
                                iconData: Icons.delete,
                                buttonFeature: ButtonFeature.delete,
                                taskController: taskController,
                                index: index,
                              ),
                            ],
                          ),
                        )
                      : ListTile(
                          horizontalTitleGap: 10,
                          contentPadding:
                              const EdgeInsets.only(left: 0, right: 0),
                          leading: (taskController.useTime[index])
                              ? iconButton(
                                  iconData: Icons.check_box_outlined,
                                  buttonFeature: ButtonFeature.noTime,
                                  taskController: taskController,
                                  index: index,
                                )
                              : iconButton(
                                  iconData: Icons.check_box_outline_blank,
                                  buttonFeature: ButtonFeature.time,
                                  taskController: taskController,
                                  index: index,
                                ),
                          title: (taskController.useTime[index])
                              ? Row(
                                  children: [
                                    timeContainer(
                                        taskController: taskController,
                                        index: index,
                                        context: context,
                                        order: 1,
                                    ),
                                    const SizedBox(width: 22),
                                    timeContainer(
                                      taskController: taskController,
                                      index: index,
                                      context: context,
                                      order: 2,
                                    ),
                                    const SizedBox(width: 22),
                                    timeContainer(
                                      taskController: taskController,
                                      index: index,
                                      context: context,
                                      order: 3,
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
