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

  static String journeyPath(String uid, String jobId) => 'users/$uid/journeys/$jobId';
  static String journeysPath(String uid) => 'users/$uid/journeys';
  static String entriesPath(String uid) => EntriesRepository.entriesPath(uid);

  // create
  Future<void> addJourney(
          {required UserID uid,
          required String name,
          required int ratePerHour}) =>
      _firestore.collection(journeysPath(uid)).add({
        'name': name,
        'ratePerHour': ratePerHour,
      });

  // update
  Future<void> updateJourney({required UserID uid, required Job job}) =>
      _firestore.doc(journeyPath(uid, job.id)).update(job.toMap());

  // delete
  Future<void> deleteJourney({required UserID uid, required JobID jobId}) async {
    // delete where entry.jobId == job.jobId
    final entriesRef = _firestore.collection(entriesPath(uid));
    final entries = await entriesRef.get();
    for (final snapshot in entries.docs) {
      final entry = Entry.fromMap(snapshot.data(), snapshot.id);
      if (entry.jobId == jobId) {
        await snapshot.reference.delete();
      }
    }
    // delete job
    final jobRef = _firestore.doc(journeyPath(uid, jobId));
    await jobRef.delete();
  }

  // read
  Stream<Job> watchJourney({required UserID uid, required JobID jobId}) =>
      _firestore
          .doc(journeyPath(uid, jobId))
          .withConverter<Job>(
            fromFirestore: (snapshot, _) =>
                Job.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (job, _) => job.toMap(),
          )
          .snapshots()
          .map((snapshot) => snapshot.data()!);

  Stream<List<Job>> watchJourneys({required UserID uid}) => queryJourneys(uid: uid)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Query<Job> queryJourneys({required UserID uid}) =>
      _firestore.collection(journeysPath(uid)).withConverter(
            fromFirestore: (snapshot, _) =>
                Job.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (job, _) => job.toMap(),
          );

  Future<List<Job>> fetchJourneys({required UserID uid}) async {
    final jobs = await queryJourneys(uid: uid).get();
    return jobs.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
JourneysRepository journeysRepository(JourneysRepositoryRef ref) {
  return JourneysRepository(FirebaseFirestore.instance);
}

@riverpod
Query<Job> journeysQuery(JourneysQueryRef ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(journeysRepositoryProvider);
  return repository.queryJourneys(uid: user.uid);
}

@riverpod
Stream<Job> journeyStream(JourneyStreamRef ref, JobID jobId) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(journeysRepositoryProvider);
  return repository.watchJourney(uid: user.uid, jobId: jobId);
}
