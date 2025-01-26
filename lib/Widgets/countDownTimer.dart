import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerApp(),
    );
  }
}

class TimerApp extends StatefulWidget {
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  Duration _selectedDuration = const Duration(hours: 0, minutes: 0, seconds: 0);
  int _remainingTimeInSeconds = 0;
  Timer? _timer;

  // Function to calculate remaining time
  void _calculateRemainingTime() {
    setState(() {
      _remainingTimeInSeconds = _selectedDuration.inSeconds;
    });
  }

  // Function to start the timer
  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _calculateRemainingTime();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTimeInSeconds > 0) {
          _remainingTimeInSeconds--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  // Function to stop the timer
  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  // Function to reset the timer
  void _resetTimer() {
    _stopTimer();
    setState(() {
      _remainingTimeInSeconds = _selectedDuration.inSeconds;
    });
  }

  // Function to show time picker
  void _showTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hms,
            initialTimerDuration: _selectedDuration,
            onTimerDurationChanged: (Duration newDuration) {
              setState(() {
                _selectedDuration = newDuration;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selected Time: ${_selectedDuration.inHours} hrs ${_selectedDuration.inMinutes % 60} mins ${_selectedDuration.inSeconds % 60} secs',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showTimePicker(context),
              child: const Text('Select Time'),
            ),
            const SizedBox(height: 20),
            Text(
              'Remaining Time: ${_remainingTimeInSeconds ~/ 3600}:${(_remainingTimeInSeconds % 3600) ~/ 60}:${_remainingTimeInSeconds % 60}',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text('Start Timer'),
                ),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: const Text('Stop Timer'),
                ),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset Timer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
