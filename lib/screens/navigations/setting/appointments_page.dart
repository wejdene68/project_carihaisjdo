import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      {"date": "2025-05-25", "doctor": "Dr. Alice Smith", "time": "10:00 AM"},
      {"date": "2025-06-10", "doctor": "Dr. Bob Johnson", "time": "2:00 PM"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Appointments")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final app = appointments[index];
          return ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text("With ${app['doctor']}"),
            subtitle: Text("${app['date']} at ${app['time']}"),
          );
        },
      ),
    );
  }
}
