import 'package:equatable/equatable.dart';
import 'package:walking_simulator/src/features/entries/domain/entry.dart';
import 'package:walking_simulator/src/features/journeys/domain/journey.dart';

class EntryJob extends Equatable {
  const EntryJob(this.entry, this.job);

  final Entry entry;
  final Journey job;

  @override
  List<Object?> get props => [entry, job];

  @override
  bool? get stringify => true;
}
