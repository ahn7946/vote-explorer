import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/config/config.dart';
import 'package:vote_explorer/core/model/dto/from_to_response.dart';
import 'package:vote_explorer/core/model/dto/height_response.dart';
import 'package:vote_explorer/provider/from_to_provider.dart';
import 'package:vote_explorer/provider/height_provider.dart';
import 'package:vote_explorer/style/text_style.dart';
import 'package:vote_explorer/widget/block_datatable.dart';
import 'package:vote_explorer/widget/block_listview.dart';
import 'package:vote_explorer/widget/page_block_datatable.dart';
import 'package:vote_explorer/widget/voting_appbar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    double horizontalPadding =
        kIsWeb ? (width > 1000 ? (width - 1000) / 4 : 0) : 0;

    return Scaffold(
      appBar: const VotingAppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        children: [
          const SizedBox(height: 10),
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
          PageBlockDatatable(),
        ],
      ),
    );
  }
}
