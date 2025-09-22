import 'package:flutter/material.dart';
import 'package:vote_explorer/core/model/block_response.dart';

class BlockAlertDialog extends StatelessWidget {
  final BlockResponse response;
  const BlockAlertDialog(this.response, {super.key});

  @override
  Widget build(BuildContext context) {
    final header = response.block.header;

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

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text("블록 상세 (height: ${header.height})"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRow("Voting ID", header.votingId),
            buildRow("Proposer", header.proposer),
            buildRow("Merkle Root", header.merkleRoot),
            buildRow("Block Hash", header.blockHash),
            buildRow("Prev Block Hash", header.prevBlockHash),
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
