import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:walking_simulator/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:walking_simulator/src/features/entries/data/entries_repository.dart';
import 'package:walking_simulator/src/features/entries/domain/entry.dart';

part 'journey_entries_list_controller.g.dart';

@riverpod
class JourneysEntriesListController extends _$JourneysEntriesListController {
  @override
  FutureOr<void> build() {
    // ok to leave this empty if the return type is FutureOr<void>
  }

  Future<void> deleteEntry(EntryID entryId) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    final repository = ref.read(entriesRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => repository.deleteEntry(uid: currentUser.uid, entryId: entryId));
  }
}
