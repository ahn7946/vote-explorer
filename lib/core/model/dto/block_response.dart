class BlockResponse {
  final bool success;
  final String message;
  final String status;
  final Block block;

  BlockResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.block,
  });

  factory BlockResponse.fromJson(Map<String, dynamic> json) {
    return BlockResponse(
      success: json['success'] == "true",
      message: json['message'],
      status: json['status'],
      block: Block.fromJson(json['block']),
    );
  }
}

class Block {
  final BlockHeader header;
  final String blockHash;
  final List<Transaction> transactions;

  Block({
    required this.header,
    required this.blockHash,
    required this.transactions,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      header: BlockHeader.fromJson(json['header']),
      blockHash: json['block_hash'],
      transactions: (json['transactions'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList(),
    );
  }
}

class BlockHeader {
  final String votingId;
  final String proposer;
  final String merkleRoot;
  final int height;
  final String prevBlockHash;

  BlockHeader({
    required this.votingId,
    required this.proposer,
    required this.merkleRoot,
    required this.height,
    required this.prevBlockHash,
  });

  factory BlockHeader.fromJson(Map<String, dynamic> json) {
    return BlockHeader(
      votingId: json['voting_id'],
      proposer: json['proposer'],
      merkleRoot: json['merkle_root'],
      height: json['height'],
      prevBlockHash: json['prev_block_hash'],
    );
  }
}

class Transaction {
  final String hash;
  final String option;
  final int timeStamp;

  Transaction({
    required this.hash,
    required this.option,
    required this.timeStamp,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      hash: json['hash'],
      option: json['option'],
      timeStamp: json['time_stamp'],
    );
  }
}
