import 'dart:async';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F9F9),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[300]),
              accountName: Text(widget.userName),
              accountEmail: const Text('example@email.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 60, color: Colors.blue),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: logout,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'HELLO_CROHN',
          style: TextStyle(
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
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
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
                          child: Image.asset(
                            'assets/img/1erp.png',
                            height: 150,
                            fit: BoxFit.cover,
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
              const Text('Medical Service',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CategoryCard(
                        imagePath: 'assets/img/surgeon.png', title: 'Surgeon'),
                    CategoryCard(
                        imagePath: 'assets/img/medicine.png',
                        title: 'Medicine'),
                    CategoryCard(
                        imagePath: 'assets/img/i3.png', title: 'Pharmacy'),
                    CategoryCard(
                        imagePath: 'assets/img/i33.png', title: 'Nursing'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text('Popular Doctors',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    DoctorCard(
                      doctorImagePath: 'assets/img/DR1.jpg',
                      rating: '4.9',
                      doctorName: 'Dr. Ahmed Salame',
                      doctorProfession: 'Gastroenterologist, 10 y.e.',
                    ),
                    DoctorCard(
                      doctorImagePath: 'assets/img/DR2.jpg',
                      rating: '4.7',
                      doctorName: 'Dr. Karime Yh',
                      doctorProfession: 'IBD Specialist, 8 y.e.',
                    ),
                    DoctorCard(
                      doctorImagePath: 'assets/img/DR3.jpg',
                      rating: '4.5',
                      doctorName: 'Dr. Ikrame Hannani',
                      doctorProfession: 'Nutritionist, 5 y.e.',
                    ),
                    DoctorCard(
                      doctorImagePath: 'assets/img/DR4.jpg',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
