import 'package:flutter/material.dart';

class NursingPage extends StatelessWidget {
  const NursingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nursing Services')),
      body: const Center(
        child: Text(
          'Details about Nursing Services',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
