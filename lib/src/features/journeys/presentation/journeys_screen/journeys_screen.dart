import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walking_simulator/src/constants/strings.dart';
import 'package:walking_simulator/src/features/journeys/data/journeys_repository.dart';
import 'package:walking_simulator/src/features/journeys/domain/journey.dart';
import 'package:walking_simulator/src/features/journeys/presentation/journeys_screen/journeys_screen_controller.dart';
import 'package:walking_simulator/src/routing/app_router.dart';
import 'package:walking_simulator/src/utils/async_value_ui.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.jobs),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.goNamed(AppRoute.addJob.name),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          ref.listen<AsyncValue>(
            jobsScreenControllerProvider,
            (_, state) => state.showAlertDialogOnError(context),
          );
          final jobsQuery = ref.watch(journeysQueryProvider);
          return FirestoreListView<Journey>(
            query: jobsQuery,
            itemBuilder: (context, doc) {
              final job = doc.data();
              return Dismissible(
                key: Key('job-${job.id}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => ref
                    .read(jobsScreenControllerProvider.notifier)
                    .deleteJob(job),
                child: JobListTile(
                  job: job,
                  onTap: () => context.goNamed(
                    AppRoute.job.name,
                    params: {'id': job.id},
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class JobListTile extends StatelessWidget {
  const JobListTile({Key? key, required this.job, this.onTap})
      : super(key: key);
  final Journey job;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
