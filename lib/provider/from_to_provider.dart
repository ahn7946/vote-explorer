import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/model/dto/from_to_response.dart';

/// ==========================
/// FromTo Provider
/// ==========================
///
/// - 역할: 특정 구간의 블록 헤더 조회
/// - API: GET `/headers?from={a}&to={b}`
/// - 상태타입: [FromToResponse?]
class FromToNotifier extends Notifier<FromToResponse?> {
  @override
  FromToResponse? build() => null;

  /// 특정 구간의 블록 헤더 조회
  Future<FromToResponse?> fetchFromTo(int from, int to) async {
    state = null;
    state = await ApiService.fetchFromTo(from, to);
    return state;
  }
}

final fromToProvider =
    NotifierProvider<FromToNotifier, FromToResponse?>(FromToNotifier.new);
