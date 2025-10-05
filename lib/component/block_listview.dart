import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/model/entity/block_headers.dart';
import 'package:vote_explorer/provider/height_provider.dart';
import 'package:vote_explorer/style/text_style.dart';
import 'package:vote_explorer/component/block_alert_dialog.dart';
import 'package:vote_explorer/core/config/config.dart';

const double _kBlockSize = 79.0;
const double _kBlockMargin = 18.0;

// ------------------- StateNotifier -------------------
class BlockListNotifier extends StateNotifier<List<BlockHeaders>> {
  BlockListNotifier(this.ref) : super([]) {
    _init();
  }

  final Ref ref;
  bool _isFetching = false;

  Future<void> _init() async {
    await fetchMore();
  }

  Future<void> fetchMore() async {
    if (_isFetching) return;
    _isFetching = true;

    final height = ref.read(heightProvider)?.height ?? 0;
    final currentCount = state.length;
    final fetchSize = AppConfig.fetchSize;

    final from = max(0, height - currentCount - fetchSize);
    final to = height - currentCount;

    if (from >= to) {
      _isFetching = false;
      return; // 더 이상 로드할 블록 없음
    }

    try {
      final response = await ApiService.fetchFromTo(from, to);
      // append 기존 리스트 뒤에 붙이기
      state = [...state, ...response.headers.reversed];
    } catch (e) {
      // 에러 처리 필요 시 구현
      debugPrint('Error fetching blocks: $e');
    }

    _isFetching = false;
  }
}

final blockListNotifierProvider =
    StateNotifierProvider<BlockListNotifier, List<BlockHeaders>>(
        (ref) => BlockListNotifier(ref));

// ------------------- BlockListView -------------------
class BlockListView extends ConsumerStatefulWidget {
  const BlockListView({super.key});

  @override
  ConsumerState<BlockListView> createState() => _BlockListViewState();
}

class _BlockListViewState extends ConsumerState<BlockListView> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    ref.read(heightProvider.notifier).fetchHeight();
  }

  @override
  Widget build(BuildContext context) {
    final height = ref.watch(heightProvider)?.height;
    if (height == null || height == 0) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // height fetch 완료 후에 ScrollController 초기화
    _scrollController ??= ScrollController()
      ..addListener(() {
        if (_scrollController!.position.pixels >=
            _scrollController!.position.maxScrollExtent - 100) {
          ref.read(blockListNotifierProvider.notifier).fetchMore();
        }
      });

    final blocks = ref.watch(blockListNotifierProvider);

    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned(
            top: _kBlockSize / 2,
            left: 0,
            right: 0,
            child: Container(height: 2, color: Colors.grey.shade400),
          ),
          blocks.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: blocks.length,
                  itemBuilder: (context, index) {
                    final block = blocks[index];
                    return BlockContainer(
                      blockIndex: block.height.toString(),
                      votingId: block.votingId,
                    );
                  },
                ),
        ],
      ),
    );
  }
}

// ------------------- BlockContainer -------------------
class BlockContainer extends StatelessWidget {
  final String blockIndex;
  final String votingId;

  const BlockContainer({
    super.key,
    required this.blockIndex,
    required this.votingId,
  });

  Color _colorFromVotingId(String id) {
    final hash = id.codeUnits.fold(0, (prev, elem) => prev + elem);
    final r = (hash * 37) % 256;
    final g = (hash * 53) % 256;
    final b = (hash * 97) % 256;
    return Color.fromARGB(255, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorFromVotingId(votingId);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkResponse(
          containedInkWell: false,
          onTap: () {
            final blockHeight = int.parse(blockIndex);
            showDialog(
              context: context,
              builder: (_) => BlockAlertDialog(blockHeight),
            );
          },
          child: Container(
            width: _kBlockSize,
            height: _kBlockSize,
            margin: const EdgeInsets.symmetric(horizontal: _kBlockMargin),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.9,
                colors: [
                  color,
                  color.withOpacity(0.7),
                ],
                center: const Alignment(0, 0),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        Text(blockIndex, style: AppTextStyle.blockTag),
      ],
    );
  }
}
