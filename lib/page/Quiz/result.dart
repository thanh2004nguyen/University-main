import 'package:flutter/material.dart';
import 'package:university/page/Quiz/quiz_list.dart';
import 'package:university/page/homepage.dart';

class QuizResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  QuizResultPage({required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Result',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Score: $score out of $totalQuestions',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizList(), // Replace ResultPage with your actual ResultPage widget
                  ),
                );
              },
              child: Text("OK"),
            ),
          ],
        ),
      ),
    );
  }
}
