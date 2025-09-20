import 'package:flutter/material.dart';
import 'package:vote_explorer/model/from_to_response.dart';
import 'package:vote_explorer/widget/block_modal.dart';

class BlockDatatable extends StatelessWidget {
  final FromToResponse response;

  const BlockDatatable({super.key, required this.response});

  Widget _buildEllipsedText(String text) {
    return SizedBox(
      width: 200, // 셀의 최대 폭, 화면 크기에 맞춰 조절 가능
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis, // ...
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Height')),
          DataColumn(label: Text('Voting ID')),
          DataColumn(label: Text('Merkle Root')),
          DataColumn(label: Text('Block Hash')),
          DataColumn(label: Text('Prev Block Hash')),
        ],
        rows: response.headers.map((header) {
          return DataRow(
              cells: [
                DataCell(_buildEllipsedText(header.height.toString())),
                DataCell(_buildEllipsedText(header.votingId)),
                DataCell(_buildEllipsedText(header.merkleRoot)),
                DataCell(_buildEllipsedText(header.blockHash)),
                DataCell(_buildEllipsedText(header.prevBlockHash)),
              ],
              onSelectChanged: (_) {
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
              });
        }).toList(),
      ),
    );
  }
}
