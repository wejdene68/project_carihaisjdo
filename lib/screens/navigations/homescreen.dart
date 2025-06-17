import 'dart:async';
import 'package:crohn/screens/navigations/home/medical_service/DoctorListPage.dart';
import 'package:crohn/screens/navigations/home/medical_service/mediciene.dart';
import 'package:crohn/screens/navigations/home/medical_service/nursing.dart';
import 'package:crohn/screens/navigations/home/medical_service/pharmacy.dart';
import 'package:flutter/material.dart';
import 'package:crohn/screens/navigations/home/menu.dart';
import 'doctor_card.dart';
import 'category_card.dart';
import 'package:crohn/screens/startup/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> searchItems = [
    'Dr. Ahmed Salame',
    'Dr. Karime Yh',
    'Dr. Ikrame Hannani',
    'Dr. Aziz Zouzou',
    'CHU Mustapha',
    'Crohn Disease Guide PDF',
    'Hospital El Kettar',
  ];

  List<String> filteredItems = [];
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeSceen()),
    );
  }

  void _filterSearch(String query) {
    _searchTimer?.cancel();
    if (query.isEmpty) {
      setState(() => filteredItems.clear());
      return;
    }

    setState(() {
      filteredItems = searchItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    _searchTimer = Timer(const Duration(seconds: 2), () {
      setState(() => filteredItems.clear());
    });
  }

  void openServicePage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userName = '${widget.userName.split(' ').first}!';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F9F9),
      drawer: const MenuWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Hello $userName',
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.blue[900]),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.blue[900]),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No new notifications")),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              'assets/img/1erp.webp',
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How do you feel?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Fill out your medical card right now.',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search doctors, hospitals, documents...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    if (filteredItems.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: const Icon(Icons.search),
                            title: Text(filteredItems[index]),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Medical Service
              const Text(
                'Medical Service',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryCard(
                      imagePath: 'assets/img/surgeon.webp',
                      title: 'Surgeon',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DoctorListPage()),
                        );
                      },
                    ),
                    CategoryCard(
                      imagePath: 'assets/img/doctor3.webp',
                      title: 'Medicine',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MedicinePage()),
                        );
                      },
                    ),
                    CategoryCard(
                      imagePath: 'assets/img/i3.webp',
                      title: 'Pharmacy',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchBarPage()),
                        );
                      },
                    ),
                    CategoryCard(
                      imagePath: 'assets/img/i33.webp',
                      title: 'Nursing',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NursingServicesPage()),
                        );
                      },
                    ),
                    CategoryCard(
                      imagePath: 'assets/img/doctor2.webp',
                      title: 'AI ',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NursingServicesPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Popular Doctors
              const Text(
                'Popular Doctors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    DoctorCard(
                      doctorImagePath: 'assets/img/DR1.webp',
                      rating: '4.9',
                      doctorName: 'Dr. Salah Eddine ',
                      doctorProfession: 'Gastroenterologist, 10 y.e.',
                    ),
                    DoctorCard(
                      doctorImagePath: 'assets/img/DR2.webp',
                      rating: '4.7',
                      doctorName: 'Dr. Karime Yh',
                      doctorProfession: 'IBD Specialist, 8 y.e.',
                    ),
                    DoctorCard(
                      doctorImagePath: 'assets/img/DR3.webp',
                      rating: '4.5',
                      doctorName: 'Dr. Ikrame Hannani',
                      doctorProfession: 'Nutritionist, 5 y.e.',
                    ),
                    DoctorCard(
                      doctorImagePath: 'assets/img/DR4.webp',
                      rating: '4.3',
                      doctorName: 'Dr. Aziz Zouzou',
                      doctorProfession: 'Colorectal Surgeon, 7 y.e.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
