import 'package:flutter/material.dart';

class DurationChanger extends StatefulWidget {
  final int currentValue;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final Function(int) onSet;

  const DurationChanger({
    super.key,
    required this.currentValue,
    required this.onDecrement,
    required this.onIncrement,
    required this.onSet,
  });

  @override
  State<DurationChanger> createState() => _DurationChangerState();
}

class _DurationChangerState extends State<DurationChanger> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue.toString());
  }

  @override
  void didUpdateWidget(DurationChanger oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentValue != widget.currentValue) {
      final currentText = _controller.text;
      final newValueText = widget.currentValue.toString();

      if (currentText != newValueText) {
        _controller.text = newValueText;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: newValueText.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: ElevatedButton(
            onPressed: widget.onDecrement,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.remove, size: 18),
          ),
        ),

        SizedBox(
          width: 60,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: _controller,
            onSubmitted: (value) {
              widget.onSet(int.tryParse(value) ?? 30);
            },
            style: const TextStyle(fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),

        SizedBox(
          width: 36,
          height: 36,
          child: ElevatedButton(
            onPressed: widget.onIncrement,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.add, size: 18),
          ),
        ),
      ],
    );
  }
}