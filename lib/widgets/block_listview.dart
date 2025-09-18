import 'dart:math';
import 'package:flutter/material.dart';

class BlockListView extends StatefulWidget {
  const BlockListView({super.key});

  @override
  State<BlockListView> createState() => _BlockListViewState();
}

class _BlockListViewState extends State<BlockListView> {
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
    int blockHeight = 100;
    return SizedBox(
      height: 150,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 50,
        itemBuilder: (context, index) => index == 0
            ? BlockContainer("투표중", color1: Colors.black, color2: Colors.grey)
            : BlockContainer("# ${blockHeight - index}"),
      ),
    );
  }
}

class BlockContainer extends StatelessWidget {
  final String index;
  final Color? color1;
  final Color? color2;

  const BlockContainer(this.index, {this.color1, this.color2, super.key});

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
                color1 ?? const Color(0xFFFF7679),
                color2 ?? const Color(0xFFFCA79D),
              ],
              center: Alignment(x, y),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        Text(index)
      ],
    );
  }
}
