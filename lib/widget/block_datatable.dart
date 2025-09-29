import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vote_explorer/provider/block_provider.dart';
import 'package:vote_explorer/provider/from_to_provider.dart';
import 'package:vote_explorer/style/size/datatable_size.dart';
import 'package:vote_explorer/style/text/datatable_text.dart';
import 'package:vote_explorer/style/text_style.dart';
import 'package:vote_explorer/widget/block_alert_dialog.dart';

class BlockDatatable extends ConsumerWidget {
  const BlockDatatable({super.key});

  SizedBox _buildEllipsedText(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis, // ...
        style: AppTextStyle.tableTuple,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fromToResponse = ref.watch(fromToProvider);

    return LayoutBuilder(builder: (context, constraints) {
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
              label:
                  // Text(
                  //   _columnLabels[i],
                  //   style: AppTextStyle.tableAttribute,
                  // ),
                  Row(
                children: [
                  Text(
                    columnLabels[i],
                    style: AppTextStyle.tableAttribute,
                  ),
                  const SizedBox(width: 5),
                  ColumnTooltip(
                    title: columnTooltips[i]["title"]!,
                    content: columnTooltips[i]["content"]!,
                  ),
                ],
              ),
            );
          }),
          rows: fromToResponse!.headers.reversed.map((header) {
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
                ref.read(blockProvider.notifier).fetchBlock(header.height);
                showDialog(
                  context: context,
                  builder: (context) {
                    return BlockAlertDialog(header.height);
                  },
                );
              },
              cells: List.generate(values.length, (i) {
                // 블록 높이는 생략 없이 보여주고 나머지만 ellipsis 적용
                final textWidget = (i == 0)
                    ? Text(values[i], style: AppTextStyle.tableTuple)
                    : _buildEllipsedText(values[i], columnWidths[i]);
                return DataCell(textWidget);
              }),
            );
          }).toList(),
        ),
      );
    });
  }
}

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
