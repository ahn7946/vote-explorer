import 'package:vote_explorer/model/block_header.dart';

class QueryResponse {
  final bool success;
  final String message;
  final String status;
  final String type;
  final List<BlockHeader> headers;

  QueryResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.type,
    required this.headers,
  });

  factory QueryResponse.fromJson(Map<String, dynamic> json) {
    return QueryResponse(
      success: json['success'] == "true",
      message: json['message'],
      status: json['status'],
      type: json['type'],
      headers: (json['headers'] as List<dynamic>)
          .map((e) => BlockHeader.fromJson(e))
          .toList(),
    );
  }
}
