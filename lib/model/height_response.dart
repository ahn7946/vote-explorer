class HeightResponse {
  final bool success;
  final String message;
  final String status;
  final int height;

  HeightResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.height,
  });

  factory HeightResponse.fromJson(Map<String, dynamic> json) {
    return HeightResponse(
      success: json['success'] == "true",
      message: json['message'],
      status: json['status'],
      height: json['height'],
    );
  }
}
