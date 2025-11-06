import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/component/block_alert_dialog.dart';
import 'package:vote_explorer/component/widget/button.dart';
import 'package:vote_explorer/core/model/dto/query_response.dart';
import 'package:vote_explorer/provider/query_provider.dart';
import 'package:vote_explorer/style/size/datatable_size.dart';
import 'package:vote_explorer/style/text_style.dart';

class QueryAlertDialog extends ConsumerWidget {
  final String query;

  const QueryAlertDialog(this.query, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QueryResponse? queryResponse = ref.watch(queryProvider);

    /// ✅ 라벨 길이 통일 + 복사 버튼 추가한 공용 위젯
    Widget buildRow(String label, String value, double maxRowWidth) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxRowWidth),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
              ),
              const Text(":  "),
              // 텍스트 + 버튼 묶음
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisSize: MainAxisSize.min, // 최소 공간만 사용
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth - 30, // 버튼 공간 확보
                          ),
                          child: Text(
                            value,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: const TextStyle(fontSize: 19),
                          ),
                        ),
                        const SizedBox(width: 4),
                        buildCopyIconButton(context, value),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const double minWidth = 100.0;
        final double maxWidth = constraints.maxWidth * 0.5;
        final double maxHeight = constraints.maxHeight * 0.6;

        final List<double> columnWidths = widths
            .map((r) => (r * maxWidth).clamp(minWidth, double.infinity))
            .toList();

        final columnLabels = [
          "블록 높이",
          "블록 도메인",
          "제안자",
          "머클 루트",
          "블록 해시",
          "이전 블록 해시"
        ];

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "🔍 검색 결과",
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          content: SizedBox(
            width: maxWidth,
            height: maxHeight,
            child: queryResponse == null
                ? const Center(child: CircularProgressIndicator())
                : (queryResponse.type == null || queryResponse.headers.isEmpty)
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "🥹 검색 결과가 존재하지 않습니다. 🥹",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "'블록 높이', '블록 도메인', '제안자', '머클 루트' 또는 '블록 해시' 를 정확하게 입력해주세요!",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRow("검색어", query, maxWidth),
                            buildRow("검색어 유형",
                                translateType(queryResponse.type), maxWidth),
                            ConstrainedBox(
                              constraints: BoxConstraints(minWidth: maxWidth),
                              child: DataTable(
                                showCheckboxColumn: false,
                                columnSpacing: 16,
                                columns: List.generate(
                                  columnLabels.length,
                                  (i) => DataColumn(
                                    label: Text(columnLabels[i],
                                        style: AppTextStyle.tableAttribute),
                                  ),
                                ),
                                rows: queryResponse.headers.map((header) {
                                  final values = [
                                    header.height.toString(),
                                    header.votingId,
                                    header.proposer,
                                    header.merkleRoot,
                                    header.blockHash,
                                    header.prevBlockHash,
                                  ];

                                  return DataRow(
                                    onSelectChanged: (_) {
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                            BlockAlertDialog(header.height),
                                      );
                                    },
                                    cells: List.generate(values.length, (i) {
                                      final text = values[i];
                                      final width = columnWidths[i];

                                      return DataCell(
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  text,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style:
                                                      AppTextStyle.tableTuple,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              buildCopyIconButton(
                                                  context, text),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
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

String translateType(String? type) {
  switch (type) {
    case "id":
      return "블록 도메인";
    case "proposer":
      return "제안자";
    case "height":
      return "블록 높이";
    case "merkle_root":
      return "머클 루트";
    case "block_hash":
      return "블록 해시";
    default:
      return type ?? "-";
  }
}
