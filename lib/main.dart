import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'windows_screen.dart';

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();

  Display primaryDisplay = await screenRetriever.getPrimaryDisplay();

  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setTitle("Auto Checklist");
    await windowManager.setAsFrameless();
    await windowManager.setPosition(Offset(primaryDisplay.size.width - 350, 50.0));
    await windowManager.setSize(const Size(320, 320));
    await windowManager.setMaximumSize(const Size(600, 600));
    await windowManager.setMinimumSize(const Size(320, 320));
    await windowManager.show();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Auto Checklist',
      debugShowCheckedModeBanner: false,
      home: WindowsScreen(),
    );
  }
}