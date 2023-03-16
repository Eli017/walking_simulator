import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

typedef JourneyID = String;

@immutable
class Journey extends Equatable {
  const Journey({required this.id, required this.name, required this.ratePerHour});
  final JourneyID id;
  final String name;
  final int ratePerHour;

  @override
  List<Object> get props => [name, ratePerHour];

  @override
  bool get stringify => true;

  factory Journey.fromMap(Map<String, dynamic> data, String id) {
    final name = data['name'] as String;
    final ratePerHour = data['ratePerHour'] as int;
    return Journey(
      id: id,
      name: name,
      ratePerHour: ratePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
