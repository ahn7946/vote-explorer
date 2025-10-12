import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/component/block_alert_dialog.dart';
import 'package:vote_explorer/component/widget/button.dart';
import 'package:vote_explorer/component/widget/text.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/config/config.dart';
import 'package:vote_explorer/core/model/dto/from_to_response.dart';
import 'package:vote_explorer/provider/height_provider.dart';
import 'package:vote_explorer/style/size/datatable_size.dart';
import 'package:vote_explorer/style/text/datatable_text.dart';
import 'package:vote_explorer/style/text_style.dart';

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
            return LayoutBuilder(
              builder: (context, constraints) {
                final double totalWidth = constraints.maxWidth;
                final List<double> columnWidths =
                    widths.map((ratio) => ratio * totalWidth).toList();

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
                        onSelectChanged: (_) {
                          // 클릭 즉시 다이얼로그 띄움
                          showDialog(
                            context: context,
                            builder: (context) =>
                                BlockAlertDialog(header.height),
                          );
                        },
                        cells: List.generate(values.length, (i) {
                          final text = values[i];
                          return DataCell(
                            Row(
                              children: [
                                Expanded(
                                  child: (i == 0)
                                      ? Text(text,
                                          style: AppTextStyle.tableTuple)
                                      : buildEllipsedText(
                                          text, columnWidths[i]),
                                ),
                                SizedBox(width: 10),
                                buildCopyIconButton(context, text),
                              ],
                            ),
                          );
                        }),
                      );
                    }).toList(),
                  ),
                );
              },
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
      waitDuration: const Duration(milliseconds: 200),
      child: const Icon(
        Icons.info_outline,
        size: 18,
        color: Colors.black54,
      ),
    );
  }
}

class _PaginationControls extends ConsumerWidget {
  const _PaginationControls({super.key});

  static const double _buttonWidth = 48; // 버튼 최소 폭
  static const double _buttonMargin = 8; // 버튼 좌우 마진 합
  static const int _minButtons = 3;
  static const int _maxButtons = 9;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    final heightResponse = ref.watch(heightProvider);
    final height = heightResponse?.height ?? 0;

    final totalPages = (height / fetchSize).ceil();
    if (totalPages == 0) return const SizedBox();

    // 화면 기준으로 최대 버튼 수 계산
    final screenWidth = MediaQuery.of(context).size.width;
    int visibleCount = (screenWidth / (_buttonWidth + _buttonMargin)).floor();

    // 홀수, 최소/최대 보정
    visibleCount = visibleCount.isEven ? visibleCount - 1 : visibleCount;
    visibleCount = visibleCount.clamp(_minButtons, _maxButtons);
    visibleCount = visibleCount > totalPages ? totalPages : visibleCount;

    // 가운데 기준 페이지 범위 계산
    final half = visibleCount ~/ 2;
    int start = currentPage - half;
    int end = currentPage + half;

    if (start < 1) {
      end += 1 - start;
      start = 1;
    }
    if (end > totalPages) {
      start -= end - totalPages;
      end = totalPages;
    }
    if (start < 1) start = 1;

    final pages = [for (int i = start; i <= end; i++) i];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 1
              ? () =>
                  ref.read(currentPageProvider.notifier).state = currentPage - 1
              : null,
        ),
        for (final page in pages)
          GestureDetector(
            onTap: () => ref.read(currentPageProvider.notifier).state = page,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: page == currentPage ? Colors.black87 : Colors.white,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                "$page",
                style: TextStyle(
                  color: page == currentPage ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight:
                      page == currentPage ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages
              ? () =>
                  ref.read(currentPageProvider.notifier).state = currentPage + 1
              : null,
        ),
      ],
    );
  }
}
