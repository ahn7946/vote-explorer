import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/model/dto/query_response.dart';

/// ==========================
/// Query Provider
/// ==========================
///
/// - 역할: 도메인/해시/머클루트 기반 블록 조회
/// - API: GET `/query?target={query}`
/// - 상태타입: [QueryResponse?]
class QueryNotifier extends Notifier<QueryResponse?> {
  @override
  QueryResponse? build() => null;

  /// 블록 도메인/해시/머클루트 조회
  Future<QueryResponse?> fetchQuery(String query) async {
    state = null;
    state = await ApiService.fetchQuery(query);
    return state;
  }
}

final queryProvider =
    NotifierProvider<QueryNotifier, QueryResponse?>(QueryNotifier.new);
