class BlockHeaders {
  final String votingId;
  final String proposer;
  final String merkleRoot;
  final int height;
  final String blockHash;
  final String prevBlockHash;

  BlockHeaders({
    required this.votingId,
    required this.proposer,
    required this.merkleRoot,
    required this.height,
    required this.blockHash,
    required this.prevBlockHash,
  });

  factory BlockHeaders.fromJson(Map<String, dynamic> json) {
    return BlockHeaders(
      votingId: json['voting_id'],
      proposer: json['proposer'],
      merkleRoot: json['merkle_root'],
      height: json['height'],
      blockHash: json['block_hash'],
      prevBlockHash: json['prev_block_hash'],
    );
  }
}
