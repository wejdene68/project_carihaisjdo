import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:lucide_icons/lucide_icons.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> allDoctors = [
    {
      "name": "Dr. Amira Benali",
      "specialty": "Pediatrician",
      "contact": "+213 541 234 123",
      "availableDays": ["Sunday", "Tuesday", "Thursday"],
      "image": "https://cdn-icons-png.flaticon.com/512/3774/3774293.png"
    },
    {
      "name": "Dr. Youcef Karim",
      "specialty": "General Practitioner",
      "contact": "+213 540 654 321",
      "availableDays": ["Monday", "Wednesday", "Friday"],
      "image": "https://cdn-icons-png.flaticon.com/512/3774/3774293.png"
    },
    {
      "name": "Dr. Nadia Lamine",
      "specialty": "ENT (Grippe Specialist)",
      "contact": "+213 555 112 334",
      "availableDays": ["Sunday"],
      "image": "https://cdn-icons-png.flaticon.com/512/3774/3774293.png"
    },
    {
      "name": "Dr. Salim Aouad",
      "specialty": "Cardiologist",
      "contact": "+213 522 300 120",
      "availableDays": ["Tuesday", "Thursday"],
      "image": "https://cdn-icons-png.flaticon.com/512/3774/3774293.png"
    },
    {
      "name": "Dr. Ines Mebarki",
      "specialty": "Dermatologist",
      "contact": "+213 511 789 222",
      "availableDays": ["Monday", "Friday"],
      "image": "https://cdn-icons-png.flaticon.com/512/3774/3774293.png"
    },
    {
      "name": "Dr. Hichem Belkacem",
      "specialty": "Neurologist",
      "contact": "+213 541 987 666",
      "availableDays": ["Wednesday"],
      "image": "https://cdn-icons-png.flaticon.com/512/3774/3774293.png"
    },
    {
      "name": "Dr. Selma Khodja",
      "specialty": "Ophthalmologist",
      "contact": "+213 555 000 111",
      "availableDays": ["Tuesday", "Saturday"],
      "image": "https://cdn-icons-png.flaticon.com/512/3774/3774293.png"
    },
    {
      "name": "Dr. Mourad Ziani",
      "specialty": "Orthopedic",
      "contact": "+213 588 963 147",
      "availableDays": ["Thursday"],
      "image": "https://cdn-icons-png.flaticon.com/512/3774/3774293.png"
    },
    {
      "name": "Dr. Amina Sahnoune",
      "specialty": "Gynecologist",
      "contact": "+213 533 112 400",
      "availableDays": ["Monday", "Wednesday"],
      "image": "https://cdn-icons-png.flaticon.com/512/3774/3774293.png"
    },
    {
      "name": "Dr. Karim Tarek",
      "specialty": "Dentist",
      "contact": "+213 599 776 899",
      "availableDays": ["Friday", "Sunday"],
      "image": "https://cdn-icons-png.flaticon.com/512/3774/3774293.png"
    },
  ];

  List<Map<String, dynamic>> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    filteredDoctors = allDoctors;
    _searchController.addListener(_filterDoctors);
  }

  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = allDoctors.where((doctor) {
        final name = doctor['name'].toLowerCase();
        final specialty = doctor['specialty'].toLowerCase();
        return name.contains(query) || specialty.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5F5),
      appBar: AppBar(
        title: const Text("Doctors"),
        foregroundColor: Colors.blue[500],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search doctors by name or specialty...",
                filled: true,
                fillColor: Colors.blue[300],
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredDoctors.length,
        itemBuilder: (context, index) {
          final doctor = filteredDoctors[index];
          return DoctorCard(
            name: doctor["name"],
            specialty: doctor["specialty"],
            contact: doctor["contact"],
            availableDays: doctor["availableDays"],
            imageUrl: doctor["image"],
          );
        },
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String contact;
  final List<String> availableDays;
  final String imageUrl;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.contact,
    required this.availableDays,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 6),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              specialty,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(LucideIcons.phoneCall,
                    size: 16, color: Colors.green),
                const SizedBox(width: 6),
                Text(contact),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.calendarDays,
                    size: 16, color: Colors.blue),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Available: ${availableDays.join(', ')}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.message, color: Colors.blue),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Contacting $name...")),
            );
          },
        ),
      ),
    );
  }
}
