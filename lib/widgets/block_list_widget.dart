import 'dart:math';
import 'package:flutter/material.dart';

class BlockListWidget extends StatefulWidget {
  const BlockListWidget({super.key});

  @override
  State<BlockListWidget> createState() => _BlockListWidgetState();
}

class _BlockListWidgetState extends State<BlockListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Text("END"),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 50,
        itemBuilder: (context, index) => BlockContainer(100 - index),
      ),
    );
  }
}

class BlockContainer extends StatelessWidget {
  final int index;

  const BlockContainer(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    // -1.0 ~ 1.0 범위의 double 값 생성
    double x = -1 + 2 * random.nextDouble();
    double y = -1 + 2 * random.nextDouble();
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 0.9,
              colors: [
                Color(0xFFFF6B6E),
                Color(0xFFFCA79D),
              ],
              center: Alignment(x, y),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        Text("#$index")
      ],
    );
  }
}
