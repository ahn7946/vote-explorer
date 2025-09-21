class TxxResponse {
  final bool success;
  final String message;
  final String status;
  final Txx txx;

  TxxResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.txx,
  });

  factory TxxResponse.fromJson(Map<String, dynamic> json) {
    return TxxResponse(
      success: json['success'] == "true",
      message: json['message'],
      status: json['status'],
      txx: Txx.fromJson(json['txx']),
    );
  }
}

class Txx {
  final String proposal;
  final String proposer;
  final Map<String, String> pool;

  Txx({
    required this.proposal,
    required this.proposer,
    required this.pool,
  });

  factory Txx.fromJson(Map<String, dynamic> json) {
    return Txx(
      proposal: json['proposal'],
      proposer: json['Proposer'], // 주의: 대문자 P
      pool: Map<String, String>.from(json['pool']),
    );
  }
}
