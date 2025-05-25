import 'package:flutter/material.dart';

class HelpFaqsPage extends StatelessWidget {
  const HelpFaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & FAQs")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
            "Here you'll find answers to common questions and support info."),
      ),
    );
  }
}
