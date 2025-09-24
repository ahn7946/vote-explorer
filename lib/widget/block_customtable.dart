import 'package:flutter/material.dart';
import 'package:vote_explorer/core/api/api_service.dart';
import 'package:vote_explorer/core/model/dto/block_response.dart';
import 'package:vote_explorer/core/model/dto/from_to_response.dart';
import 'package:vote_explorer/style/text_style.dart';
import 'package:vote_explorer/widget/block_datatable.dart';
import 'package:vote_explorer/widget/block_alert_dialog.dart';

const _columnLabels = [
  '블록 높이',
  '블록 도메인',
  '제안자',
  '머클 루트',
  '블록 해시',
  '이전 블록 해시',
];

const _widths = [
  // 각 열 너비 비율 설정 (합 = 1.0)
  0.1, // 블록 높이
  0.15, // 블록 도메인
  0.15, // 제안자
  0.15, // 머클 루트
  0.15, // 블록 해시
  0.15, // 이전 블록 해시
];

const _columnTooltips = [
  {
    "title": "블록 높이란?",
    "content": "블록체인에서 블록이 생성된 순서를 나타내는 번호입니다.",
  },
  {
    "title": "블록 도메인이란?",
    "content": "블록(투표)을 가르키기 위한 하나의 별칭이며 블록 해시와 더불어 블록을 구별할 수 있는 하나의 식별자입니다.",
  },
  {
    "title": "제안자란?",
    "content": "블록(투표)을 생성한 계정의 식별 해시값입니다.",
  },
  {
    "title": "머클 루트란?",
    "content": "블록(투표) 안 트랜잭션(투표지)들을 한 줄로 정리한 무결성 체크용 해시값 입니다.",
  },
  {
    "title": "블록 해시란?",
    "content": "블록(투표) 전체 데이터를 해시한 고유 식별자입니다.",
  },
  {
    "title": "이전 블록 해시란?",
    "content": "해당 블록(투표) 이전의 블록 전체 데이터를 해시한 고유 식별자입니다.",
  },
];

class BlockCustomTable extends StatelessWidget {
  final FromToResponse response;

  const BlockCustomTable(this.response, {super.key});

  void _showDetailDialog(BuildContext context, BlockResponse response) {
    showDialog(
      context: context,
      builder: (_) => BlockAlertDialog(response),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double totalWidth = constraints.maxWidth;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: List.generate(_columnLabels.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: _widths[i] * totalWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _columnLabels[i],
                            style: AppTextStyle.tableAttribute,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ColumnTooltip(
                          title: _columnTooltips[i]["title"]!,
                          content: _columnTooltips[i]["content"]!,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            // 데이터 행
            ...response.headers.reversed.map((header) {
              final values = [
                header.height.toString(),
                header.votingId,
                header.proposer,
                header.merkleRoot,
                header.blockHash,
                header.prevBlockHash,
              ];
              return InkWell(
                onTap: () async {
                  final res =
                      await ApiService.fetchBlock(header.height.toString());
                  _showDetailDialog(context, res);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.3),
                    ),
                  ),
                  child: Row(
                    children: List.generate(values.length, (i) {
                      return SizedBox(
                        width: _widths[i] * totalWidth,
                        child: Text(
                          values[i],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.tableTuple,
                        ),
                      );
                    }),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}
