import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vote_explorer/style/text_style.dart';

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

class BlockContainer extends StatefulWidget {
  final String index;
  final Color? color1;
  final Color? color2;

  const BlockContainer(this.index, {this.color1, this.color2, super.key});

  @override
  State<BlockContainer> createState() => _BlockContainerState();
}

class _BlockContainerState extends State<BlockContainer> {
  late final double x;
  late final double y;

  @override
  void initState() {
    super.initState();
    final random = Random();
    // -1.0 ~ 1.0 범위의 double 값 생성
    x = -1 + 2 * random.nextDouble();
    y = -1 + 2 * random.nextDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 85,
          height: 85,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 0.9,
              colors: [
                widget.color1 ?? const Color(0xFFFF7679),
                widget.color2 ?? const Color(0xFFFCA79D),
              ],
              center: Alignment(x, y),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        Text(widget.index, style: AppTextStyle.blockTag),
      ],
    );
  }
}
