import 'package:flutter/material.dart';

class HelpFaqsPage extends StatefulWidget {
  const HelpFaqsPage({super.key});

  @override
  State<HelpFaqsPage> createState() => _HelpFaqsPageState();
}

class _HelpFaqsPageState extends State<HelpFaqsPage>
    with SingleTickerProviderStateMixin {
  // Sample FAQs - you can customize the questions and answers here
  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I add a new medical record?",
      "answer":
          "Tap the '+' button on the Medical Records page, fill in the details and save."
    },
    {
      "question": "Is my medical data secure?",
      "answer": "Yes, all your data is securely stored locally on your device."
    },
    {
      "question": "Can I share my records with my doctor?",
      "answer":
          "Currently, sharing features are not available, but coming soon!"
    },
    {
      "question": "How do I reset my password?",
      "answer":
          "Go to the Profile page, tap 'Reset Password', and follow the instructions."
    },
    {
      "question": "Who can I contact for support?",
      "answer": "You can email support@medicalapp.com or call +1-800-555-1234."
    },
  ];

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Widget for each FAQ card with animation & expansion
  Widget _buildFaqItem(Map<String, String> faq, int index) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1 * index, 0.6 + 0.1 * index, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve:
                Interval(0.1 * index, 0.6 + 0.1 * index, curve: Curves.easeOut),
          ),
        ),
        child: _ExpandableFaqCard(
          question: faq['question']!,
          answer: faq['answer']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color blue400 = Colors.blue.shade400;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // ignore: deprecated_member_use
        elevation: 0,
        title: Text(
          "Help & FAQs",
          style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.w600,
              fontSize: 30),
        ),
        centerTitle: true,
        leading: BackButton(color: Colors.blue[500]),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with blue overlay
          Image.asset(
            "assets/img/BR1.jpg",
            fit: BoxFit.cover,
            // ignore: deprecated_member_use
            color: blue400.withOpacity(0.10),
            colorBlendMode: BlendMode.darken,
          ),
          Container(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ListView.builder(
              itemCount: _faqs.length,
              itemBuilder: (context, index) {
                return _buildFaqItem(_faqs[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableFaqCard extends StatefulWidget {
  final String question;
  final String answer;
  const _ExpandableFaqCard({
    required this.question,
    required this.answer,
  });

  @override
  State<_ExpandableFaqCard> createState() => _ExpandableFaqCardState();
}

class _ExpandableFaqCardState extends State<_ExpandableFaqCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color blue400 = Colors.blue.shade400;

    return GestureDetector(
      onTap: _toggleExpand,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            // 3D shadow effect
            BoxShadow(
              // ignore: deprecated_member_use
              color: blue400.withOpacity(0.3),
              offset: const Offset(8, 8),
              blurRadius: 12,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-8, -8),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: blue400,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        color: blue400,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizeTransition(
                sizeFactor: _expandAnimation,
                axisAlignment: -1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 38, right: 8),
                  child: Text(
                    widget.answer,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
