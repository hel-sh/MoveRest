import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/day_model.dart';
import 'movement_stopwatch_screen.dart';
import '/widget/title_editor.dart';
import '/widget/movement_duration_editor.dart';
import '/widget/movement_list_editor.dart';

class DayDetailScreen extends StatefulWidget {
  const DayDetailScreen({super.key});

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  final Map<int, TextEditingController> _hiitControllers = {};
  final Map<int, TextEditingController> _woControllers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = Provider.of<DayModel>(context, listen: false);

    _ensureControllersAreInitialized(model.hiitMovements, _hiitControllers);
    _ensureControllersAreInitialized(model.woMovements, _woControllers);
  }

  void _ensureControllersAreInitialized(
      List<String> movements, Map<int, TextEditingController> controllers) {
    controllers.keys
        .where((key) => key >= movements.length)
        .toList()
        .forEach((key) {
      controllers.remove(key)?.dispose();
    });

    for (int i = 0; i < movements.length; i++) {
      if (!controllers.containsKey(i)) {
        controllers[i] = TextEditingController(text: movements[i]);
      } else if (controllers[i]!.text != movements[i]) {
        final controller = controllers[i]!;
        if (!controller.value.selection.isValid || controller.value.selection.isCollapsed) {
          controller.text = movements[i];
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: movements[i].length));
        }
      }
    }
  }

  @override
  void dispose() {
    _hiitControllers.forEach((_, controller) => controller.dispose());
    _woControllers.forEach((_, controller) => controller.dispose());


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DayModel>();
    final dayName = model.dayName;
    _ensureControllersAreInitialized(model.hiitMovements, _hiitControllers);
    _ensureControllersAreInitialized(model.woMovements, _woControllers);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rencana $dayName'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleEditor(
              model: model,
              isHiit: true,
            ),
            MovementDurationEditor(model: model),
            MovementListEditor(
              model: model,
              movements: model.hiitMovements,
              type: 'hiit',
              controllers: _hiitControllers,
              onUpdate: () => setState(() {}),
              ensureControllers: _ensureControllersAreInitialized,
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.timer),
                label: const Text("START HIIT TIMER",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: model.hiitMovements.any((m) => m.isEmpty)
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => MovementStopwatchScreen(
                        movements: model.hiitMovements,
                        moveDuration: model.moveDurationSeconds,
                        restDuration: model.restDurationSeconds,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const Divider(height: 48, thickness: 2, color: Colors.black12),

            TitleEditor(
              model: model,
              isHiit: false,
            ),
            MovementListEditor(
              model: model,
              movements: model.woMovements,
              type: 'wo',
              controllers: _woControllers,
              onUpdate: () => setState(() {}),
              ensureControllers: _ensureControllersAreInitialized,
            ),
          ],
        ),
      ),
    );
  }
}