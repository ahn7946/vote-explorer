import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/model/dto/txx_response.dart';

/// ==========================
/// Txx Provider
/// ==========================
///
/// - 역할: 특정 도메인 내 트랜잭션 조회
/// - API: GET `/explorer/mempool/txx?id={id}`
/// - 상태타입: [TxxResponse?]
class TxxNotifier extends Notifier<TxxResponse?> {
  @override
  TxxResponse? build() => null;

  /// 특정 도메인 내 트랜잭션 조회
  Future<void> fetchTxxId(String id) async {
    state = await ApiService.fetchTxxId(id);
  }
}

final txxProvider =
    NotifierProvider<TxxNotifier, TxxResponse?>(TxxNotifier.new);
