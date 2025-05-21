import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'usermodel.dart';

class AccountScreen extends StatefulWidget {
  final UserModel user;

  const AccountScreen({super.key, required this.user});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDoctor = widget.user.isDoctor;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(isDoctor ? 'Doctor Profile' : 'Patient Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : AssetImage(widget.user.profileImage!) as ImageProvider,
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(Icons.camera_alt, color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(widget.user.fullName,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(widget.user.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            _buildInfoBox("Age", widget.user.age.toString()),
            const SizedBox(height: 10),
            _buildInfoBox("Diseases", widget.user.diseases!.join(", ")),
            const SizedBox(height: 10),
            _buildInfoBox("Medications", widget.user.medications!.join(", ")),
            const SizedBox(height: 30),
            isDoctor ? _buildDoctorActions() : _buildPatientNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(data),
        ],
      ),
    );
  }

  // Widget for Doctors
  Widget _buildDoctorActions() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Create new Ordonnance")),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.note_add_outlined),
          label:
              const Text("Create Ordonnance", style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 15),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Schedule Appointment")),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size(double.infinity, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.calendar_month_outlined),
          label: const Text("Schedule Appointment",
              style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  // Widget for Patients
  Widget _buildPatientNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: const Column(
        children: [
          Icon(Icons.info_outline, color: Colors.blueAccent, size: 40),
          SizedBox(height: 10),
          Text(
            "You are viewing your medical dossier.\nFor changes, please contact your doctor.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
