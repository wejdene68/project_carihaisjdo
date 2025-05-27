import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final Color mainColor = Colors.blueAccent;

  List<Map<String, String>> appointments = [
    {
      "title": "Dentist Appointment",
      "date": "Monday, 10 June",
      "time": "10:30 AM",
      "location": "Health Clinic, Main Street"
    },
    {
      "title": "Eye Check-up",
      "date": "Wednesday, 12 June",
      "time": "2:00 PM",
      "location": "Vision Center, 5th Avenue"
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildAppointmentCard(Map<String, String> appointment) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: mainColor, size: 30),
        title: Text(
          appointment["title"]!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${appointment["date"]} • ${appointment["time"]}"),
            const SizedBox(height: 4),
            Text("📍 ${appointment["location"]}"),
          ],
        ),
        isThreeLine: true,
        trailing:
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/equipe2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // AppBar
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Appointments",
                        style: TextStyle(
                          color: Colors.blue[200],
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black45,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Animated Appointments List
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: appointments.isEmpty
                              ? Center(
                                  child: Text(
                                    "No appointments yet.\nTap below to schedule one.",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: appointments.length,
                                  itemBuilder: (context, index) {
                                    return buildAppointmentCard(
                                        appointments[index]);
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Add Appointment Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[500],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      elevation: 10,
                    ),
                    icon: const Icon(Icons.add, size: 26),
                    label: const Text(
                      " Add Appointment",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AddAppointmentDialog(
                            onSave: (appointment) {
                              setState(() {
                                appointments.add(appointment);
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddAppointmentDialog extends StatefulWidget {
  final Function(Map<String, String>) onSave;

  const AddAppointmentDialog({super.key, required this.onSave});

  @override
  State<AddAppointmentDialog> createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  late AnimationController _dialogController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _dialogController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(
      parent: _dialogController,
      curve: Curves.easeOutBack,
    );
    _dialogController.forward();
  }

  @override
  void dispose() {
    _dialogController.dispose();
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: AlertDialog(
        // ignore: deprecated_member_use
        backgroundColor: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        titlePadding: const EdgeInsets.only(top: 20, left: 24, right: 24),
        title: const Row(
          children: [
            Icon(Icons.medical_services, color: Colors.lightBlue, size: 30),
            SizedBox(width: 10),
            Text(
              "New Appointment",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(titleController, "Title", Icons.edit_note),
                _buildDateField(),
                _buildTimeField(),
                _buildTextField(
                    locationController, "Location", Icons.location_on),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 12, right: 16),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 8,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.lightBlueAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              "Save",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSave({
                  "title": titleController.text,
                  "date": dateController.text,
                  "time": timeController.text,
                  "location": locationController.text,
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.lightBlue),
          filled: true,
          fillColor: Colors.blue[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => value!.isEmpty ? "Please enter $label" : null,
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: dateController,
        readOnly: true,
        onTap: () async {
          FocusScope.of(context).unfocus();
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 2),
          );
          if (pickedDate != null) {
            String formattedDate =
                "${_weekdayName(pickedDate.weekday)}, ${pickedDate.day} ${_monthName(pickedDate.month)}";
            setState(() {
              dateController.text = formattedDate;
            });
          }
        },
        decoration: InputDecoration(
          labelText: "Date",
          prefixIcon: const Icon(Icons.date_range, color: Colors.lightBlue),
          filled: true,
          fillColor: Colors.blue[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => value!.isEmpty ? "Please select a date" : null,
      ),
    );
  }

  Widget _buildTimeField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: timeController,
        readOnly: true,
        onTap: () async {
          FocusScope.of(context).unfocus();
          TimeOfDay? pickedTime = await showTimePicker(
              context: context, initialTime: TimeOfDay.now());
          if (pickedTime != null) {
            setState(() {
              timeController.text = pickedTime.format(context);
            });
          }
        },
        decoration: InputDecoration(
          labelText: "Time",
          prefixIcon: const Icon(Icons.access_time, color: Colors.lightBlue),
          filled: true,
          fillColor: Colors.blue[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => value!.isEmpty ? "Please select a time" : null,
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  String _weekdayName(int weekday) {
    const weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return weekdays[weekday - 1];
  }
}
