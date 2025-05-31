import 'package:flutter/material.dart';

class SurgeonPage extends StatelessWidget {
  const SurgeonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Surgeon Services')),
      body: const Center(
        child: Text(
          'Details about Surgeon Services',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
