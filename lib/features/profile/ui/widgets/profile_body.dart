import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/spacing.dart';
import '../../logic/cubit/profile_cubit.dart';
import 'profile_header.dart';
import 'profile_info_section.dart';
import 'profile_settings/profile_settings.dart';
import 'profile_shimmer_loading.dart';
import 'profile_statistics/profile_stats_section.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (final context, final state) {
        if (state is ProfileLoading) {
          return const ProfileShimmerLoading();
        }
        if (state is ProfileFailure) {
          return Center(child: Text(state.error.message));
        }
        if (state is ProfileSuccess) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ProfileHeader(
                  name: state.profile.user.name,
                  imageUrl: state.profile.user.profileImageUrl,
                ),
              ),

              SliverToBoxAdapter(
                child: ProfileStatsSection(stats: state.profile.stats),
              ),
              SliverToBoxAdapter(child: verticalSpacing(16)),
              SliverToBoxAdapter(
                child: ProfileInfoSection(userDataModel: state.profile.user),
              ),
              SliverToBoxAdapter(child: verticalSpacing(16)),

              const SliverToBoxAdapter(child: ProfileSettings()),
              SliverToBoxAdapter(child: verticalSpacing(16)),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
