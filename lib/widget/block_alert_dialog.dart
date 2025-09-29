import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/model/dto/block_response.dart';
import 'package:vote_explorer/provider/block_provider.dart';

class BlockAlertDialog extends ConsumerWidget {
  final int blockHeight;

  const BlockAlertDialog(this.blockHeight, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // fetch 실행 (현재 방식 유지)
    ref.read(blockProvider.notifier).fetchBlock(blockHeight);
    final BlockResponse? blockResponse = ref.read(blockProvider);

    Widget buildRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                value,
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    }

    if (blockResponse == null) {
      return const AlertDialog(
        content: Center(child: CircularProgressIndicator()),
      );
    }

    final block = blockResponse.block;
    final header = block.header;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text("블록 상세 (height: ${header.height})"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRow("블록 도메인", header.votingId),
            buildRow("제안자", header.proposer),
            buildRow("머클 루트", header.merkleRoot),
            buildRow("블록 해시", block.blockHash),
            buildRow("이전 블록 해시", header.prevBlockHash),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("투표 해시")),
                  DataColumn(label: Text("투표 선택지")),
                  DataColumn(label: Text("투표 시간")),
                ],
                rows: block.transactions.map((tx) {
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("닫기"),
        ),
      ],
    );
  }
}
