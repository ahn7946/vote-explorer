import 'package:dio/dio.dart';
import 'package:vote_explorer/model/block_response.dart';
import 'package:vote_explorer/model/from_to_response.dart';
import 'package:vote_explorer/model/height_response.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://l4.ai-capstone.store:8081/explorer',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<HeightResponse> fetchHeight() async {
    final response = await _dio.get('/height');
    return HeightResponse.fromJson(response.data);
  }

  static Future<FromToResponse> fetchFromTo(int a, int b) async {
    final response = await _dio.get('/headers?from=$a&to=$b');
    return FromToResponse.fromJson(response.data);
  }

  static Future<BlockResponse> fetchBlock(String blockHeight) async {
    final response = await _dio.get('/block?height=$blockHeight');
    return BlockResponse.fromJson(response.data);
  }
}
