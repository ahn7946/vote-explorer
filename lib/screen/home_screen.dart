import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vote_explorer/api/dummy_api.dart';
import 'package:vote_explorer/widget/block_datatable.dart';
import 'package:vote_explorer/widget/block_listview.dart';
import 'package:vote_explorer/widget/json_hightlight_view.dart';
import 'package:vote_explorer/widget/voting_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double horizontalPadding;
    if (kIsWeb) {
      // 웹일 때만 반응형 규칙 적용
      horizontalPadding = width > 1000 ? (width - 1000) / 4 : 16.0;
    } else {
      // 모바일 / 태블릿은 기본 패딩
      horizontalPadding = 16.0;
    }

    return Scaffold(
      appBar: VotingAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: Text(
                  "블록 현황",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            BlockListView(),
            BlockDatatable(response: dummyFromToResponseAPI()),
            JSONHighlightView(),
          ],
        ),
      ),
    );
  }
}
