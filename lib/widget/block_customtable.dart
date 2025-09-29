// import 'package:flutter/material.dart';
// import 'package:vote_explorer/core/api/api_service.dart';
// import 'package:vote_explorer/core/model/dto/block_response.dart';
// import 'package:vote_explorer/core/model/dto/from_to_response.dart';
// import 'package:vote_explorer/style/size/datatable_size.dart';
// import 'package:vote_explorer/style/text/datatable_text.dart';
// import 'package:vote_explorer/style/text_style.dart';
// import 'package:vote_explorer/widget/block_datatable.dart';
// import 'package:vote_explorer/widget/block_alert_dialog.dart';
//
// class BlockCustomTable extends StatelessWidget {
//   final FromToResponse response;
//
//   const BlockCustomTable(this.response, {super.key});
//
//   void _showDetailDialog(BuildContext context, BlockResponse response) {
//     showDialog(
//       context: context,
//       builder: (_) => BlockAlertDialog(response),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       final double totalWidth = constraints.maxWidth;
//
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 헤더
//             Row(
//               children: List.generate(columnLabels.length, (i) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5),
//                   child: SizedBox(
//                     width: widths[i] * totalWidth,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             columnLabels[i],
//                             style: AppTextStyle.tableAttribute,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         ColumnTooltip(
//                           title: columnTooltips[i]["title"]!,
//                           content: columnTooltips[i]["content"]!,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             ),
//             const SizedBox(height: 8),
//             // 데이터 행
//             ...response.headers.reversed.map((header) {
//               final values = [
//                 header.height.toString(),
//                 header.votingId,
//                 header.proposer,
//                 header.merkleRoot,
//                 header.blockHash,
//                 header.prevBlockHash,
//               ];
//               return InkWell(
//                 onTap: () async {
//                   final res =
//                       await ApiService.fetchBlock(header.height.toString());
//                   _showDetailDialog(context, res);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   decoration: const BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey, width: 0.3),
//                     ),
//                   ),
//                   child: Row(
//                     children: List.generate(values.length, (i) {
//                       return SizedBox(
//                         width: widths[i] * totalWidth,
//                         child: Text(
//                           values[i],
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: AppTextStyle.tableTuple,
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       );
//     });
//   }
// }
