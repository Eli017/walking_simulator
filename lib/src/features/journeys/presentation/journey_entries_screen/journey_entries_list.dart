import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walking_simulator/src/features/entries/data/entries_repository.dart';
import 'package:walking_simulator/src/features/entries/domain/entry.dart';
import 'package:walking_simulator/src/features/journeys/domain/journey.dart';
import 'package:walking_simulator/src/features/journeys/presentation/journey_entries_screen/entry_list_item.dart';
import 'package:walking_simulator/src/features/journeys/presentation/journey_entries_screen/journey_entries_list_controller.dart';
import 'package:walking_simulator/src/routing/app_router.dart';
import 'package:walking_simulator/src/utils/async_value_ui.dart';

class JobEntriesList extends ConsumerWidget {
  const JobEntriesList({super.key, required this.job});
  final Journey job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      jobsEntriesListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final jobEntriesQuery = ref.watch(jobEntriesQueryProvider(job.id));
    return FirestoreListView<Entry>(
      query: jobEntriesQuery,
      itemBuilder: (context, doc) {
        final entry = doc.data();
        return DismissibleEntryListItem(
          dismissibleKey: Key('entry-${entry.id}'),
          entry: entry,
          job: job,
          onDismissed: () => ref
              .read(jobsEntriesListControllerProvider.notifier)
              .deleteEntry(entry.id),
          onTap: () => context.goNamed(
            AppRoute.entry.name,
            params: {'id': job.id, 'eid': entry.id},
            extra: entry,
          ),
        );
      },
    );
  }
}
