import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/functions/refresh_page.dart';
import '../../../core/utils/spacing.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../data/model/champion_player_model.dart';
import '../logic/cubit/champion_cubit.dart';
import 'widgets/champion_category_tabs.dart';
import 'widgets/champion_leaderboard.dart';
import 'widgets/champion_podium.dart';
import 'widgets/champion_shimmer_loading.dart';

class ChampionScreen extends StatefulWidget {
  const ChampionScreen({super.key});

  @override
  State<ChampionScreen> createState() => _ChampionScreenState();
}

class _ChampionScreenState extends State<ChampionScreen> {
  StatCategory _selectedCategory = StatCategory.topScorers;

  void _onCategoryChanged(final StatCategory category) {
    setState(() => _selectedCategory = category);
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(title: 'championship.champions'.tr()),

          ChampionCategoryTabs(
            selected: _selectedCategory,
            onSelected: _onCategoryChanged,
          ),

          Expanded(
            child: BlocBuilder<ChampionCubit, ChampionState>(
              builder: (final context, final state) {
                if (state is ChampionLoading) {
                  return const ChampionShimmer();
                }
                if (state is ChampionFailure) {
                  return Center(child: Text(state.error.message));
                }
                if (state is ChampionSuccess) {
                  return _buildContent(context, state.players);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    final BuildContext context,
    final List<ChampionPlayerModel> allPlayers,
  ) {
    final sorted = _selectedCategory.sorted(allPlayers);
    final topThree = sorted.take(3).toList();
    return RefreshIndicator(
      onRefresh: () => refreshData(context),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ChampionPodium(
              topThree: topThree,
              category: _selectedCategory,
            ),
          ),
          const SliverToBoxAdapter(child: Divider()),
          SliverToBoxAdapter(
            child: ChampionLeaderboard(
              players: sorted,
              category: _selectedCategory,
            ),
          ),
          SliverToBoxAdapter(child: verticalSpacing(24)),
        ],
      ),
    );
  }
}
