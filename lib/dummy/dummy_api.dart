import 'dart:convert';
import 'package:vote_explorer/dummy/dummy_block_json.dart';
import 'package:vote_explorer/dummy/dummy_from_to_json.dart';
import 'package:vote_explorer/dummy/dummy_height_json.dart';
import 'package:vote_explorer/model/block_response.dart';
import 'package:vote_explorer/model/from_to_response.dart';
import 'package:vote_explorer/model/height_response.dart';

HeightResponse dummyHeightResponseAPI() {
  final heightObj = HeightResponse.fromJson(json.decode(dummyHeightJSON));
  print(heightObj.height); // 7
  return heightObj;
}

FromToResponse dummyFromToResponseAPI() {
  final fromToObj = FromToResponse.fromJson(json.decode(dummyFromToJSON));
  print(fromToObj.headers.first.votingId); // GENESIS
  return fromToObj;
}

BlockResponse dummyBlockAPI() {
  final blockObj = BlockResponse.fromJson(json.decode(dummyBlockJSON));
  print(blockObj.block.transactions.length); // 4
  return blockObj;
}
