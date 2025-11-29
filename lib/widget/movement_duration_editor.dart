import 'package:flutter/material.dart';
import '../model/day_model.dart';
import 'duration_changer.dart';

class MovementDurationEditor extends StatelessWidget {
  final DayModel model;

  const MovementDurationEditor({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Move (second):",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            DurationChanger(
              currentValue: model.moveDurationSeconds,
              onDecrement: () => model.setMoveDuration(model.moveDurationSeconds - 5),
              onIncrement: () => model.setMoveDuration(model.moveDurationSeconds + 5),
              onSet: (v) => model.setMoveDuration(v),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Rest (second):",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            DurationChanger(
              currentValue: model.restDurationSeconds,
              onDecrement: () => model.setRestDuration(model.restDurationSeconds - 5),
              onIncrement: () => model.setRestDuration(model.restDurationSeconds + 5),
              onSet: (v) => model.setRestDuration(v),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}