import 'dart:async';
import 'package:flutter/material.dart';
import 'doctor_card.dart';
import 'category_card.dart';
import 'new_page.dart';
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

  void navigateToNewPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPage()),
    );
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeSceen()),
    );
  }

  void _filterSearch(String query) {
    _searchTimer?.cancel(); // Cancel previous timer
    if (query.isEmpty) {
      setState(() => filteredItems.clear());
      return;
    }

    setState(() {
      filteredItems = searchItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    // Start timer to clear results after delay
    _searchTimer = Timer(const Duration(seconds: 2), () {
      setState(() => filteredItems.clear());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[300]),
              accountName: Text(widget.userName),
              accountEmail: const Text('example@email.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 60, color: Colors.blue[700]),
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
          'CROHN',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.black87, size: 28),
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: logout,
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
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        'assets/img/1erp.png',
                        height: 155,
                        width: 80,
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
                          SizedBox(height: 12),
                          Text(
                            'Fill out your medical card right now.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search doctors, hospitals, documents...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (filteredItems.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredItems[index]),
                        leading: const Icon(Icons.search),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: navigateToNewPage,
                  icon:
                      const Icon(Icons.arrow_forward_ios, color: Colors.black),
                  label: const Text(
                    'Your Doctor',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CategoryCard(
                      imagePath: 'assets/img/surgeon.png',
                      title: 'Surgeon',
                    ),
                    CategoryCard(
                      imagePath: 'assets/img/medicine.png',
                      title: 'Medicine',
                    ),
                    CategoryCard(
                      imagePath: 'assets/img/i3.png',
                      title: 'Pharmacy',
                    ),
                    CategoryCard(
                      imagePath: 'assets/img/i33.png',
                      title: 'Nursing',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Doctor List',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
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
    );
  }
}
