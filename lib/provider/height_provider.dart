import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/model/dto/height_response.dart';

/// ==========================
/// Height Provider
/// ==========================
///
/// - 역할: 현재 블록 높이 조회
/// - API: GET `/height`
/// - 상태타입: [HeightResponse?]
class HeightNotifier extends Notifier<HeightResponse?> {
  @override
  HeightResponse? build() => null;

  /// 현재 블록 높이 조회 API 호출
  Future<void> fetchHeight() async {
    state = await ApiService.fetchHeight();
  }
}

final heightProvider =
    NotifierProvider<HeightNotifier, HeightResponse?>(HeightNotifier.new);
