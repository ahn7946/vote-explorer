import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/model/dto/block_response.dart';

/// ==========================
/// Block Provider
/// ==========================
///
/// - 역할: 특정 블록 상세 조회
/// - API: GET `/block?height={blockHeight}`
/// - 상태타입: [BlockResponse?]
class BlockNotifier extends Notifier<BlockResponse?> {
  @override
  BlockResponse? build() => null;

  /// 특정 블록 높이의 블록 상세 조회
  Future<BlockResponse?> fetchBlock(int height) async {
    state = null;
    state = await ApiService.fetchBlock(height);
    return state;
  }
}

final blockProvider =
    NotifierProvider<BlockNotifier, BlockResponse?>(BlockNotifier.new);
