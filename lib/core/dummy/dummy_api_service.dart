import 'dart:convert';
import 'package:vote_explorer/core/dummy/dummy_height_json.dart';
import 'package:vote_explorer/core/dummy/dummy_from_to_json.dart';
import 'package:vote_explorer/core/dummy/dummy_block_json.dart';
import 'package:vote_explorer/core/dummy/dummy_pending_json.dart';
import 'package:vote_explorer/core/dummy/dummy_query_json.dart';
import 'package:vote_explorer/core/dummy/dummy_txx_json.dart';

import 'package:vote_explorer/core/model/dto/height_response.dart';
import 'package:vote_explorer/core/model/dto/from_to_response.dart';
import 'package:vote_explorer/core/model/dto/block_response.dart';
import 'package:vote_explorer/core/model/dto/pending_response.dart';
import 'package:vote_explorer/core/model/dto/query_response.dart';
import 'package:vote_explorer/core/model/dto/txx_response.dart';

class DummyApiService {
  static Future<HeightResponse> fetchHeight() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return HeightResponse.fromJson(jsonDecode(dummyHeightJSON));
  }

  static Future<FromToResponse> fetchFromTo(int a, int b) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return FromToResponse.fromJson(jsonDecode(dummyFromToJSON));
  }

  static Future<BlockResponse> fetchBlock(String height) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return BlockResponse.fromJson(jsonDecode(dummyBlockJSON));
  }

  static Future<QueryResponse> fetchQuery(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return QueryResponse.fromJson(jsonDecode(dummyQueryJSON));
  }

  static Future<PendingResponse> fetchPending() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return PendingResponse.fromJson(jsonDecode(dummyPendingJSON));
  }

  static Future<TxxResponse> fetchTxxId(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return TxxResponse.fromJson(jsonDecode(dummyTxxJSON));
  }
}
