import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/day_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allDays = Provider.of<List<DayModel>>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Move Rest'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: allDays.length,
        itemBuilder: (context, index) {
          final dayModel = allDays[index];
          return Card(
            elevation: 4,
            color: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              title: Text(
                dayModel.dayName.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: dayModel,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
