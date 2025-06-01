import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorContactsPage extends StatefulWidget {
  const DoctorContactsPage({super.key});

  @override
  State<DoctorContactsPage> createState() => _DoctorContactsPageState();
}

class _DoctorContactsPageState extends State<DoctorContactsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  final List<Map<String, String>> doctors = [
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
    {
      "name": "Dr. David Kim",
      "phone": "+111223344",
      "specialty": "Cardiologist"
    },
    {
      "name": "Dr. Eva Brown",
      "phone": "+9988776655",
      "specialty": "Dermatologist"
    },
    {
      "name": "Dr. Frank Wilson",
      "phone": "+5566778899",
      "specialty": "Psychiatrist"
    },
    {
      "name": "Dr. Grace Moore",
      "phone": "+4455667788",
      "specialty": "Orthopedic"
    },
    {
      "name": "Dr. Henry Clark",
      "phone": "+3344556677",
      "specialty": "Pediatrician"
    },
    {
      "name": "Dr. Irene Turner",
      "phone": "+2233445566",
      "specialty": "Endocrinologist"
    },
    {
      "name": "Dr. Jack White",
      "phone": "+1122334455",
      "specialty": "Neurologist"
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchCaller(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showPaymentDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Payment",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.payment, color: Colors.blue, size: 40),
                  const SizedBox(height: 16),
                  const Text(
                    "Payment Required",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You need to complete the payment before adding your contact.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                        ),
                        onPressed: () async {
                          const url =
                              'https://www.poste.dz/services/professional/baridimobweb';
                          Navigator.pop(context);
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url),
                                mode: LaunchMode.externalApplication);
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Could not launch payment page')),
                            );
                          }
                        },
                        child: const Text(
                          "Pay Now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Doctor Contacts"),
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        elevation: 8,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 12,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                title: Text(
                  doctor['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  "${doctor['specialty']}\n${doctor['phone']}",
                  style: const TextStyle(height: 1.5),
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.call, color: Colors.green, size: 28),
                  onPressed: () => _launchCaller(doctor['phone']!),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[600],
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text("Add Your Contact",
            style: TextStyle(color: Colors.white)),
        onPressed: _showPaymentDialog,
      ),
    );
  }
}
