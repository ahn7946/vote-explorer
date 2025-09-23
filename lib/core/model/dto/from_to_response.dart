import 'package:vote_explorer/core/model/entity/block_headers.dart';

class FromToResponse {
  final bool success;
  final String message;
  final String status;
  final int from;
  final int to;
  final List<BlockHeaders> headers;

  FromToResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.from,
    required this.to,
    required this.headers,
  });

  factory FromToResponse.fromJson(Map<String, dynamic> json) {
    return FromToResponse(
      success: json['success'] == "true",
      message: json['message'],
      status: json['status'],
      from: json['from'],
      to: json['to'],
      headers: (json['headers'] as List)
          .map((e) => BlockHeaders.fromJson(e))
          .toList(),
    );
  }
}
