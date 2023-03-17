class JourneySubmitException {
  String get title => 'Name already used';
  String get description => 'Please choose a different journey name';

  @override
  String toString() {
    return '$title. $description.';
  }
}
