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

class JourneysScreen extends StatelessWidget {
  const JourneysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.journeys),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.goNamed(AppRoute.addJourney.name),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          ref.listen<AsyncValue>(
            journeysScreenControllerProvider,
            (_, state) => state.showAlertDialogOnError(context),
          );
          final journeysQuery = ref.watch(journeysQueryProvider);
          return FirestoreListView<Journey>(
            query: journeysQuery,
            itemBuilder: (context, doc) {
              final journey = doc.data();
              return Dismissible(
                key: Key('journey-${journey.id}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => ref
                    .read(journeysScreenControllerProvider.notifier)
                    .deleteJourney(journey),
                child: JourneyListTile(
                  journey: journey,
                  onTap: () => context.goNamed(
                    AppRoute.journey.name,
                    params: {'id': journey.id},
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

class JourneyListTile extends StatelessWidget {
  const JourneyListTile({Key? key, required this.journey, this.onTap})
      : super(key: key);
  final Journey journey;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(journey.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
