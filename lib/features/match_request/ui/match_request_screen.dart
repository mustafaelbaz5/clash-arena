import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/extensions/context_ext.dart';
import '../domain/entities/match_request_entity.dart';
import '../logic/cubit/match_request_cubit.dart';
import 'widgets/create_match_request_sheet.dart';
import 'widgets/match_request_tile.dart';

class MatchRequestScreen extends StatefulWidget {
  const MatchRequestScreen({super.key});

  @override
  State<MatchRequestScreen> createState() => _MatchRequestScreenState();
}

class _MatchRequestScreenState extends State<MatchRequestScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Sent'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (final _) => BlocProvider.value(
            value: context.read<MatchRequestCubit>(),
            child: const CreateMatchRequestSheet(),
          ),
        ),
      ),
      body: BlocConsumer<MatchRequestCubit, MatchRequestState>(
        listener: (final context, final state) {
          if (state is MatchRequestActionFailure) {
            context.showErrorSnackBar(state.error.message);
          }
        },
        builder: (final context, final state) {
          if (state is MatchRequestLoading || state is MatchRequestInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          final loaded = state is MatchRequestLoaded
              ? state
              : MatchRequestLoaded(pending: const [], sent: const []);

          return TabBarView(
            controller: _tabController,
            children: [
              _RequestList(
                requests: loaded.pending,
                emptyText: 'No pending requests.',
                showActions: true,
              ),
              _RequestList(
                requests: loaded.sent,
                emptyText: "You haven't sent any requests yet.",
                showActions: false,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RequestList extends StatelessWidget {
  const _RequestList({
    required this.requests,
    required this.emptyText,
    required this.showActions,
  });

  final List<MatchRequestEntity> requests;
  final String emptyText;
  final bool showActions;

  @override
  Widget build(final BuildContext context) {
    if (requests.isEmpty) {
      return Center(child: Text(emptyText));
    }
    return RefreshIndicator(
      onRefresh: () => context.read<MatchRequestCubit>().loadRequests(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        separatorBuilder: (final _, final _) => const SizedBox(height: 8),
        itemBuilder: (final context, final index) => MatchRequestTile(
          request: requests[index],
          showActions: showActions,
        ),
      ),
    );
  }
}
