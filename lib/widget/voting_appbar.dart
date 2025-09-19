import 'package:flutter/material.dart';
import 'package:vote_explorer/api/dummy_api.dart';
import 'package:vote_explorer/style/TextStyle.dart';

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
    return Container(
      height: widget.preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black26))),
      child: Row(
        children: [
          const Text(
            "✓OTING",
            style: AppTextStyle.voting,
          ),
          const Spacer(),
          Expanded(
            flex: 2,
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
