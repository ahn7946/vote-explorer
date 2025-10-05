import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/component/block_alert_dialog.dart';
import 'package:vote_explorer/core/model/dto/query_response.dart';
import 'package:vote_explorer/provider/query_provider.dart';
import 'package:vote_explorer/style/text_style.dart';

class QueryAlertDialog extends ConsumerWidget {
  final String query;

  const QueryAlertDialog(this.query, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QueryResponse? queryResponse = ref.watch(queryProvider);

    SizedBox buildEllipsedText(String text, double width) {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 비율 기반 최대/최소 크기
        final maxWidth = constraints.maxWidth * 0.6;
        final maxHeight = constraints.maxHeight * 0.5;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("검색 결과: $query"),
          content: SizedBox(
            width: maxWidth,
            height: maxHeight, // fetch 전후 동일
            child: queryResponse == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: false,
                      onSelectAll: null,
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(label: Text("블록 높이")),
                        DataColumn(label: Text("블록 도메인")),
                        DataColumn(label: Text("제안자")),
                        DataColumn(label: Text("머클 루트")),
                        DataColumn(label: Text("블록 해시")),
                        DataColumn(label: Text("이전 블록 해시")),
                      ],
                      rows: queryResponse.headers.map(
                        (header) {
                          return DataRow(
                            onSelectChanged: (_) {
                              // 클릭 즉시 다이얼로그 띄움
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    BlockAlertDialog(header.height),
                              );
                            },
                            cells: [
                              DataCell(buildEllipsedText(
                                  header.height.toString(), 120)),
                              DataCell(buildEllipsedText(header.votingId, 120)),
                              DataCell(buildEllipsedText(header.proposer, 120)),
                              DataCell(
                                  buildEllipsedText(header.merkleRoot, 120)),
                              DataCell(
                                  buildEllipsedText(header.blockHash, 120)),
                              DataCell(
                                  buildEllipsedText(header.prevBlockHash, 120)),
                            ],
                          );
                        },
                      ).toList(),
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
