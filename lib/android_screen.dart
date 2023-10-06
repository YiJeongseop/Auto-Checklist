import 'package:flutter/material.dart';

class AndroidScreen extends StatelessWidget {
  const AndroidScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Text("Temp(Android)"),
    );
  }
}