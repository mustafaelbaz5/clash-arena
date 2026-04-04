import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../core/utils/spacing.dart';
import '../../data/models/match_history_card_model.dart';
import 'history_card_player_info.dart';
import 'match_card_header.dart';
import 'score_display.dart';

class HistoryListCard extends StatelessWidget {
  final MatchHistoryCardModel match;

  const HistoryListCard({super.key, required this.match});

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(8)),
      padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rr(16)),
        color: context.customColors.background.withValues(alpha: 0.1),
        border: Border.all(color: context.customColors.border, width: 1),
      ),
      child: Column(
        children: [
          MatchCardHeader(matchDate: match.matchDate),
          verticalSpacing(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HistoryCardPlayerInfo(
                playerName: match.winnerName,
                avatarUrl: match.winnerImage,
                isWinner: true,
              ),
              ScoreDisplay(match: match),
              HistoryCardPlayerInfo(
                playerName: match.loserName,
                avatarUrl: match.loserImage,
                isWinner: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
