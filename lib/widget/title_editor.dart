import 'package:flutter/material.dart';
import '/model/day_model.dart';

class TitleEditor extends StatefulWidget {
  final DayModel model;
  final bool isHiit;

  const TitleEditor({super.key, required this.model, required this.isHiit});

  @override
  State<TitleEditor> createState() => _TitleEditorState();
}

class _TitleEditorState extends State<TitleEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialValue = widget.isHiit
        ? widget.model.hiitTitle
        : widget.model.woTitle;
    _controller = TextEditingController(text: initialValue);

    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final newValue = _controller.text;
    final currentValue = widget.isHiit
        ? widget.model.hiitTitle
        : widget.model.woTitle;

    if (currentValue != newValue) {
      if (widget.isHiit) {
        widget.model.setHiitTitle(newValue);
      } else {
        widget.model.setWoTitle(newValue);
      }
    }
  }

  @override
  void didUpdateWidget(TitleEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
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
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: TextField(
        controller: _controller,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }
}
