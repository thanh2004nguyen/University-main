import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizTimer extends StatefulWidget {
  final int questionId;  // Add a field to store the question ID
  final Function(int) onTimeUp;  // Change the callback type to Function(int)
  final Key key; // Add the key parameter
  final int duration;
  final bool showText;
  QuizTimer({required this.key, required this.questionId, required this.onTimeUp, required this.duration, required this.showText}) : super(key: key);
  @override
  QuizTimerState createState() => QuizTimerState();
}

class QuizTimerState extends State<QuizTimer> {
  late SharedPreferences _prefs;
  late int _startTime;
  late final int _duration;
  int _elapsedTime = 0; // Initialize with 0
  late Timer _timer;
  bool _isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _duration = widget.duration;
    initTimer();

  }

  Future<void> initTimer() async {
    print("duration:"+_duration.toString());
    _prefs = await SharedPreferences.getInstance();
    _startTime = _prefs.getInt('startTime') ?? DateTime.now().millisecondsSinceEpoch;
    _prefs.setInt('startTime', _startTime);
    _elapsedTime = _duration ;
    if (_elapsedTime <= 0) {
      print("time enddddddddddđ");
      _elapsedTime = 0;
      _prefs.remove('startTime');
      widget.onTimeUp(widget.questionId);
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      updateTimer();
    });
    setState(() {
      _isLoading = false; // Set loading state to false after initialization
    });
  }

  void updateTimer() {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _elapsedTime = _duration - (currentTime - _startTime);
      if (_elapsedTime <= 0) {
        _elapsedTime = 0;
        _prefs.remove('startTime');
        widget.onTimeUp(widget.questionId);
// Pass the quiz exam ID or other relevant parameter
      }
    });
  }

  void restartTimer() {
    setState(() {
      _startTime = DateTime.now().millisecondsSinceEpoch;
      _prefs.setInt('startTime', _startTime);
      _elapsedTime = _duration;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        updateTimer();
      });
      clearTimer();
    });
  }

  void clearTimer(){
    _timer.cancel();
    _prefs.remove('startTime');
    print("timer cleared!!");
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showText ?  buildCenter() : Container();
  }

  Center buildCenter() {
    return Center(
    child: _isLoading
        ? CircularProgressIndicator() // Show loading indicator while data is loading
        : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Remaining Time: ${(_elapsedTime ~/ 60000).toString()} Minutes',
          style: TextStyle(fontSize: 24),
        ),
      ],
    ),
  );
  }
}
