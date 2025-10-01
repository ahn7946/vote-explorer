import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/core/config/config.dart';
import 'package:vote_explorer/core/model/dto/from_to_response.dart';
import 'package:vote_explorer/provider/block_provider.dart';
import 'package:vote_explorer/provider/height_provider.dart';
import 'package:vote_explorer/style/text_style.dart';
import 'package:vote_explorer/widget/block_alert_dialog.dart';

import '../core/api/api_service.dart';
import '../style/text/datatable_text.dart';

// ---------------------- 페이지네이션 설정 ----------------------
const int fetchSize = AppConfig.fetchSize;

// 현재 페이지 상태
final currentPageProvider = StateProvider<int>((ref) => 1);

// 페이지별 데이터 요청 Provider
final paginatedFromToProvider =
    FutureProvider.autoDispose.family<FromToResponse, int>((ref, page) async {
  final heightResponse = ref.watch(heightProvider);
  final height = heightResponse?.height ?? 0;

  int from = height - fetchSize * page;
  int to = height - fetchSize * (page - 1);

  // ✅ from 은 최소 0 보장
  if (from < 0) from = 0;

  // ✅ to 도 height 범위를 넘어가지 않도록 보정
  if (to > height) to = height;

  return ApiService.fetchFromTo(from, to);
});

// ---------------------- BlockDatatable ----------------------
class PageBlockDatatable extends ConsumerWidget {
  const PageBlockDatatable({super.key});

  SizedBox _buildEllipsedText(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.tableTuple,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    final fromToResponse = ref.watch(paginatedFromToProvider(currentPage));

    return Column(
      mainAxisSize: MainAxisSize.min, // 핵심!

      children: [
        // 테이블 영역
        fromToResponse.when(
          data: (data) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                onSelectAll: null,
                columns: List.generate(columnLabels.length, (i) {
                  return DataColumn(
                    label: Row(
                      children: [
                        Text(columnLabels[i],
                            style: AppTextStyle.tableAttribute),
                        const SizedBox(width: 5),
                        ColumnTooltip(
                          title: columnTooltips[i]["title"]!,
                          content: columnTooltips[i]["content"]!,
                        ),
                      ],
                    ),
                  );
                }),
                rows: data.headers.reversed.map((header) {
                  final values = [
                    header.height.toString(),
                    header.votingId,
                    header.proposer,
                    header.merkleRoot,
                    header.blockHash,
                    header.prevBlockHash,
                  ];
                  return DataRow(
                    onSelectChanged: (_) async {
                      ref
                          .read(blockProvider.notifier)
                          .fetchBlock(header.height);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BlockAlertDialog(header.height);
                        },
                      );
                    },
                    cells: List.generate(values.length, (i) {
                      final textWidget = (i == 0)
                          ? Text(values[i], style: AppTextStyle.tableTuple)
                          : _buildEllipsedText(values[i], 150);
                      return DataCell(textWidget);
                    }),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text("Error: $err"),
        ),

        // 페이지네이션
        const SizedBox(height: 16),
        const _PaginationControls(),
      ],
    );
  }
}

// ---------------------- ColumnTooltip ----------------------
class ColumnTooltip extends StatelessWidget {
  final String title;
  final String content;

  const ColumnTooltip({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      richMessage: TextSpan(
        children: [
          TextSpan(
            text: '$title\n',
            style: AppTextStyle.tooltipTitle,
          ),
          TextSpan(
            text: content,
            style: AppTextStyle.tooltipContent,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      waitDuration: const Duration(milliseconds: 300),
      child: const Icon(
        Icons.info_outline,
        size: 18,
        color: Colors.black54,
      ),
    );
  }
}

// ---------------------- 페이지네이션 버튼 ----------------------
class _PaginationControls extends ConsumerWidget {
  const _PaginationControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    final heightResponse = ref.watch(heightProvider);

    final height = heightResponse?.height ?? 0;

    // 전체 페이지 수 계산
    final totalPages = (height / fetchSize).ceil();
    if (totalPages == 0) return const SizedBox(); // 데이터 없을 때 버튼 숨김

    // 현재 페이지 기준 앞뒤 2개
    final start = (currentPage <= 3) ? 1 : currentPage - 2;
    final pages = List.generate(5, (i) => start + i)
        .where((page) => page <= totalPages)
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // << 버튼
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 1
              ? () {
                  ref.read(currentPageProvider.notifier).state =
                      currentPage - 1;
                }
              : null,
        ),

        // 숫자 버튼
        for (final page in pages)
          GestureDetector(
            onTap: () {
              ref.read(currentPageProvider.notifier).state = page;
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: page == currentPage ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                "$page",
                style: TextStyle(
                  color: page == currentPage ? Colors.white : Colors.black,
                  fontWeight:
                      page == currentPage ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),

        // >> 버튼
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages
              ? () {
                  ref.read(currentPageProvider.notifier).state =
                      currentPage + 1;
                }
              : null,
        ),
      ],
    );
  }
}
