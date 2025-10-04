import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/provider/block_provider.dart';
import 'package:vote_explorer/provider/height_provider.dart';
import 'package:vote_explorer/style/text_style.dart';
import 'package:vote_explorer/widget/block_alert_dialog.dart';
import 'package:vote_explorer/core/config/config.dart';

class BlockListView extends ConsumerStatefulWidget {
  const BlockListView({super.key});

  @override
  ConsumerState<BlockListView> createState() => _BlockListViewState();
}

class _BlockListViewState extends ConsumerState<BlockListView> {
  final ScrollController _scrollController = ScrollController();
  int _visibleCount = AppConfig.fetchSize;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final blockHeight = ref.read(heightProvider)?.height ?? 0;
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _visibleCount = min(blockHeight, _visibleCount + AppConfig.fetchSize);
        });
      }
    });

    // 초기 fetch
    ref.read(heightProvider.notifier).fetchHeight();
  }

  @override
  Widget build(BuildContext context) {
    final blockHeight = ref.watch(heightProvider)?.height ?? 0;

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
            itemCount: _visibleCount + 1, // 투표중 + 제네시스
            itemBuilder: (context, index) {
              final blockNumber = blockHeight - (index);
              if (blockNumber < 0) return const SizedBox();
              return BlockContainer(blockNumber.toString());
            },
          ),
        ],
      ),
    );
  }
}

class BlockContainer extends ConsumerStatefulWidget {
  final String blockIndex;
  final Color? color1;
  final Color? color2;

  const BlockContainer(this.blockIndex, {this.color1, this.color2, super.key});

  @override
  ConsumerState<BlockContainer> createState() => _BlockContainerState();
}

class _BlockContainerState extends ConsumerState<BlockContainer> {
  late final double x;
  late final double y;

  @override
  void initState() {
    super.initState();
    final random = Random();
    x = -1 + 2 * random.nextDouble();
    y = -1 + 2 * random.nextDouble();
  }

  void _showDetailDialog(BuildContext context, int blockHeight) {
    showDialog(context: context, builder: (_) => BlockAlertDialog(blockHeight));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkResponse(
          containedInkWell: false,
          onTap: () {
            final blockHeight = int.parse(widget.blockIndex);
            showDialog(
              context: context,
              builder: (_) => BlockAlertDialog(blockHeight),
            );
          },
          child: Container(
            width: 85,
            height: 85,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.9,
                colors: [
                  widget.color1 ?? const Color(0xFFFF7679),
                  widget.color2 ?? const Color(0xFFFCA79D),
                ],
                center: Alignment(x, y),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        Text(widget.blockIndex, style: AppTextStyle.blockTag),
      ],
    );
  }
}
