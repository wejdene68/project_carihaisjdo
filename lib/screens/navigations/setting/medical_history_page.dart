import 'package:flutter/material.dart';

class MedicalHistoryPage extends StatelessWidget {
  const MedicalHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final medicalRecords = [
      "2019: Diagnosed with Crohn’s Disease",
      "2020: Hospitalized for flare-up",
      "2021: Started biologic therapy",
      "2023: Regular check-ups, stable condition",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Medical History")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: medicalRecords.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.medical_services),
          title: Text(medicalRecords[index]),
        ),
      ),
    );
  }
}
