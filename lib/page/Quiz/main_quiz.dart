import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/page/Quiz/result.dart';
import 'package:university/page/Quiz/timer.dart';
import '../../component/Hien/Model/quiz_answer.dart';
import '../../component/Hien/Model/quiz_question.dart';
import '../../component/toLogin.dart';
import '../../layout/normal_layout.dart';
import '../../shared/common.dart';
import '../../shared/shared.dart';

class QuizPage extends StatefulWidget {
   late  int durationQuiz;
   late int examId;

   QuizPage({ required this.durationQuiz, required this.examId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {

  List<QuizQuestion> _questions = [];
  Map<int, List<QuizAnswer>> _answers = {};
  Map<int, List<int>> _selectedAnswerIds = {};
  bool _loadingQuestions = true;
  bool _loadingAnswers = false;
  late SharedPreferences prefs;
  late String jwt = "";
  int _currentIndex = 0;
  late  int durationQuiz;
  late int examId = widget.examId;


  @override
  void initState() {
    super.initState();
    _fetchQuizData();
    durationQuiz = widget.durationQuiz;
  }

  void action(response) {
    var bodyData = jsonDecode(response.body) as List;
    List<QuizQuestion> quizQuestions = bodyData.map((data) {
      return QuizQuestion.fromJson(data);
    }).toList();
    setState(() {
      _questions = quizQuestions;
      _loadingQuestions = false;
      _fetchAnswers(_questions[_currentIndex].id);
      _fetchSavedAnswer(_questions[_currentIndex].id);
    });
  }

  Future<void> _fetchQuizData() async {
    prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString("jwt")!;
    String url = Ipv4PFT + "api/Quiz";
    print("exam id send to server:"+examId.toString());
    Map<String, dynamic> requestBody = {
      "examIDD": examId
    };
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt,
      },
      body: jsonEncode(requestBody),
    );

    await CommonMethod.handleGet(response, action, context, url);
  }

  Future<void> _fetchSavedAnswer(int questionId) async {
    prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString("jwt")!;
    String useurl = Ipv4PFT + "api/Quiz/QuizExamAnswers";
    var url = Uri.parse(useurl);
    Map<String, dynamic> requestBody = {
      "questionId": questionId,
      "quizExamId": examId
    };
    final response = await http.post(
        url, headers: CommonMethod.createHeader(jwt),
        body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      var bodyData = jsonDecode(response.body) as List;
      List<int> savedAnswerIds = bodyData.cast<int>();
      setState(() {
        _selectedAnswerIds[questionId] = savedAnswerIds;
      });
    } else if (response.statusCode == 403) {
      String? newToken = await CommonMethod.refreshToken();
      if (newToken == null) {
        toLogin(context);
      } else {
        var responseTwo = await http.post(
            url, headers: CommonMethod.createHeader(newToken),
            body: jsonEncode(requestBody));
        var bodyData = jsonDecode(responseTwo.body) as List;
        List<int> savedAnswerIds = bodyData.cast<int>();
        setState(() {
          _selectedAnswerIds[questionId] = savedAnswerIds;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchAnswers(int questionId) async {
    setState(() {
      _loadingAnswers = true;
    });
    String useUrl = Ipv4PFT + "api/Quiz/ListAnswers";
    var url = Uri.parse(useUrl);
    Map<String, dynamic> requestBody = {
      "questionId": questionId
    };
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt,
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      var bodyData = jsonDecode(response.body) as List;
      List<QuizAnswer> quizAnswers = bodyData.map((data) {
        return QuizAnswer.fromJson(data);
      }).toList();
      setState(() {
        _answers[questionId] = quizAnswers;
        _loadingAnswers = false;
      });
    } else if (response.statusCode == 403) {
      String? newToken = await CommonMethod.refreshToken();
      if (newToken == null) {
        toLogin(context);
      } else {
        var responseTwo = await http.post(
            url, headers: CommonMethod.createHeader(newToken),
            body: jsonEncode(requestBody));
        var bodyData = jsonDecode(responseTwo.body) as List;
        List<QuizAnswer> quizAnswers = bodyData.map((data) {
          return QuizAnswer.fromJson(data);
        }).toList();
        setState(() {
          _answers[questionId] = quizAnswers;
          _loadingAnswers = false;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _submitQuiz(int questionID) async {
    print("Submit Quiz");
    Map<String, List<int>> stringKeyedAnswers = {
      questionID.toString(): _selectedAnswerIds[questionID] ?? []
    };
      String useUrl = Ipv4PFT + "api/Quiz/Submit";
      var url = Uri.parse(useUrl);
      prefs = await SharedPreferences.getInstance();
      jwt = prefs.getString("jwt")!;
      Map<String, dynamic> requestBody = {
        "type" : "submit",
        "quizExamId": examId,
        "answers": stringKeyedAnswers
      };
      final response = await http.post(
          url, headers: CommonMethod.createHeader(jwt),
          body: jsonEncode(requestBody));
      if (response.statusCode == 200) {
        quizTimerKey.currentState?.clearTimer();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultPage(score: 100, totalQuestions: 5,), // Ensure you pass the totalMark or other relevant data
          ),
        );
      }
      else if (response.statusCode == 403) {
        String? newToken = await CommonMethod.refreshToken();
        if (newToken == null) {
          toLogin(context);
        } else {
          var responseTwo = await http.post(
              url, headers: CommonMethod.createHeader(newToken),
              body: jsonEncode(requestBody));

          quizTimerKey.currentState?.clearTimer();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizResultPage(score: 100, totalQuestions: 5,), // Ensure you pass the totalMark or other relevant data
            ),
          );

        }
      }
      else {
        // Handle submission error
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Submission Failed"),
                content: Text(
                    "There was an error submitting your answers. Please try again."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK"),
                  )
                ],
              ),
        );
      }
  }

  void _showSubmitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Quiz Submit"),
        content: Text("Are you sure you want to submit the exam?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              quizTimerKey.currentState?.clearTimer();
              Navigator.of(context).pop(); // Close the dialog
              // Submit the quiz and navigate to the result page
              _submitQuiz(_questions[_currentIndex].id);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }


  Future<void> _goToNextQuestion(int questionID) async {
    Map<String, List<int>> stringKeyedAnswers = {
      questionID.toString(): _selectedAnswerIds[questionID] ?? []
    };
    if (_currentIndex < _questions.length - 1) {
      String useUrl = Ipv4PFT + "api/Quiz/Submit";
      var url = Uri.parse(useUrl);
      prefs = await SharedPreferences.getInstance();
      jwt = prefs.getString("jwt")!;
      Map<String, dynamic> requestBody = {
        "type": "button",
        "quizExamId": examId,
        "answers": stringKeyedAnswers
      };
      final response = await http.post(
          url, headers: CommonMethod.createHeader(jwt),
          body: jsonEncode(requestBody));

      if (response.statusCode == 200)
        {
          setState(() {
            _currentIndex++;
            _fetchAnswers(_questions[_currentIndex].id);
            _fetchSavedAnswer(_questions[_currentIndex].id);
          });
        }
    else if (response.statusCode == 403) {
      String? newToken = await CommonMethod.refreshToken();
      if (newToken == null) {
        if (mounted) {
          toLogin(context);
        }
      } else {
        var responseTwo = await http.post(
          url,
          headers: CommonMethod.createHeader(newToken),
          body: jsonEncode(requestBody),
        );
        setState(() {
          _currentIndex++;
          _fetchAnswers(_questions[_currentIndex].id);
          _fetchSavedAnswer(_questions[_currentIndex].id);
        });
      }
    }
    }
  }

  Future<void> _goToPreviousQuestion(int questionID) async {
    Map<String, List<int>> stringKeyedAnswers = {
      questionID.toString(): _selectedAnswerIds[questionID] ?? []
    };
    if (_currentIndex > 0) {

      String useUrl = Ipv4PFT + "api/Quiz/Submit";
      var url = Uri.parse(useUrl);
      prefs = await SharedPreferences.getInstance();
      jwt = prefs.getString("jwt")!;
      Map<String, dynamic> requestBody = {
        "type": "button",
        "quizExamId": examId,
        "answers": stringKeyedAnswers
      };
      final response = await http.post(
          url, headers: CommonMethod.createHeader(jwt),
          body: jsonEncode(requestBody));

      if (response.statusCode == 200)
      {
        setState(() {
          _currentIndex--;
          _fetchAnswers(_questions[_currentIndex].id);
          _fetchSavedAnswer(_questions[_currentIndex].id);
        });
      }
      else if (response.statusCode == 403) {
        String? newToken = await CommonMethod.refreshToken();
        if (newToken == null) {
          if (mounted) {
            toLogin(context);
          }
        } else {
          var responseTwo = await http.post(
            url,
            headers: CommonMethod.createHeader(newToken),
            body: jsonEncode(requestBody),
          );
          setState(() {
            _currentIndex--;
            _fetchAnswers(_questions[_currentIndex].id);
            _fetchSavedAnswer(_questions[_currentIndex].id);
          });
        }
      }
      else
        {
          print("Error");
        }
    }
  }

  void _selectSingleChoiceAnswer(int questionId, int answerId) {
    setState(() {
      _selectedAnswerIds[questionId] = [answerId];
    });
  }

  void _toggleMultipleChoiceAnswer(int questionId, int answerId) {
    setState(() {
      if (_selectedAnswerIds[questionId]?.contains(answerId) ?? false) {
        _selectedAnswerIds[questionId]?.remove(answerId);
      } else {
        _selectedAnswerIds[questionId]?.add(answerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NormalLayout(
        headText: 'Quiz Exam',
        child: Container(
            padding: EdgeInsets.only(top: 00),
            color: BackgroundColor,
            child: quiz_body(context)
        )
    );
  }
  GlobalKey<QuizTimerState> quizTimerKey = GlobalKey<QuizTimerState>();

  Widget quiz_body(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      child: _loadingQuestions
          ? Center(child: CircularProgressIndicator())
          : _questions.isEmpty
          ? Center(child: Text('No questions available'))
          : Container(
        color: Colors.lightBlue,
        child: SingleChildScrollView (
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                QuizTimer(
                  duration: durationQuiz,
                  questionId: _questions[_currentIndex].id,
                  onTimeUp: (questionId) {
                    _submitQuiz(questionId);
                  },
                  key: quizTimerKey,
                  showText: true,
                ),
                Container(

                  decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Question ${_currentIndex + 1} / ${_questions.length}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Html(
                        data: _questions[_currentIndex].content,
                      ),
                      SizedBox(height: 5),
                      _loadingAnswers
                          ? Center(child: CircularProgressIndicator())
                          : _answers[_questions[_currentIndex].id] != null
                          ? SingleChildScrollView( // Wrap with SingleChildScrollView
                        child: SizedBox(
                          height: screenHeight * 0.45,
                          child: ListView(

                            shrinkWrap: true,
                            children: _answers[_questions[_currentIndex].id]!
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              QuizAnswer answer = entry.value;
                              bool isSelected = _selectedAnswerIds[_questions[_currentIndex].id]?.contains(answer.id) ?? false;
                              String alphabet = String.fromCharCode(65 + index);
                              return Container(
                                margin: EdgeInsets.only(bottom: 2.0),
                                padding: EdgeInsets.all(2.0),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 4.0),
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: isSelected ? Colors.cyan : null,
                                  ),
                                  child: ListTile(
                                    title: Text('$alphabet. ${answer.content}'),
                                    leading: _questions[_currentIndex].type == "Multi"
                                        ? Checkbox(
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          _toggleMultipleChoiceAnswer(_questions[_currentIndex].id, answer.id);
                                        }
                                      },
                                    )
                                        : Radio<int>(
                                      value: answer.id,
                                      groupValue: isSelected ? answer.id : null,
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          _selectSingleChoiceAnswer(_questions[_currentIndex].id, value);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                          : Text('No answers available'),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _currentIndex > 0
                          ? () => _goToPreviousQuestion(_questions[_currentIndex].id)
                          : null,
                      child: Text('Previous'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        textStyle: TextStyle(fontSize: 30),
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                        minimumSize: Size(120, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                    ),
                    _currentIndex < _questions.length - 1
                        ? ElevatedButton(
                      onPressed: () => _goToNextQuestion(_questions[_currentIndex].id),
                      child: Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        textStyle: TextStyle(fontSize: 30),
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                        minimumSize: Size(200, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                    )
                        : ElevatedButton(
                      onPressed: _showSubmitConfirmationDialog,
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        textStyle: TextStyle(fontSize: 30),
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        minimumSize: Size(200, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}



