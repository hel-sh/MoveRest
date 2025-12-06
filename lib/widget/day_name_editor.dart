import 'package:flutter/material.dart';
import '/model/day_model.dart';

class DayNameEditor extends StatefulWidget {
  final DayModel model;

  const DayNameEditor({super.key, required this.model});

  @override
  State<DayNameEditor> createState() => _DayNameEditorState();
}

class _DayNameEditorState extends State<DayNameEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.model.dayNickname);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final newValue = _controller.text;
    final currentValue = widget.model.dayNickname;

    if (currentValue != newValue) {
      widget.model.setDayNickname(newValue);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        onSubmitted: (newValue) {
          widget.model.setDayNickname(newValue);
        },
        decoration: InputDecoration(
          labelText: 'Nama Hari (Contoh: ${widget.model.dayName})',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          hintText: widget.model.dayName,
        ),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
