import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchBarPage extends StatefulWidget {
  const SearchBarPage({super.key});

  @override
  State<SearchBarPage> createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchedMed = '';

  final Map<String, String> medInfo = {
    'Doliprane': 'Paracétamol utilisé pour soulager la douleur et la fièvre.',
    'Ibuprofène':
        'Anti-inflammatoire non stéroïdien pour la douleur, la fièvre.',
    'Amoxicilline': 'Antibiotique pour infections bactériennes.',
    'Efferalgan': 'Médicament contre la fièvre et douleurs modérées.',
    'Spasfon': 'Utilisé pour les douleurs abdominales et spasmes.',
    'Augmentin': 'Antibiotique utilisé pour traiter diverses infections.',
    'Aspirine': 'Soulage douleur, fièvre, et inflammation. Antiplaquettaire.',
    'Ventoline':
        'Bronchodilatateur pour traiter l’asthme et les bronchospasmes.',
    'Nurofen': 'Anti-inflammatoire et analgésique à base d’ibuprofène.',
    'Imodium': 'Utilisé pour traiter les diarrhées aiguës.',
    'Toplexil': 'Sirop contre la toux sèche et les allergies.',
    'Strepsils': 'Pastilles pour maux de gorge.'
  };

  final List<Map<String, String>> pharmacies = [
    {
      'name': 'Pharmacie Centrale',
      'address': '123 Rue Principale',
      'phone': '+213555123456'
    },
    {
      'name': 'Pharmacie El-Waha',
      'address': '45 Avenue des Fleurs',
      'phone': '+213555654321'
    },
    {
      'name': 'Pharmacie El-Nour',
      'address': '78 Boulevard de la Santé',
      'phone': '+213555987654'
    },
    {
      'name': 'Pharmacie Saïd',
      'address': '12 Rue des Lilas',
      'phone': '+213555321987'
    },
  ];

  void _showMedDialog(String med) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.blue.shade200.withOpacity(0.4),
                  offset: const Offset(0, 10),
                  blurRadius: 15),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                med,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                  shadows: [
                    Shadow(
                        color: Colors.blue.shade100,
                        offset: const Offset(1, 1),
                        blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                medInfo[med] ?? 'No description available.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: Colors.blue.shade300,
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showPharmacyDialog(Map<String, String> pharmacy) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        elevation: 18,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.green.shade200.withOpacity(0.4),
                offset: const Offset(0, 10),
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                pharmacy['name'] ?? 'Pharmacy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                  shadows: [
                    Shadow(
                      color: Colors.green.shade100,
                      offset: const Offset(1, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      pharmacy['address'] ?? '-',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text(
                    pharmacy['phone'] ?? '-',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  final telUrl = 'tel:${pharmacy['phone']}';
                  // ignore: deprecated_member_use
                  if (await canLaunch(telUrl)) {
                    // ignore: deprecated_member_use
                    await launch(telUrl);
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Cannot launch phone dialer')),
                    );
                  }
                },
                icon: const Icon(Icons.call),
                label: const Text('Call Pharmacy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: Colors.green.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = medInfo.keys
        .where((med) => med.toLowerCase().contains(searchedMed.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Pharmacy', style: TextStyle(color: Colors.blue)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for medication...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                ),
              ),
              onChanged: (value) => setState(() => searchedMed = value),
            ),

            const SizedBox(height: 20),

            if (searchedMed.isNotEmpty && medInfo.containsKey(searchedMed))
              GestureDetector(
                onTap: () => _showMedDialog(searchedMed),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.blue.shade300.withOpacity(0.4),
                        offset: const Offset(0, 8),
                        blurRadius: 16,
                      ),
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.blue.shade100.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Text(
                    medInfo[searchedMed]!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )
            else if (searchedMed.isNotEmpty && suggestions.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: suggestions.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: Colors.blueAccent,
                    thickness: 0.4,
                    indent: 20,
                    endIndent: 20,
                  ),
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return ListTile(
                      onTap: () => _showMedDialog(suggestion),
                      leading: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.blue.shade200.withOpacity(0.6),
                              blurRadius: 5,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.medical_services,
                            color: Colors.blue),
                      ),
                      title: Text(
                        suggestion,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    );
                  },
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Type a medication name to see info or suggestions.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

            const SizedBox(height: 20),

            // Pharmacies  list
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pharmacies.length,
                itemBuilder: (context, index) {
                  final pharmacy = pharmacies[index];
                  return GestureDetector(
                    onTap: () => _showPharmacyDialog(pharmacy),
                    child: Container(
                      width: 220,
                      margin: EdgeInsets.only(
                          left: index == 0 ? 12 : 8,
                          right: index == pharmacies.length - 1 ? 12 : 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.green.shade300.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.green.shade100.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.local_pharmacy,
                              size: 40, color: Colors.green.shade700),
                          const SizedBox(height: 12),
                          Text(
                            pharmacy['name'] ?? '-',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green.shade900),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.black),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  pharmacy['address'] ?? '-',
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.phone,
                                  size: 16, color: Colors.black),
                              const SizedBox(width: 6),
                              Text(
                                pharmacy['phone'] ?? '-',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SearchBarPage(),
    debugShowCheckedModeBanner: false,
  ));
}
