import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final int timeLeftInSeconds;
  final bool isReadyPhase;
  final bool isMoveState;
  final bool isTimerRunning;
  final String currentMovementName;
  final int moveDuration;
  final int restDuration;
  final int movementsLength;
  final int currentMovementIndex;
  final int moveCount;
  final String Function(int) formatTime;
  final String nextMovementName;

  const TimerDisplay({
    super.key,
    required this.timeLeftInSeconds,
    required this.isReadyPhase,
    required this.isMoveState,
    required this.isTimerRunning,
    required this.currentMovementName,
    required this.moveDuration,
    required this.restDuration,
    required this.movementsLength,
    required this.currentMovementIndex,
    required this.moveCount,
    required this.formatTime,
    required this.nextMovementName,
  });

  @override
  Widget build(BuildContext context) {
    final targetTextColor = (isMoveState || isReadyPhase)
        ? Colors.white
        : Colors.black;

    final mainText = isReadyPhase
        ? 'GET READY!'
        : isMoveState
        ? currentMovementName
        : 'ISTIRAHAT';

    final subLabel = isReadyPhase
        ? 'Gerakan pertama: ${currentMovementName.toUpperCase()}'
        : isMoveState
        ? '${(currentMovementIndex + 1)} / $movementsLength'
        : 'NEXT: ${nextMovementName.toUpperCase()}';

    final durationText = isReadyPhase
        ? 'Bersiap'
        : isMoveState
        ? 'Durasi: $moveDuration detik'
        : 'Durasi: $restDuration detik';

    final timeDisplay = isReadyPhase
        ? timeLeftInSeconds.toString()
        : formatTime(timeLeftInSeconds);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              mainText.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.w900,
                color: targetTextColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        Text(
          subLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.0,
            color: targetTextColor.withValues(alpha: .8),
            fontWeight: isReadyPhase || !isMoveState
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 10),

        Text(
          durationText,
          style: TextStyle(
            fontSize: 18.0,
            color: targetTextColor.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 30),

        SizedBox(
          height: isReadyPhase ? 120 : 96,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              timeDisplay,
              style: TextStyle(
                fontSize: isReadyPhase ? 120.0 : 96.0,
                fontWeight: isReadyPhase ? FontWeight.w900 : FontWeight.w100,
                color: targetTextColor,
              ),
            ),
          ),
        ),

        const SizedBox(height: 50),

        Text(
          !isTimerRunning ? 'Ready' : 'Set: $moveCount',
          style: TextStyle(
            fontSize: 24.0,
            color: targetTextColor.withValues(alpha: 0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
