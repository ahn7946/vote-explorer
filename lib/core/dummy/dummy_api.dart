import 'dart:convert';
import 'package:vote_explorer/core/dummy/dummy_block_json.dart';
import 'package:vote_explorer/core/dummy/dummy_from_to_json.dart';
import 'package:vote_explorer/core/dummy/dummy_height_json.dart';
import 'package:vote_explorer/core/dummy/dummy_pending_json.dart';
import 'package:vote_explorer/core/dummy/dummy_query_json.dart';
import 'package:vote_explorer/core/dummy/dummy_txx_id_json.dart';
import 'package:vote_explorer/core/logger/logger.dart';
import 'package:vote_explorer/core/model/block_response.dart';
import 'package:vote_explorer/core/model/from_to_response.dart';
import 'package:vote_explorer/core/model/height_response.dart';
import 'package:vote_explorer/core/model/pending_response.dart';
import 'package:vote_explorer/core/model/query_response.dart';
import 'package:vote_explorer/core/model/txx_id_response.dart';

/// 블록 현재 높이 (HeightResponse)
HeightResponse dummyHeightResponseAPI() {
  final heightObj = HeightResponse.fromJson(json.decode(dummyHeightJSON));
  logger.i('[Dummy API] HeightResponse 호출 완료');
  return heightObj;
}

/// 특정 범위 블록 헤더 조회 (FromToResponse)
FromToResponse dummyFromToResponseAPI() {
  final fromToObj = FromToResponse.fromJson(json.decode(dummyFromToJSON));
  logger.i('[Dummy API] FromToResponse 호출 완료');
  return fromToObj;
}

/// 특정 블록 상세 조회 (BlockResponse)
BlockResponse dummyBlockAPI() {
  final blockObj = BlockResponse.fromJson(json.decode(dummyBlockJSON));
  logger.i('[Dummy API] BlockResponse 호출 완료');
  return blockObj;
}

/// 블록 도메인/해시/머클루트 조회 (QueryResponse)
QueryResponse dummyQueryAPI() {
  final queryObj = QueryResponse.fromJson(json.decode(dummyQueryJSON));
  logger.i('[Dummy API] QueryResponse 호출 완료');
  return queryObj;
}

/// 메모리풀 대기 트랜잭션 조회 (PendingResponse)
PendingResponse dummyPendingAPI() {
  final pendingObj = PendingResponse.fromJson(json.decode(dummyPendingJSON));
  logger.i('[Dummy API] PendingResponse 호출 완료');
  return pendingObj;
}

/// 특정 도메인 트랜잭션 조회 (TxxResponse)
TxxResponse dummyTxxIdAPI() {
  final txxObj = TxxResponse.fromJson(json.decode(dummyTxxIdJSON));
  logger.i('[Dummy API] TxxResponse 호출 완료');
  return txxObj;
}
