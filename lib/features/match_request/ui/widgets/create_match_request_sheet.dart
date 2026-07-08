import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions/context_ext.dart';
import '../../logic/cubit/match_request_cubit.dart';

class CreateMatchRequestSheet extends StatefulWidget {
  const CreateMatchRequestSheet({super.key});

  @override
  State<CreateMatchRequestSheet> createState() =>
      _CreateMatchRequestSheetState();
}

class _CreateMatchRequestSheetState extends State<CreateMatchRequestSheet> {
  late final Future<List<Map<String, dynamic>>> _opponentOptions;
  final _requesterScoreController = TextEditingController(text: '0');
  final _opponentScoreController = TextEditingController(text: '0');
  final _noteController = TextEditingController();
  String? _opponentId;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _opponentOptions = context.read<MatchRequestCubit>().loadOpponentOptions();
  }

  @override
  void dispose() {
    _requesterScoreController.dispose();
    _opponentScoreController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final opponentId = _opponentId;
    final requesterScore = int.tryParse(_requesterScoreController.text);
    final opponentScore = int.tryParse(_opponentScoreController.text);
    if (opponentId == null || requesterScore == null || opponentScore == null) {
      context.showErrorSnackBar('Select an opponent and enter both scores.');
      return;
    }

    setState(() => _submitting = true);
    final success = await context.read<MatchRequestCubit>().create(
      opponentId: opponentId,
      requesterScore: requesterScore,
      opponentScore: opponentScore,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (success) Navigator.pop(context);
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New match request',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _opponentOptions,
              builder: (final context, final snapshot) {
                final options = snapshot.data ?? const [];
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return DropdownButtonFormField<String>(
                  initialValue: _opponentId,
                  decoration: const InputDecoration(labelText: 'Opponent'),
                  items: options
                      .map(
                        (final o) => DropdownMenuItem(
                          value: o['id'] as String,
                          child: Text(o['name'] as String),
                        ),
                      )
                      .toList(),
                  onChanged: (final value) =>
                      setState(() => _opponentId = value),
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _requesterScoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Your score'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _opponentScoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Opponent score',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note (optional)'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
