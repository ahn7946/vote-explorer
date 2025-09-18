import 'package:flutter/material.dart';
import 'package:vote_explorer/widgets/block_list_widget.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "✓OTING",
          style: TextStyle(
              fontFamily: "NotoSansKR",
              fontSize: 22.4,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          BlockListWidget(),
          // JsonWidget(),
        ],
      ),
    );
  }
}
