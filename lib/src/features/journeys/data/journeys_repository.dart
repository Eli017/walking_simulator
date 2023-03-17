import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:walking_simulator/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:walking_simulator/src/features/authentication/domain/app_user.dart';
import 'package:walking_simulator/src/features/entries/data/entries_repository.dart';
import 'package:walking_simulator/src/features/entries/domain/entry.dart';
import 'package:walking_simulator/src/features/journeys/domain/journey.dart';

part 'journeys_repository.g.dart';

class JourneysRepository {
  const JourneysRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String journeyPath(String uid, String journeyId) => 'journeys/$journeyId';
  static String journeysPath(String uid) => 'journeys';
  static String entriesPath(String uid) => EntriesRepository.entriesPath(uid);

  // create
  Future<void> addJourney(
          {required UserID uid,
          required String name,
          required int distance}) =>
      _firestore.collection(journeysPath(uid)).add({
        'name': name,
        'distance': distance,
      });

  // update
  Future<void> updateJourney({required UserID uid, required Journey journey}) =>
      _firestore.doc(journeyPath(uid, journey.id)).update(journey.toMap());

  // delete
  Future<void> deleteJourney({required UserID uid, required JourneyID journeyId}) async {
    // delete where entry.journeyId == journey.journeyId
    final entriesRef = _firestore.collection(entriesPath(uid));
    final entries = await entriesRef.get();
    for (final snapshot in entries.docs) {
      final entry = Entry.fromMap(snapshot.data(), snapshot.id);
      if (entry.journeyId == journeyId) {
        await snapshot.reference.delete();
      }
    }
    // delete journey
    final journeyRef = _firestore.doc(journeyPath(uid, journeyId));
    await journeyRef.delete();
  }

  // read
  Stream<Journey> watchJourney({required UserID uid, required JourneyID journeyId}) =>
      _firestore
          .doc(journeyPath(uid, journeyId))
          .withConverter<Journey>(
            fromFirestore: (snapshot, _) =>
                Journey.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (journey, _) => journey.toMap(),
          )
          .snapshots()
          .map((snapshot) => snapshot.data()!);

  Stream<List<Journey>> watchJourneys({required UserID uid}) => queryJourneys(uid: uid)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Query<Journey> queryJourneys({required UserID uid}) =>
      _firestore.collection(journeysPath(uid)).withConverter(
            fromFirestore: (snapshot, _) =>
                Journey.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (journey, _) => journey.toMap(),
          );

  Future<List<Journey>> fetchJourneys({required UserID uid}) async {
    final journeys = await queryJourneys(uid: uid).get();
    return journeys.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
JourneysRepository journeysRepository(JourneysRepositoryRef ref) {
  return JourneysRepository(FirebaseFirestore.instance);
}

@riverpod
Query<Journey> journeysQuery(JourneysQueryRef ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(journeysRepositoryProvider);
  return repository.queryJourneys(uid: user.uid);
}

@riverpod
Stream<Journey> journeyStream(JourneyStreamRef ref, JourneyID journeyId) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(journeysRepositoryProvider);
  return repository.watchJourney(uid: user.uid, journeyId: journeyId);
}
