import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/day_model.dart';
import '/model/day_list_manager.dart';
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

  late TextEditingController _dayNameController;
  bool _isDayNameControllerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = Provider.of<DayModel>(context, listen: false);

    if (!_isDayNameControllerInitialized) {
      _dayNameController = TextEditingController(text: model.dayNickname);
      _dayNameController.addListener(() {
        final newNickname = _dayNameController.text;
        if (model.dayNickname != newNickname) {
          model.setDayNickname(newNickname);
        }
      });
      _isDayNameControllerInitialized = true;
    }

    _ensureControllersAreInitialized(model.hiitMovements, _hiitControllers);
    _ensureControllersAreInitialized(model.woMovements, _woControllers);
  }

  @override
  void dispose() {
    if (_isDayNameControllerInitialized) {
      _dayNameController.removeListener(() {});
      _dayNameController.dispose();
    }
    for (var c in _hiitControllers.values) {
      c.dispose();
    }
    for (var c in _woControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _ensureControllersAreInitialized(
    List<String> movements,
    Map<int, TextEditingController> controllers,
  ) {
    controllers.keys.where((key) => key >= movements.length).toList().forEach((
      key,
    ) {
      controllers.remove(key)?.dispose();
    });

    for (int i = 0; i < movements.length; i++) {
      if (controllers[i] == null) {
        controllers[i] = TextEditingController(text: movements[i]);
      } else if (controllers[i]!.text != movements[i]) {
        controllers[i]!.text = movements[i];
      }

      controllers[i]!.removeListener(() {});
      controllers[i]!.addListener(() {
        final model = Provider.of<DayModel>(context, listen: false);
        if (movements == model.hiitMovements) {
          model.updateMovement(movements, i, controllers[i]!.text);
        } else if (movements == model.woMovements) {
          model.updateMovement(movements, i, controllers[i]!.text);
        }
      });
    }
  }

  Future<void> _deleteDay(DayModel model, DayListManager manager) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Hari'),
        content: Text(
          'Apakah Anda yakin ingin menghapus data hari "${model.dayNickname}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await manager.removeDay(model);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _resetDay(DayModel model) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Pengaturan'),
        content: Text(
          'Apakah Anda yakin ingin mengembalikan semua pengaturan (${model.dayNickname}) ke nilai default?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await model.resetDay();

      _dayNameController.text = model.dayNickname;

      _ensureControllersAreInitialized(model.hiitMovements, _hiitControllers);
      _ensureControllersAreInitialized(model.woMovements, _woControllers);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DayModel>(context);
    final manager = Provider.of<DayListManager>(context, listen: false);

    _ensureControllersAreInitialized(model.hiitMovements, _hiitControllers);
    _ensureControllersAreInitialized(model.woMovements, _woControllers);

    if (_isDayNameControllerInitialized &&
        _dayNameController.text != model.dayNickname) {
      _dayNameController.text = model.dayNickname;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(model.dayNickname.toUpperCase()),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: TextField(
                controller: _dayNameController,
                textAlign: TextAlign.center,
                onSubmitted: (newValue) {
                  model.setDayNickname(newValue);
                },
                decoration: InputDecoration(
                  labelText: 'Nama Hari (Contoh: ${model.dayName})',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: model.dayName,
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            TitleEditor(model: model, isHiit: true),
            MovementDurationEditor(model: model),
            MovementListEditor(
              model: model,
              movements: model.hiitMovements,
              type: 'hiit',
              controllers: _hiitControllers,
              onUpdate: () => setState(() {}),
              ensureControllers: _ensureControllersAreInitialized,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ElevatedButton(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('MULAI HIIT'),
              ),
            ),
            const Divider(height: 48, thickness: 2, color: Colors.black12),

            TitleEditor(model: model, isHiit: false),
            MovementListEditor(
              model: model,
              movements: model.woMovements,
              type: 'wo',
              controllers: _woControllers,
              onUpdate: () => setState(() {}),
              ensureControllers: _ensureControllersAreInitialized,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
              child: TextButton.icon(
                icon: const Icon(Icons.refresh, color: Colors.orange),
                label: const Text(
                  'RESET SEMUA PENGATURAN HARI INI',
                  style: TextStyle(color: Colors.orange),
                ),
                onPressed: () => _resetDay(model),
              ),
            ),

            const SizedBox(height: 10),
            Center(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                label: const Text(
                  'Hapus Hari Ini',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => _deleteDay(model, manager),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
