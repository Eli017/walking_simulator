import 'package:flutter/material.dart';

class NewTripView extends StatelessWidget {

  const NewTripView({super.key});

  static const routeName = '/new_trip';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trip'),
      ),
    );
  }
}