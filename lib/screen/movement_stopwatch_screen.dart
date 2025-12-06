import 'dart:async';
import 'package:flutter/material.dart';
import '../service/audio_player_service.dart';
import '../service/notification_service.dart';
import '../widget/timer_control.dart';
import '../widget/timer_display.dart';

class MovementStopwatchScreen extends StatefulWidget {
  final List<String> movements;
  final int moveDuration;
  final int restDuration;

  const MovementStopwatchScreen({
    super.key,
    required this.movements,
    required this.moveDuration,
    required this.restDuration,
  });

  @override
  State<MovementStopwatchScreen> createState() =>
      _MovementStopwatchScreenState();
}

class _MovementStopwatchScreenState extends State<MovementStopwatchScreen> {
  Timer? _timer;
  static const int _kInitialCountdown = 3;
  int _timeLeftInSeconds = 0;
  bool _isTimerRunning = false;

  bool _isReadyPhase = false;

  bool _isMoveState = true;
  int _moveCount = 0;
  int _currentMovementIndex = 0;

  final AudioPlayerService _audioService = AudioPlayerService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _timeLeftInSeconds = widget.moveDuration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.cancelNotification();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notificationService.cancelNotification();
    super.dispose();
  }

  void _updateNotification() {
    final currentMovementName = widget.movements[_currentMovementIndex];

    String title = _isReadyPhase
        ? 'Bersiap'
        : _isMoveState
        ? currentMovementName
        : 'ISTIRAHAT';

    String body;
    if (_isReadyPhase) {
      body =
          'Memulai: $currentMovementName | Waktu Sisa: ${_timeLeftInSeconds}s';
    } else {
      final totalMovements = widget.movements.length;
      final currentMovementNumber = _currentMovementIndex + 1;
      final setInfo =
          'Set: $_moveCount | Gerakan: $currentMovementNumber/$totalMovements';
      final time = formatTime(_timeLeftInSeconds);

      body = 'Waktu Sisa: $time\n$setInfo';
    }

    _notificationService.updateNotification(
      title: title,
      body: body,
      isMoveState: _isMoveState || _isReadyPhase,
    );
  }

  void _startPhaseTimer(int durationInSeconds) {
    _timer?.cancel();
    if (durationInSeconds <= 0) return;

    setState(() {
      _timeLeftInSeconds = durationInSeconds;
      _isTimerRunning = true;
    });

    _updateNotification();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeftInSeconds > 0) {
        setState(() {
          _timeLeftInSeconds--;
        });
        _updateNotification();
      } else {
        _timer?.cancel();
        _handlePhaseCompletion();
      }
    });
  }

  void _handlePhaseCompletion() {
    if (_isReadyPhase) {
      setState(() {
        _isReadyPhase = false;
        _moveCount = 1;
        _currentMovementIndex = 0;
        _isMoveState = true;
      });
      _audioService.playMoveStart();
      _startPhaseTimer(widget.moveDuration);
      return;
    }

    if (_isMoveState) {
      _audioService.playRestStart();
      setState(() {
        _isMoveState = false;
        _timeLeftInSeconds = widget.restDuration;
      });
    } else {
      setState(() {
        _currentMovementIndex =
            (_currentMovementIndex + 1) % widget.movements.length;
        if (_currentMovementIndex == 0) {
          _moveCount++;
        }
        _isMoveState = true;
        _timeLeftInSeconds = widget.moveDuration;
      });
      _audioService.playMoveStart();
    }
    _startPhaseTimer(_timeLeftInSeconds);
  }

  void startTimer() {
    if (_isTimerRunning) return;

    if (_moveCount == 0 && !_isReadyPhase) {
      setState(() {
        _isReadyPhase = true;
      });
      _startPhaseTimer(_kInitialCountdown);
    } else {
      _startPhaseTimer(_timeLeftInSeconds);
    }
  }

  void pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
    _notificationService.cancelNotification();
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isReadyPhase = false;
      _isMoveState = true;
      _moveCount = 0;
      _currentMovementIndex = 0;
      _timeLeftInSeconds = widget.moveDuration;
    });
    _notificationService.cancelNotification();
  }

  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentMovementName = widget.movements[_currentMovementIndex];
    final targetColor = (_isMoveState || _isReadyPhase)
        ? Colors.black
        : Colors.white;
    final nextMovementIndex =
        (_currentMovementIndex + 1) % widget.movements.length;
    final nextMovementName = widget.movements[nextMovementIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('HIIT Timer'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: targetColor,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimerDisplay(
                timeLeftInSeconds: _timeLeftInSeconds,
                isReadyPhase: _isReadyPhase,
                isMoveState: _isMoveState,
                isTimerRunning: _isTimerRunning,
                currentMovementName: currentMovementName,
                moveDuration: widget.moveDuration,
                restDuration: widget.restDuration,
                movementsLength: widget.movements.length,
                currentMovementIndex: _currentMovementIndex,
                moveCount: _moveCount,
                formatTime: formatTime,
                nextMovementName: nextMovementName,
              ),

              const SizedBox(height: 50),

              TimerControl(
                isTimerRunning: _isTimerRunning,
                startTimer: startTimer,
                pauseTimer: pauseTimer,
                resetTimer: resetTimer,
                bgColor: targetColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
