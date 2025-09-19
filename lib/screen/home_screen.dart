import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: VotingAppBar(),
      body: Column(
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
          BlockDatatable(),
          JSONHighlightView(),
        ],
      ),
    );
  }
}
