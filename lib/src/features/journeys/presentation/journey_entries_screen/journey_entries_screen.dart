import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walking_simulator/src/common_widgets/async_value_widget.dart';
import 'package:walking_simulator/src/features/journeys/data/journeys_repository.dart';
import 'package:walking_simulator/src/features/journeys/domain/journey.dart';
import 'package:walking_simulator/src/features/journeys/presentation/journey_entries_screen/journey_entries_list.dart';
import 'package:walking_simulator/src/routing/app_router.dart';

class JobEntriesScreen extends ConsumerWidget {
  const JobEntriesScreen({super.key, required this.jobId});
  final JourneyID jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsync = ref.watch(journeyStreamProvider(jobId));
    return ScaffoldAsyncValueWidget<Journey>(
      value: jobAsync,
      data: (job) => JobEntriesPageContents(job: job),
    );
  }
}

class JobEntriesPageContents extends StatelessWidget {
  const JobEntriesPageContents({super.key, required this.job});
  final Journey job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => context.goNamed(
              AppRoute.editJob.name,
              params: {'id': job.id},
              extra: job,
            ),
          ),
        ],
      ),
      body: JobEntriesList(job: job),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => context.goNamed(
          AppRoute.addEntry.name,
          params: {'id': job.id},
          extra: job,
        ),
      ),
    );
  }
}
