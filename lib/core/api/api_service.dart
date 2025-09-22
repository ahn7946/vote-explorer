import 'package:dio/dio.dart';
import 'package:vote_explorer/core/logger/logger.dart';
import 'package:vote_explorer/core/model/block_response.dart';
import 'package:vote_explorer/core/model/from_to_response.dart';
import 'package:vote_explorer/core/model/height_response.dart';
import 'package:vote_explorer/core/model/pending_response.dart';
import 'package:vote_explorer/core/model/query_response.dart';
import 'package:vote_explorer/core/model/txx_id_response.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://l4.ai-capstone.store:8081/explorer',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// API: `GET /height`
  ///
  /// 블록의 현재 높이를 조회한다.
  ///
  /// Returns [HeightResponse] - 현재 블록 높이 정보
  static Future<HeightResponse> fetchHeight() async {
    try {
      final response = await _dio.get('/height');
      final result = HeightResponse.fromJson(response.data);
      logger.i('[API SUCCESS] HeightResponse 호출 완료');
      return result;
    } catch (e, st) {
      logger.e('[API ERROR] HeightResponse 호출 실패', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// API: `GET /headers?from={a}&to={b}`
  ///
  /// 특정 범위의 블록 헤더들을 조회한다.
  ///
  /// [a] - 시작 블록 높이
  /// [b] - 종료 블록 높이
  ///
  /// Returns [FromToResponse] - 지정된 범위의 블록 헤더 리스트
  static Future<FromToResponse> fetchFromTo(int a, int b) async {
    try {
      final response = await _dio.get('/headers?from=$a&to=$b');
      final result = FromToResponse.fromJson(response.data);
      logger.i('[API SUCCESS] FromToResponse 호출 완료 (from: $a, to: $b)');
      return result;
    } catch (e, st) {
      logger.e('[API ERROR] FromToResponse 호출 실패 (from: $a, to: $b)',
          error: e, stackTrace: st);
      rethrow;
    }
  }

  /// API: `GET /block?height={blockHeight}`
  ///
  /// [blockHeight] - 조회할 블록 높이
  ///
  /// 특정 블록 높이를 기준으로 블록 상세 정보를 조회한다.
  ///
  /// Returns [BlockResponse] - 블록 상세 정보
  static Future<BlockResponse> fetchBlock(String blockHeight) async {
    try {
      final response = await _dio.get('/block?height=$blockHeight');
      final result = BlockResponse.fromJson(response.data);
      logger.i('[API SUCCESS] BlockResponse 호출 완료 (height: $blockHeight)');
      return result;
    } catch (e, st) {
      logger.e('[API ERROR] BlockResponse 호출 실패 (height: $blockHeight)',
          error: e, stackTrace: st);
      rethrow;
    }
  }

  /// API: `GET /query?target={query}`
  ///
  /// [query] - 조회 대상 문자열 (블록 도메인 / 블록 해시 / 머클루트)
  ///
  /// 블록 도메인, 블록 해시, 머클루트를 기준으로 블록 정보를 조회한다.
  ///
  /// Returns [QueryResponse] - 조회된 블록 정보
  static Future<QueryResponse> fetchQuery(String query) async {
    try {
      final response = await _dio.get('/query?target=$query');
      final result = QueryResponse.fromJson(response.data);
      logger.i('[API SUCCESS] QueryResponse 호출 완료 (query: $query)');
      return result;
    } catch (e, st) {
      logger.e('[API ERROR] QueryResponse 호출 실패 (query: $query)',
          error: e, stackTrace: st);
      rethrow;
    }
  }

  /// API: `GET /explorer/mempool/pending`
  ///
  /// 현재 메모리풀에 존재하는 모든 대기 중인 트랜잭션들을 조회한다.
  ///
  /// Returns [PendingResponse] - 대기 중인 트랜잭션 목록
  static Future<PendingResponse> fetchPending() async {
    try {
      final response = await _dio.get('/explorer/mempool/pending');
      final result = PendingResponse.fromJson(response.data);
      logger.i('[API SUCCESS] PendingResponse 호출 완료');
      return result;
    } catch (e, st) {
      logger.e('[API ERROR] PendingResponse 호출 실패', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// API: `GET /explorer/mempool/txx?id={id}`
  ///
  /// [id] - 블록 도메인
  ///
  /// 특정 블록 도메인에 속한 트랜잭션 상세 정보를 조회한다.
  ///
  /// Returns [TxxResponse] - 해당 도메인의 트랜잭션 정보
  static Future<TxxResponse> fetchTxxId(String id) async {
    try {
      final response = await _dio.get('/explorer/mempool/txx?id=$id');
      final result = TxxResponse.fromJson(response.data);
      logger.i('[API SUCCESS] TxxResponse 호출 완료 (id: $id)');
      return result;
    } catch (e, st) {
      logger.e('[API ERROR] TxxResponse 호출 실패 (id: $id)',
          error: e, stackTrace: st);
      rethrow;
    }
  }
}
