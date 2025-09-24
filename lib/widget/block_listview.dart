import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/model/dto/block_response.dart';
import 'package:vote_explorer/style/text_style.dart';
import 'package:vote_explorer/widget/block_alert_dialog.dart';

// tight coupling / prop drilling -> provider 적용 필요
class BlockListView extends StatefulWidget {
  final int blockHeight;

  const BlockListView(this.blockHeight, {super.key});

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
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned(
            top: 85 / 2, // Container 높이 절반 위치
            left: 0,
            right: 0,
            child: Container(
              height: 2, // 선 두께
              color: Colors.grey.shade400,
            ),
          ),
          ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: 50,
            itemBuilder: (context, index) => index == 0
                ? BlockContainer("투표중",
                    color1: Colors.black, color2: Colors.grey)
                : BlockContainer("${widget.blockHeight - index + 1}"),
          ),
        ],
      ),
    );
  }
}

class BlockContainer extends StatefulWidget {
  final String blockIndex;
  final Color? color1;
  final Color? color2;

  const BlockContainer(this.blockIndex, {this.color1, this.color2, super.key});

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

  void _showDetailDialog(BuildContext context, BlockResponse response) {
    showDialog(
      context: context,
      builder: (context) {
        return BlockAlertDialog(response);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkResponse(
          containedInkWell: false, // 영역 제한 해제
          onTap: () async {
            final response = await ApiService.fetchBlock(widget.blockIndex);
            _showDetailDialog(context, response);
          },
          child: Container(
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
        ),
        Text(widget.blockIndex, style: AppTextStyle.blockTag),
      ],
    );
  }
}
