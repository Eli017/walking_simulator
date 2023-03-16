import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:walking_simulator/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:walking_simulator/src/features/jobs/data/jobs_repository.dart';
import 'package:walking_simulator/src/features/jobs/domain/job.dart';

part 'jobs_screen_controller.g.dart';

@riverpod
class JobsScreenController extends _$JobsScreenController {
  @override
  FutureOr<void> build() {
    // ok to leave this empty if the return type is FutureOr<void>
  }

  Future<void> deleteJob(Job job) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    final repository = ref.read(journeysRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => repository.deleteJourney(uid: currentUser.uid, jobId: job.id));
  }
}
