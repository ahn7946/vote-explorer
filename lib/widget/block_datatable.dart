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

  const BlockDatatable({super.key, required this.response});

  SizedBox _buildEllipsedText(String text) {
    return SizedBox(
      width: 300, // 셀의 최대 폭, 화면 크기에 맞춰 조절 가능
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        onSelectAll: null,
        columns: _columnLabels
            .map((label) => DataColumn(label: Text(label)))
            .toList(),
        rows: response.headers.reversed.map((header) {
          return DataRow(
            cells: [
              header.height.toString(),
              header.votingId,
              header.merkleRoot,
              header.blockHash,
              header.prevBlockHash,
            ]
                .map(
                  (value) => DataCell(
                    _buildEllipsedText(value),
                    onTap: () => _showDetailDialog(context, header),
                  ),
                )
                .toList(),
          );
        }).toList(),
      ),
    );
  }
}
