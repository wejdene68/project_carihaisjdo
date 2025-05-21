import 'package:flutter/material.dart';

class DoctorContactsPage extends StatelessWidget {
  const DoctorContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {
        "name": "Dr. Alice Smith",
        "phone": "+123456789",
        "specialty": "Gastroenterologist"
      },
      {
        "name": "Dr. Bob Johnson",
        "phone": "+987654321",
        "specialty": "Nutritionist"
      },
      {"name": "Dr. Carol Lee", "phone": "+192837465", "specialty": "Surgeon"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Contacts")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(doctor['name']!),
            subtitle: Text("${doctor['specialty']}\n${doctor['phone']}"),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () {
                // Implement call functionality here (with url_launcher)
              },
            ),
          );
        },
      ),
    );
  }
}
