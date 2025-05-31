import 'package:flutter/material.dart';

class PharmacyPage extends StatelessWidget {
  const PharmacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pharmacy Services')),
      body: const Center(
        child: Text(
          'Details about Pharmacy Services',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
