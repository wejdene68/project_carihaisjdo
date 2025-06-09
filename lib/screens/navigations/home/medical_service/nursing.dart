import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class NursingServicesPage extends StatefulWidget {
  const NursingServicesPage({super.key});

  @override
  State<NursingServicesPage> createState() => _NursingServicesPageState();
}

class _NursingServicesPageState extends State<NursingServicesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedService = 'Home Injections';
  DateTime? _selectedDate;
  String selectedServiceFromCard = '';

  void _handleBookFromCard(String service) {
    setState(() {
      selectedServiceFromCard = service;
      _selectedService = service;
    });
    Scrollable.ensureVisible(_formKey.currentContext!,
        duration: const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Nursing Services',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.black)),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        elevation: 12,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: const Text(
                'Available Services',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            _buildServiceCard(
                'Home Injections', 'Safe injections at your home.'),
            _buildServiceCard(
                'Wound Care', 'Professional wound dressing and care.'),
            _buildServiceCard('IV Therapy', 'Intravenous therapy at home.'),
            _buildServiceCard(
                'Elderly Care', 'Daily care and assistance for seniors.'),
            _buildServiceCard(
                'Post-Surgery Care', 'Post-operation monitoring and support.'),
            _buildServiceCard(
                'Mother & Baby Care', 'Support for new mothers and babies.'),
            const SizedBox(height: 30),
            Center(
              child: ElasticIn(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: const Text(
                    'Book a Nurse',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildBookingForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.medical_services, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
          ),
          onPressed: () => _handleBookFromCard(title),
          child: const Text('Book'),
        ),
      ),
    );
  }

  Widget _buildBookingForm() {
    return Form(
      key: _formKey,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.shade100,
                        blurRadius: 12,
                        offset: const Offset(0, 8)),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Service Type'),
                  value: _selectedService,
                  items: [
                    'Home Injections',
                    'Wound Care',
                    'IV Therapy',
                    'Elderly Care',
                    'Post-Surgery Care',
                    'Mother & Baby Care',
                  ]
                      .map((service) => DropdownMenuItem(
                            value: service,
                            child: Text(service),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedService = value!;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a service type' : null,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Your Address'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your address'
                    : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : _selectedDate.toString().split(' ')[0],
                  style: const TextStyle(color: Colors.black),
                ),
                trailing:
                    Icon(Icons.calendar_today, color: Colors.blue.shade700),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _noteController,
                decoration:
                    const InputDecoration(labelText: 'Additional Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _selectedDate != null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.blue.shade50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: const Text('Appointment Summary',
                              style: TextStyle(color: Colors.blue)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Service: $_selectedService',
                                  style: const TextStyle(color: Colors.black)),
                              Text('Address: ${_addressController.text}',
                                  style: const TextStyle(color: Colors.black)),
                              Text(
                                  'Date: ${_selectedDate.toString().split(' ')[0]}',
                                  style: const TextStyle(color: Colors.black)),
                              Text('Notes: ${_noteController.text}',
                                  style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK',
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill all required fields.')),
                    );
                  }
                },
                child: const Text('Submit Request',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
