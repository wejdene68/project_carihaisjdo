import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage>
    with TickerProviderStateMixin {
  final List<Map<String, String>> _records = [
    {
      "title": "Blood Test",
      "date": "2025-05-10",
      "summary": "Hemoglobin and glucose levels are within normal range."
    },
    {
      "title": "X-Ray",
      "date": "2025-04-20",
      "summary": "Fracture in left wrist. Healing in progress."
    },
    {
      "title": "MRI Scan",
      "date": "2025-03-15",
      "summary": "No abnormalities in brain scan."
    },
    {
      "title": "COVID-19 Test",
      "date": "2025-01-25",
      "summary": "Result: Negative. No infection detected."
    },
    {
      "title": "Allergy Report",
      "date": "2024-12-05",
      "summary": "Mild reaction to dust and pollen."
    },
    {
      "title": "Dental Checkup",
      "date": "2024-11-10",
      "summary": "Cavity filled. Next visit in 6 months."
    },
    {
      "title": "Vision Test",
      "date": "2024-10-22",
      "summary": "Slight myopia. Glasses prescribed."
    },
    {
      "title": "Ultrasound",
      "date": "2024-09-15",
      "summary": "Kidneys appear healthy and normal."
    },
    {
      "title": "Cardiac Report",
      "date": "2024-08-30",
      "summary": "Heart rhythm normal. No issues detected."
    },
    {
      "title": "Vaccination Record",
      "date": "2024-07-01",
      "summary": "Up to date with all required vaccines."
    },
  ];

  late AnimationController _bgController;
  late Animation<double> _bgAnimation;

  List<Map<String, String>> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _filteredRecords = _records;

    _bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat(reverse: true);

    _bgAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  void _filterRecords(String query) {
    setState(() {
      _filteredRecords = _records
          .where((record) =>
              record['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showAddRecordDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController summaryController = TextEditingController();
    final AnimationController dialogAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    dialogAnimationController.forward();

    showGeneralDialog(
      context: context,
      barrierLabel: "Add New Dossier",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: dialogAnimationController,
                curve: Curves.elasticOut,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(6, 6),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 20,
                      offset: Offset(-6, -6),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.medical_information, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            "Add New Medical Record",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
                          prefixIcon:
                              const Icon(Icons.title, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: "Date (YYYY-MM-DD)",
                          prefixIcon: const Icon(Icons.calendar_today,
                              color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: summaryController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Summary",
                          prefixIcon:
                              const Icon(Icons.note, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              dialogAnimationController.reverse().then((value) {
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (titleController.text.isEmpty ||
                                  dateController.text.isEmpty ||
                                  summaryController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please fill all the fields.")),
                                );
                                return;
                              }
                              final newRecord = {
                                "title": titleController.text,
                                "date": dateController.text,
                                "summary": summaryController.text,
                              };
                              setState(() {
                                _records.insert(0, newRecord);
                                _filteredRecords = _records;
                              });
                              dialogAnimationController.reverse().then((value) {
                                Navigator.of(context).pop();
                              });
                            },
                            icon: const Icon(Icons.save),
                            label: const Text("Save"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
    ).then((value) {
      dialogAnimationController.dispose();
    });
  }

  Widget _buildRecordCard(Map<String, String> record, int index) {
    AnimationController controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 + (index * 100)),
    )..forward();

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );

    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: ListTile(
            leading: const Icon(Icons.medical_services, color: Colors.blue),
            title: Text(record['title']!,
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text(
              "Date: ${record['date']}\nSummary: ${record['summary']}",
              style: GoogleFonts.roboto(fontSize: 14),
            ),
            isThreeLine: true,
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MedicalRecordDetailPage(record: record),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Medical Records",
            style:
                GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600)),
        centerTitle: true,
        // ignore: deprecated_member_use
        backgroundColor: Colors.blue.withOpacity(0.85),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRecordDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: _bgAnimation,
            child: Image.asset(
              "assets/img/equipe2.jpg",
              fit: BoxFit.cover,
              // ignore: deprecated_member_use
              color: Colors.blue.withOpacity(0.3),
              colorBlendMode: BlendMode.color,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 15),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextField(
                  onChanged: _filterRecords,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search medical dossiers",
                    filled: true,
                    // ignore: deprecated_member_use
                    fillColor: Colors.white.withOpacity(0.85),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _filteredRecords.isEmpty
                    ? Center(
                        child: Text(
                          "No records found",
                          style: GoogleFonts.roboto(
                              fontSize: 18, color: Colors.grey.shade600),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredRecords.length,
                        itemBuilder: (context, index) {
                          return _buildRecordCard(
                              _filteredRecords[index], index);
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MedicalRecordDetailPage extends StatelessWidget {
  final Map<String, String> record;

  const MedicalRecordDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(record['title'] ?? "Detail"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record['title'] ?? "",
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Date: ${record['date'] ?? ""}",
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            Text(
              record['summary'] ?? "",
              style: GoogleFonts.roboto(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
