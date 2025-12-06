import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/day_model.dart';
import '../model/day_list_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddDayDialog(BuildContext context, DayListManager manager) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Hari Baru'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Nama Hari (contoh: Kustom 1)",
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                manager.addDay(newName);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<DayListManager>(context);
    final dayModels = manager.dayModels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Move Rest'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dayModels.length + 1,
        itemBuilder: (context, index) {
          if (index == dayModels.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text('Tambah Hari Baru'),
                onPressed: () => _showAddDayDialog(context, manager),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
            );
          }

          final dayModel = dayModels[index];

          return ListenableProvider<DayModel>.value(
            value: dayModel,
            child: Consumer<DayModel>(
              builder: (context, model, child) {
                return Card(
                  elevation: 4,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    title: Text(
                      model.dayNickname.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/detail', arguments: model);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
