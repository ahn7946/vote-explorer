import 'package:flutter/material.dart';
import 'package:vote_explorer/model/block_header.dart';
import 'package:vote_explorer/model/from_to_response.dart';
import 'package:vote_explorer/widget/block_modal.dart';

class BlockDatatable extends StatelessWidget {
  final FromToResponse response;

  static const _columnLabels = [
    '블록 높이',
    '블록 도메인',
    '머클 루트',
    '블록 해시',
    '이전 블록 해시',
  ];

  static const _widths = [
    // 각 열 너비 비율 설정 (합 = 1.0)
    0.1, // 블록 높이
    0.15, // 블록 도메인
    0.2333, // 머클 루트
    0.2333, // 블록 해시
    0.2333, // 이전 블록 해시
  ];

  const BlockDatatable({super.key, required this.response});

  SizedBox _buildEllipsedText(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis, // ...
      ),
    );
  }

  void _showDetailDialog(BuildContext context, BlockHeader header) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: BlockModalContent(header: header),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double totalWidth = constraints.maxWidth;
      final List<double> columnWidths =
          _widths.map((ratio) => ratio * totalWidth).toList();

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          onSelectAll: null,
          columns: _columnLabels
              .map((label) => DataColumn(label: Text(label)))
              .toList(),
          rows: response.headers.reversed.map((header) {
            final values = [
              header.height.toString(),
              header.votingId,
              header.merkleRoot,
              header.blockHash,
              header.prevBlockHash,
            ];
            return DataRow(
              onSelectChanged: (_) => _showDetailDialog(context, header),
              cells: List.generate(values.length, (i) {
                // 블록 높이는 생략 없이 보여주고 나머지만 ellipsis 적용
                final textWidget = (i == 0)
                    ? Text(values[i])
                    : _buildEllipsedText(values[i], columnWidths[i]);
                return DataCell(textWidget);
              }),
            );
          }).toList(),
        ),
      );
    });
  }
}
