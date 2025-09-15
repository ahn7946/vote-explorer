import 'package:flutter/material.dart';
import '../widgets/json_widget.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key, required this.title});
  final String title;

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: JsonWidget(),
    );
  }
}
