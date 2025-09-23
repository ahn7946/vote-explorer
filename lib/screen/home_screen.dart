import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/model/dto/from_to_response.dart';
import 'package:vote_explorer/style/text_style.dart';
import 'package:vote_explorer/widget/block_datatable.dart';
import 'package:vote_explorer/widget/block_listview.dart';
import 'package:vote_explorer/widget/voting_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FromToResponse? _fromToResponse;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFromTo();
  }

  Future<void> _loadFromTo() async {
    try {
      final blockHeightResponse = await ApiService.fetchHeight();
      int blockHeight = blockHeightResponse.height;
      final fromToResponse =
          await ApiService.fetchFromTo(blockHeight - 50, blockHeight);
      setState(() {
        _fromToResponse = fromToResponse;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching FromToResponse: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double horizontalPadding;
    if (kIsWeb) {
      // 웹일 때만 반응형 규칙 적용
      horizontalPadding = width > 1000 ? (width - 1000) / 4 : 0;
    } else {
      // 모바일 / 태블릿은 기본 패딩
      horizontalPadding = 0;
    }

    return Scaffold(
      appBar: VotingAppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        children: [
          SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                "블록 현황",
                style: AppTextStyle.title,
              ),
            ),
          ),
          BlockListView(),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _fromToResponse != null
                  // 직접 DI, OCP 위배? Singleton / Riverpod 적용 가능
                  ? BlockDatatable(response: _fromToResponse!)
                  : const Center(child: Text('데이터를 불러오지 못했습니다')),
          // JSONHighlightView(),
        ],
      ),
    );
  }
}
