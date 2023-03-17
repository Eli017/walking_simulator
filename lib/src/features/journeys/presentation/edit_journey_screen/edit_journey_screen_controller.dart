import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:walking_simulator/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:walking_simulator/src/features/journeys/data/journeys_repository.dart';
import 'package:walking_simulator/src/features/journeys/domain/journey.dart';
import 'package:walking_simulator/src/features/journeys/presentation/edit_journey_screen/journey_submit_exception.dart';

part 'edit_journey_screen_controller.g.dart';

@riverpod
class EditJourneyScreenController extends _$EditJourneyScreenController {
  @override
  FutureOr<void> build() {
    //
  }

  Future<bool> submit(
      {JourneyID? journeyId,
      Journey? oldJourney,
      required String name,
      required int distance}) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    // set loading state
    state = const AsyncLoading().copyWithPrevious(state);
    // check if name is already in use
    final repository = ref.read(journeysRepositoryProvider);
    final journeys = await repository.fetchJourneys(uid: currentUser.uid);
    final allLowerCaseNames =
        journeys.map((journey) => journey.name.toLowerCase()).toList();
    // it's ok to use the same name as the old journey
    if (oldJourney != null) {
      allLowerCaseNames.remove(oldJourney.name.toLowerCase());
    }
    // check if name is already used
    if (allLowerCaseNames.contains(name.toLowerCase())) {
      state = AsyncError(JourneySubmitException(), StackTrace.current);
      return false;
    } else {
      // journey previously existed
      if (journeyId != null) {
        final job = Journey(id: journeyId, name: name, distance: distance);
        state = await AsyncValue.guard(
          () => repository.updateJourney(uid: currentUser.uid, journey: job),
        );
      } else {
        state = await AsyncValue.guard(
          () => repository.addJourney(
              uid: currentUser.uid, name: name, distance: distance),
        );
      }
      return state.hasError == false;
    }
  }
}

@riverpod
int count(CountRef ref) {
  return 0;
}
