import 'package:flutter/material.dart';

class TimerControl extends StatelessWidget {
  final bool isTimerRunning;
  final VoidCallback startTimer;
  final VoidCallback pauseTimer;
  final VoidCallback resetTimer;
  const TimerControl({
    super.key,
    required this.isTimerRunning,
    required this.startTimer,
    required this.pauseTimer,
    required this.resetTimer,
    required this.bgColor,
  });

  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    final textColor = bgColor == Colors.black ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ControlButton(
          text: isTimerRunning ? 'PAUSE' : 'START',
          onPressed: isTimerRunning ? pauseTimer : startTimer,
          bgColor: textColor,
          textColor: bgColor,
        ),

        _ControlButton(
          text: 'RESET',
          onPressed: resetTimer,
          bgColor: textColor,
          textColor: bgColor,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color textColor;

  const _ControlButton({
    required this.text,
    required this.onPressed,
    required this.bgColor,
    required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(60),
            backgroundColor: bgColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 8,
          ),
          child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
