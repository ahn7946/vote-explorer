class BlockHeader {
  final String votingId;
  final String merkleRoot;
  final int height;
  final String prevBlockHash;

  BlockHeader({
    required this.votingId,
    required this.merkleRoot,
    required this.height,
    required this.prevBlockHash,
  });

  factory BlockHeader.fromJson(Map<String, dynamic> json) {
    return BlockHeader(
      votingId: json['voting_id'],
      merkleRoot: json['merkle_root'],
      height: json['height'],
      prevBlockHash: json['prev_block_hash'],
    );
  }
}
