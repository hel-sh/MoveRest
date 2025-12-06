import 'package:flutter/material.dart';
import '/model/day_model.dart';

class MovementListEditor extends StatelessWidget {
  final DayModel model;
  final List<String> movements;
  final String type;
  final Map<int, TextEditingController> controllers;
  final VoidCallback onUpdate;
  final Function(List<String>, Map<int, TextEditingController>)
  ensureControllers;

  const MovementListEditor({
    super.key,
    required this.model,
    required this.movements,
    required this.type,
    required this.controllers,
    required this.onUpdate,
    required this.ensureControllers,
  });

  @override
  Widget build(BuildContext context) {
    ensureControllers(movements, controllers);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Daftar Gerakan:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),

        for (int i = 0; i < movements.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controllers[i],
                    onSubmitted: (newValue) {
                      model.updateMovement(movements, i, newValue);
                    },
                    decoration: InputDecoration(
                      labelText: 'Gerakan ${i + 1}',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: movements.length > 1
                      ? () {
                          controllers.remove(i)?.dispose();
                          model.removeMovement(movements, i);
                          onUpdate();
                        }
                      : null,
                ),
              ],
            ),
          ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              "Tambah Gerakan",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              model.addMovement(type);
              onUpdate();
            },
          ),
        ),
      ],
    );
  }
}
