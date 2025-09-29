import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/model/dto/pending_response.dart';

/// ==========================
/// Pending Provider
/// ==========================
///
/// - 역할: 메모리풀에 대기 중인 트랜잭션 조회
/// - API: GET `/explorer/mempool/pending`
/// - 상태타입: [PendingResponse?]
class PendingNotifier extends Notifier<PendingResponse?> {
  @override
  PendingResponse? build() => null;

  /// 대기 중인 트랜잭션 조회
  Future<void> fetchPending() async {
    state = await ApiService.fetchPending();
  }
}

final pendingProvider =
    NotifierProvider<PendingNotifier, PendingResponse?>(PendingNotifier.new);
