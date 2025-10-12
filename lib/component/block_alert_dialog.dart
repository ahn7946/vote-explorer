// TODO: 컬렉션 기반 리팩토링, 너비 조정, Expanded 적용?

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vote_explorer/component/widget/button.dart';
import 'package:vote_explorer/provider/block_provider.dart';

class BlockAlertDialog extends ConsumerStatefulWidget {
  final int blockHeight;

  const BlockAlertDialog(this.blockHeight, {super.key});

  @override
  ConsumerState<BlockAlertDialog> createState() => _BlockAlertDialogState();
}

class _BlockAlertDialogState extends ConsumerState<BlockAlertDialog> {
  String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "-";

    final ts = int.tryParse(timestamp.toString());
    if (ts == null) return timestamp.toString();

    // 초 단위 + 나노초 분리
    final seconds = ts ~/ 1000000000;
    final nanoseconds = ts % 1000000000;

    // UTC 기준 → 한국시간(KST, UTC+9)
    final date =
        DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true)
            .add(const Duration(hours: 9));

    // 보기 좋은 형식: "2025-07-14 09:08:05.889704400"
    final formatted =
        "${DateFormat('yyyy-MM-dd HH:mm:ss').format(date)}.${nanoseconds.toString().padLeft(9, '0')}";

    return formatted;
  }

  @override
  void initState() {
    super.initState();
    // 빌드 완료 후 비동기로 fetch 실행 → Riverpod 오류 방지
    Future.microtask(() {
      ref.read(blockProvider.notifier).fetchBlock(widget.blockHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    final blockResponse = ref.watch(blockProvider);

    /// ✅ 라벨 길이 통일 + 복사 버튼 추가한 공용 위젯
    Widget buildRow(String label, String value, double maxRowWidth) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxRowWidth),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 130, // 라벨 고정
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
              ),
              const Text(": "),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 19,
                  ),
                ),
              ),
              SizedBox(width: 10),
              buildCopyIconButton(context, value),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 비율 기반 최대/최소 크기
        final maxWidth = constraints.maxWidth * 0.6;
        final maxHeight = constraints.maxHeight * 0.5;

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "블록 조회 (블록 높이: ${widget.blockHeight})",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          content: SizedBox(
            width: maxWidth,
            height: maxHeight, // fetch 전후 동일
            child: blockResponse == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRow("블록 도메인", blockResponse.block.header.votingId,
                            maxWidth),
                        buildRow("제안자", blockResponse.block.header.proposer,
                            maxWidth),
                        buildRow("머클 루트", blockResponse.block.header.merkleRoot,
                            maxWidth),
                        buildRow(
                            "블록 해시", blockResponse.block.blockHash, maxWidth),
                        buildRow("이전 블록 해시",
                            blockResponse.block.header.prevBlockHash, maxWidth),
                        const SizedBox(height: 30),
                        const Text("트랜잭션",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("투표 해시")),
                              DataColumn(label: Text("투표 선택지")),
                              DataColumn(label: Text("투표 시간 (KST)")),
                            ],
                            rows: blockResponse.block.transactions.map((tx) {
                              String time =
                                  formatTimestamp(tx.timeStamp.toString());

                              return DataRow(
                                cells: [
                                  // TODO: 컬렉션 기반 리팩토링, 너비 조정, Expanded 적용?
                                  DataCell(
                                    Row(
                                      children: [
                                        Text(tx.hash),
                                        buildCopyIconButton(context, tx.hash)
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        Text(tx.option),
                                        buildCopyIconButton(context, tx.hash)
                                      ],
                                    ),
                                  ),
                                  DataCell(Row(
                                    children: [
                                      Text(time),
                                      buildCopyIconButton(context, time),
                                    ],
                                  )),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }
}
