import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/model/dto/query_response.dart';
import 'package:vote_explorer/provider/query_provider.dart';
import 'package:vote_explorer/style/text_style.dart';

class QueryAlertDialog extends ConsumerWidget {
  final String query;

  const QueryAlertDialog(this.query, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QueryResponse? response = ref.watch(queryProvider);

    SizedBox _buildEllipsedText(String text, double width) {
      return SizedBox(
        width: width,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // ...
          style: AppTextStyle.tableTuple,
        ),
      );
    }

    if (response == null) {
      return const AlertDialog(
        content: Center(child: CircularProgressIndicator()),
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text("검색 결과: $query"),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16,
          columns: const [
            DataColumn(label: Text("블록 높이")),
            DataColumn(label: Text("블록 도메인")),
            DataColumn(label: Text("제안자")),
            DataColumn(label: Text("머클 루트")),
            DataColumn(label: Text("블록 해시")),
            DataColumn(label: Text("이전 블록 해시")),
          ],
          rows: response.headers.map((header) {
            return DataRow(
              cells: [
                DataCell(_buildEllipsedText(header.height.toString(), 120)),
                DataCell(_buildEllipsedText(header.votingId, 120)),
                DataCell(_buildEllipsedText(header.proposer, 120)),
                DataCell(_buildEllipsedText(header.merkleRoot, 120)),
                DataCell(_buildEllipsedText(header.blockHash, 120)),
                DataCell(_buildEllipsedText(header.prevBlockHash, 120)),
              ],
            );
          }).toList(),
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
