import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walking_simulator/src/common_widgets/async_value_widget.dart';
import 'package:walking_simulator/src/features/journeys/data/journeys_repository.dart';
import 'package:walking_simulator/src/features/journeys/domain/journey.dart';
import 'package:walking_simulator/src/features/journeys/presentation/journey_entries_screen/journey_entries_list.dart';
import 'package:walking_simulator/src/routing/app_router.dart';

class JourneyEntriesScreen extends ConsumerWidget {
  const JourneyEntriesScreen({super.key, required this.journeyId});
  final JourneyID journeyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyAsync = ref.watch(journeyStreamProvider(journeyId));
    return ScaffoldAsyncValueWidget<Journey>(
      value: journeyAsync,
      data: (journey) => JourneyEntriesPageContents(journey: journey),
    );
  }
}

class JourneyEntriesPageContents extends StatelessWidget {
  const JourneyEntriesPageContents({super.key, required this.journey});
  final Journey journey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(journey.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => context.goNamed(
              AppRoute.editJourney.name,
              params: {'id': journey.id},
              extra: journey,
            ),
          ),
        ],
      ),
      body: JourneyEntriesList(journey: journey),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => context.goNamed(
          AppRoute.addEntry.name,
          params: {'id': journey.id},
          extra: journey,
        ),
      ),
    );
  }
}
