import 'package:flutter/material.dart';
import 'package:vote_explorer/core/model/block_header.dart';

class BlockModalContent extends StatelessWidget {
  final BlockHeader header;
  const BlockModalContent({required this.header, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Height: ${header.height}"),
        Text("Voting ID: ${header.votingId}"),
        Text("Merkle Root: ${header.merkleRoot}"),
        Text("Block Hash: ${header.blockHash}"),
        Text("Prev Hash: ${header.prevBlockHash}"),
      ],
    );
  }
}
