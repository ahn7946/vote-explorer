import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/component/block_listview.dart';
import 'package:vote_explorer/component/page_block_datatable.dart';
import 'package:vote_explorer/component/voting_appbar.dart';
import 'package:vote_explorer/style/text_style.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    double horizontalPadding =
        kIsWeb ? (width > 1000 ? (width - 1000) / 5 : 0) : 0;

    return Scaffold(
      appBar: const VotingAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                "블록 현황",
                style: AppTextStyle.title,
              ),
            ),
            const BlockListView(),
            const PageBlockDatatable(),
          ],
        ),
      ),
    );
  }
}
