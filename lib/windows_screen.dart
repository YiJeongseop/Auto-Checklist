import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowsScreen extends StatelessWidget {
  const WindowsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragToResizeArea(
      child: DragToMoveArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFFDD),
          appBar: AppBar(
            iconTheme: const IconThemeData(
              size: 30,
              color: Colors.black54,
            ),
            backgroundColor: const Color(0xFFFFFEBB),
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
          body: const Center(child: Text("Temp(Windows)")),
        ),
      ),
    );
  }
}
