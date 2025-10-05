import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vote_explorer/core/config/config.dart';
import 'package:vote_explorer/component//query_alert_dialog.dart';
import 'package:vote_explorer/provider/query_provider.dart';
import 'package:vote_explorer/style/text_style.dart';

class VotingAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const VotingAppBar({super.key});

  @override
  ConsumerState<VotingAppBar> createState() => _VotingAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _VotingAppBarState extends ConsumerState<VotingAppBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // Web 포커스 안전 처리

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSearch([String? value]) {
    final query = value ?? _searchController.text;
    if (query.isEmpty) return;

    // Provider로 API 호출
    ref.read(queryProvider.notifier).fetchQuery(query);

    // 검색 후 입력 초기화
    _searchController.clear();
    Future.delayed(Duration(milliseconds: 50), () {
      _focusNode.unfocus();
    });

    // Dialog 띄우기
    showDialog(
      context: context,
      builder: (_) => QueryAlertDialog(query),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const threshold = 650;
    final double horizontalPadding =
        (width > threshold && kIsWeb) ? (width / threshold) * 16 : 16;
    final showSpacer = width > threshold && kIsWeb;
    final hideVotingText =
        _searchController.text.isNotEmpty && !(width > threshold && kIsWeb);

    return Container(
      height: widget.preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black26))),
      child: Row(
        children: [
          if (!hideVotingText)
            GestureDetector(
              onTap: () => launchUrl(Uri.parse(AppConfig.homeURL)),
              child: Text(
                "✓OTING",
                style: AppTextStyle.voting,
              ),
            ),
          if (showSpacer)
            const Spacer()
          else
            SizedBox(width: horizontalPadding),
          Flexible(
            flex: 4,
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    onSubmitted: _handleSearch,
                    style: AppTextStyle.searchBar,
                    decoration: InputDecoration(
                      hintText: "투표명 / 블록해시로 조회",
                      hintStyle: AppTextStyle.searchBarHint,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _handleSearch,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (showSpacer) const Spacer() else SizedBox(width: horizontalPadding)
        ],
      ),
    );
  }
}
