import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SurgeonPage extends StatefulWidget {
  const SurgeonPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SurgeonPageState createState() => _SurgeonPageState();
}

class _SurgeonPageState extends State<SurgeonPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Surgeon', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/equipe2.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // ignore: deprecated_member_use
          Container(color: Colors.blue.withOpacity(0.6)),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
            child: Card(
              elevation: 15,
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 11),
                    const Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage('assets/img/PDR.webp'),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Dr. Jouda Bensalah",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text("Digestive Surgery Specialist"),
                        ],
                      ),
                    ),
                    const Divider(height: 30),
                    Text("Work Hours", style: sectionTitle()),
                    const SizedBox(height: 8),
                    scheduleTile("Monday - Thursday", "08:00 - 16:00"),
                    scheduleTile("Friday", "08:00 - 12:00"),
                    scheduleTile("Saturday - Sunday", "Closed"),
                    const Divider(height: 30),
                    Text("Offered Services", style: sectionTitle()),
                    const SizedBox(height: 8),
                    serviceItem("Appendectomy"),
                    serviceItem("Hernia Surgery"),
                    serviceItem("General Laparoscopy"),
                    const Divider(height: 30),
                    Text("Patient Reviews", style: sectionTitle()),
                    const SizedBox(height: 8),
                    patientReview(
                        "Amine", 5, "Very professional and attentive."),
                    patientReview("Sara", 4, "Good surgeon, I recommend."),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AppointmentPage()),
                          );
                        },
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Make an Appointment",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextStyle sectionTitle() {
    return TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]);
  }

  Widget scheduleTile(String day, String time) {
    return ListTile(
      leading: const Icon(Icons.access_time, color: Colors.black),
      title: Text(day),
      subtitle: Text(time),
    );
  }

  Widget serviceItem(String title) {
    return ListTile(
      leading: const Icon(Icons.medical_services_outlined, color: Colors.black),
      title: Text(title),
    );
  }

  Widget patientReview(String name, int stars, String comment) {
    return ListTile(
      leading: const Icon(Icons.person, color: Colors.black),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (index) {
              return Icon(index < stars ? Icons.star : Icons.star_border,
                  color: Colors.amber, size: 16);
            }),
          ),
          Text(comment),
        ],
      ),
    );
  }
}

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final reasonController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool showConfirmedCard = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      initialDate: DateTime.now(),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  void _submit() {
    if (nameController.text.isNotEmpty &&
        reasonController.text.isNotEmpty &&
        selectedDate != null &&
        selectedTime != null) {
      setState(() {
        showConfirmedCard = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Appointment Confirmed")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields")));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Make an Appointment",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/d.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // ignore: deprecated_member_use
          Container(color: Colors.blue.withOpacity(0.5)),
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Transform(
                transform: Matrix4.translationValues(0.0, 0.0, 0.0)
                  ..rotateX(0.02)
                  ..rotateY(-0.02),
                child: Card(
                  elevation: 20,
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Full Name",
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextField(
                            controller: reasonController,
                            decoration: const InputDecoration(
                              labelText: "Reason",
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _pickDate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[800],
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 8,
                                ),
                                child: Text(
                                  selectedDate == null
                                      ? "Pick Date"
                                      : "${selectedDate!.toLocal()}"
                                          .split(' ')[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _pickTime,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[800],
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 8,
                                ),
                                child: Text(
                                  selectedTime == null
                                      ? "Pick Time"
                                      : selectedTime!.format(context),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text(
                              "Confirm Appointment",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (showConfirmedCard)
                            Card(
                              elevation: 10,
                              // ignore: deprecated_member_use
                              color: Colors.green.shade100.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Appointment Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(height: 8),
                                    Text("Name: ${nameController.text}"),
                                    Text("Reason: ${reasonController.text}"),
                                    Text("Date: ${selectedDate!.toLocal()}"
                                        .split(' ')[0]),
                                    Text(
                                        "Time: ${selectedTime!.format(context)}"),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
