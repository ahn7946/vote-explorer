class Pending {
  final String proposal;
  final String proposer;
  final Map<String, int> optCache;

  Pending({
    required this.proposal,
    required this.proposer,
    required this.optCache,
  });

  factory Pending.fromJson(Map<String, dynamic> json) {
    return Pending(
      proposal: json['proposal'],
      proposer: json['proposer'],
      optCache: Map<String, int>.from(json['opt_cache']),
    );
  }
}

class PendingResponse {
  final bool success;
  final String message;
  final String status;
  final List<Pending> pendings;

  PendingResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.pendings,
  });

  factory PendingResponse.fromJson(Map<String, dynamic> json) {
    return PendingResponse(
      success: json['success'] == "true",
      message: json['message'],
      status: json['status'],
      pendings: (json['pendings'] as List<dynamic>)
          .map((e) => Pending.fromJson(e))
          .toList(),
    );
  }
}
