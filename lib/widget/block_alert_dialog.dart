import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/provider/block_provider.dart';

class BlockAlertDialog extends ConsumerStatefulWidget {
  final int blockHeight;
  const BlockAlertDialog(this.blockHeight, {super.key});

  @override
  ConsumerState<BlockAlertDialog> createState() => _BlockAlertDialogState();
}

class _BlockAlertDialogState extends ConsumerState<BlockAlertDialog> {
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

    Widget buildRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$label: ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(value, softWrap: true)),
          ],
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
          title: Text("블록 상세 (height: ${widget.blockHeight})"),
          content: SizedBox(
            width: maxWidth,
            height: maxHeight, // fetch 전후 동일
            child: blockResponse == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRow("블록 도메인", blockResponse.block.header.votingId),
                        buildRow("제안자", blockResponse.block.header.proposer),
                        buildRow(
                            "머클 루트", blockResponse.block.header.merkleRoot),
                        buildRow("블록 해시", blockResponse.block.blockHash),
                        buildRow("이전 블록 해시",
                            blockResponse.block.header.prevBlockHash),
                        const SizedBox(height: 30),
                        const Text("트랜잭션",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("투표 해시")),
                              DataColumn(label: Text("투표 선택지")),
                              DataColumn(label: Text("투표 시간")),
                            ],
                            rows: blockResponse.block.transactions.map((tx) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(tx.hash)),
                                  DataCell(Text(tx.option)),
                                  DataCell(Text(tx.timeStamp.toString())),
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
