import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vote_explorer/core/config/config.dart';
import 'package:vote_explorer/style/text_style.dart';

class VotingAppBar extends StatefulWidget implements PreferredSizeWidget {
  const VotingAppBar({super.key});

  @override
  State<VotingAppBar> createState() => _VotingAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _VotingAppBarState extends State<VotingAppBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch([String? value]) {
    final text = value ?? _searchController.text;
    if (text.isEmpty) return;

    print("검색 실행: $text");
    setState(() {
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int threshold = 650;
    double horizontalPadding;
    bool showSpacer;
    if ((width > threshold) && kIsWeb) {
      // 웹일 때만 반응형 규칙 적용
      horizontalPadding = (width / threshold) * 16;
      showSpacer = true;
    } else {
      // 모바일 / 태블릿은 기본 패딩
      horizontalPadding = 16;
      showSpacer = false;
    }
    bool hideVotingText =
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
          if (showSpacer) Spacer() else SizedBox(width: horizontalPadding),
          Flexible(
            flex: 4,
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
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
                    onChanged: (_) => setState(() {}),
                    onTap: () => setState(() {}),
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
          if (showSpacer) Spacer() else SizedBox(width: horizontalPadding)
        ],
      ),
    );
  }
}
