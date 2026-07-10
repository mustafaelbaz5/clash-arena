import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions/context_ext.dart';
import '../../domain/entities/match_request_entity.dart';
import '../../logic/cubit/match_request_cubit.dart';

class MatchRequestTile extends StatelessWidget {
  const MatchRequestTile({
    required this.request,
    required this.showActions,
    super.key,
  });

  final MatchRequestEntity request;
  final bool showActions;

  @override
  Widget build(final BuildContext context) {
    return Card(
      elevation: 0,
      color: context.customColors.divider.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${request.requesterName} ${request.requesterScore} - ${request.opponentScore} ${request.opponentName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _statusLabel(request),
              style: TextStyle(color: context.customColors.textSecondary),
            ),
            if (request.note != null && request.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(request.note!),
            ],
            if (showActions && request.isPending) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        context.read<MatchRequestCubit>().reject(request),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () =>
                        context.read<MatchRequestCubit>().approve(request),
                    child: const Text('Accept'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _statusLabel(final MatchRequestEntity request) {
    switch (request.status) {
      case MatchRequestStatus.pending:
        return 'Waiting for response';
      case MatchRequestStatus.accepted:
        return 'Accepted';
      case MatchRequestStatus.rejected:
        return 'Rejected';
      case MatchRequestStatus.expired:
        return 'Expired';
      case MatchRequestStatus.cancelled:
        return 'Cancelled';
    }
  }
}
