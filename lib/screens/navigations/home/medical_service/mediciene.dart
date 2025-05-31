import 'package:flutter/material.dart';

class MedicinePage extends StatelessWidget {
  const MedicinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medicine Services')),
      body: const Center(
        child: Text(
          'Details about Medicine Services',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
