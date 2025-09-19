import 'dart:convert';
import 'package:vote_explorer/model/block_response.dart';
import 'package:vote_explorer/model/dummy_json.dart';
import 'package:vote_explorer/model/from_to_response.dart';
import 'package:vote_explorer/model/height_response.dart';

void dummyHeightResponseAPI() {
  final heightObj = HeightResponse.fromJson(json.decode(dummyHeightJSON));
  print(heightObj.height); // 7
}

void dummyFromToResponseAPI() {
  final fromToObj = FromToResponse.fromJson(json.decode(dummyFromToJSON));
  print(fromToObj.headers.first.votingId); // GENESIS
}

void dummyBlockAPI() {
  final blockObj = BlockResponse.fromJson(json.decode(dummyBlockJSON));
  print(blockObj.block.transactions.length); // 4
}
