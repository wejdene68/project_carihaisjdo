import 'package:flutter/material.dart';

class HealthTipsPage extends StatefulWidget {
  final bool isDoctor;
  const HealthTipsPage({super.key, required this.isDoctor});

  @override
  State<HealthTipsPage> createState() => _HealthTipsPageState();
}

class _HealthTipsPageState extends State<HealthTipsPage> {
  bool isFrench = false;

  final List<Map<String, dynamic>> defaultTips = [
    {
      'title_en': 'Stay Hydrated',
      'title_fr': 'Restez Hydraté',
      'desc_en':
          'Drink enough water daily to aid digestion and prevent inflammation.',
      'desc_fr':
          'Buvez suffisamment d\'eau chaque jour pour faciliter la digestion et prévenir l\'inflammation.',
      'icon': Icons.local_drink,
    },
    {
      'title_en': 'Balanced Diet',
      'title_fr': 'Régime Équilibré',
      'desc_en': 'Eat anti-inflammatory foods and avoid processed items.',
      'desc_fr':
          'Mangez des aliments anti-inflammatoires et évitez les aliments transformés.',
      'icon': Icons.restaurant,
    },
    {
      'title_en': 'Manage Stress',
      'title_fr': 'Gérez le Stress',
      'desc_en': 'Practice yoga, meditation or light walks to reduce stress.',
      'desc_fr':
          'Pratiquez le yoga, la méditation ou la marche pour réduire le stress.',
      'icon': Icons.self_improvement,
    },
    {
      'title_en': 'Regular Exercise',
      'title_fr': 'Exercice Régulier',
      'desc_en': 'Engage in regular physical activity to maintain gut health.',
      'desc_fr':
          'Pratiquez une activité physique régulière pour maintenir la santé intestinale.',
      'icon': Icons.fitness_center,
    },
    {
      'title_en': 'Avoid Smoking',
      'title_fr': 'Évitez de Fumer',
      'desc_en': 'Smoking can worsen Crohn’s symptoms. Try to quit.',
      'desc_fr':
          'Fumer peut aggraver les symptômes de Crohn. Essayez d\'arrêter.',
      'icon': Icons.smoke_free,
    },
    {
      'title_en': 'Routine Checkups',
      'title_fr': 'Examens de Routine',
      'desc_en': 'Visit your doctor regularly for monitoring and advice.',
      'desc_fr':
          'Consultez régulièrement votre médecin pour un suivi et des conseils.',
      'icon': Icons.medical_services,
    },
    {
      'title_en': 'Track Your Symptoms',
      'title_fr': 'Suivez Vos Symptômes',
      'desc_en': 'Keep a journal to record flare-ups and triggers.',
      'desc_fr':
          'Tenez un journal pour enregistrer les poussées et les déclencheurs.',
      'icon': Icons.book,
    },
    {
      'title_en': 'Get Enough Sleep',
      'title_fr': 'Dormez Suffisamment',
      'desc_en': 'Rest well to support your immune system and recovery.',
      'desc_fr':
          'Reposez-vous bien pour soutenir votre système immunitaire et la récupération.',
      'icon': Icons.bedtime,
    },
    {
      'title_en': 'Limit Dairy Products',
      'title_fr': 'Limitez les Produits Laitiers',
      'desc_en': 'Some people with Crohn’s are sensitive to lactose.',
      'desc_fr':
          'Certaines personnes atteintes de Crohn sont sensibles au lactose.',
      'icon': Icons.no_food,
    },
    {
      'title_en': 'Join Support Groups',
      'title_fr': 'Rejoignez des Groupes de Soutien',
      'desc_en': 'Connect with others to share tips and experiences.',
      'desc_fr':
          'Connectez-vous avec d\'autres pour partager des conseils et des expériences.',
      'icon': Icons.groups,
    },
  ];

  final List<Map<String, dynamic>> customTips = [];

  void toggleLanguage(bool value) {
    setState(() {
      isFrench = value;
    });
  }

  void addCustomTip() {
    String title = '';
    String desc = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Tip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (val) => title = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (val) => desc = val,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (title.isNotEmpty && desc.isNotEmpty) {
                setState(() {
                  customTips.add({
                    'title': title,
                    'desc': desc,
                    'icon': Icons.tips_and_updates,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget buildTipCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.blue.shade200.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.blue[400]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(description,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tipWidgets = defaultTips.map((tip) {
      return buildTipCard(
        icon: tip['icon'],
        title: isFrench ? tip['title_fr'] : tip['title_en'],
        description: isFrench ? tip['desc_fr'] : tip['desc_en'],
      );
    }).toList();

    tipWidgets.addAll(customTips.map((tip) {
      return buildTipCard(
        icon: tip['icon'],
        title: tip['title'],
        description: tip['desc'],
      );
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text(isFrench ? 'Conseils Santé' : 'Health Tips'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: tipWidgets,
      ),
      floatingActionButton: widget.isDoctor
          ? FloatingActionButton(
              onPressed: addCustomTip,
              backgroundColor: Colors.blue[400],
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
