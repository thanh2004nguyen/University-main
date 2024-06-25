import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/component/Hien/Model/quiz_exam.dart';
import 'package:university/layout/normal_layout.dart';
import 'package:university/page/Quiz/result.dart';
import 'package:university/page/Quiz/timer.dart';
import '../../component/toLogin.dart';
import '../../shared/common.dart';
import '../../shared/shared.dart';
import 'main_quiz.dart';

class QuizList extends StatefulWidget {
  QuizList({super.key});


  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  final GlobalKey<QuizTimerState> quizTimerKey = GlobalKey<QuizTimerState>();
  late SharedPreferences prefs;
  late String jwt = "";
  List<QuizExam> listExam = [];
  bool isOnprocess =false;

  @override
  void initState() {
    super.initState();
    _fetchQuizExam();
  }

  Future<void> _fetchQuizExam() async {
    prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString("jwt")!;
    String useUrl = Ipv4PFT + "api/Quiz/ListExam";
    var url = Uri.parse(useUrl);
    Map<String, dynamic> requestBody = {
      "studentId": "3"
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
      setState(() {
        listExam = bodyData.map((data) => QuizExam?.fromJson(data)).toList();
        for(QuizExam a in listExam){
          if(a.status.toString() =="OnProcess")
          {
            isOnprocess = true;
          }
        }

      });
    } else if (response.statusCode == 403) {
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
        var bodyData = jsonDecode(responseTwo.body) as List;
        setState(() {
          listExam = bodyData.map((data) => QuizExam.fromJson(data)).toList();
          for(QuizExam a in listExam){
            if(a.status.toString() =="OnProcess")
            {
              isOnprocess = true;
            }
          }
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> startExam(int quizExamId)  async {
    prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString("jwt")!;
    String useUrl = Ipv4PFT + "api/Quiz/StartQuiz";
    var url = Uri.parse(useUrl);
    Map<String, dynamic> requestBody = {
      "studentId": "3",
      "quizExamId": quizExamId
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

    if (response.statusCode == 403) {
      String? newToken = await CommonMethod.refreshToken();
      if (newToken == null) {
        if (mounted) {
          toLogin(context);
        }
      }
      else {
        var responseTwo = await http.post(
          url,
          headers: CommonMethod.createHeader(newToken),
          body: jsonEncode(requestBody),
        );
      }
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context, int index,int quizExamId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to start this quiz?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Start'),
              onPressed: () {
                startExam(quizExamId);
                Navigator.of(context).pop();
                  int durationmilisec = listExam[index].quiz!.duration * 60000;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(durationQuiz: durationmilisec, examId: listExam[index].id),
                    ),
                  );
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _showConfirmationDialogContinuous(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to continue this quiz?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Start'),
              onPressed: () {
                Navigator.of(context).pop();
                // check Submit time with current time
                bool checkSubmitTime = listExam[index].submitExamTime!.isBefore(DateTime.now());
                print("time check:" + checkSubmitTime.toString());
                print("time check:" + listExam[index].submitExamTime!.toString());
                int dutationnow = DateTime.now().millisecondsSinceEpoch;
                int endtimemilisecond = listExam[index].submitExamTime!.millisecondsSinceEpoch;
                int realduration =  endtimemilisecond -dutationnow;

                print("exam id "+listExam[index].id.toString());
                if (!checkSubmitTime) {
                  int durationmilisec = realduration;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(durationQuiz: durationmilisec, examId: listExam[index].id),
                    ),
                  );

                }else{
                  quizTimerKey.currentState?.restartTimer();
                  int durationmilisec = 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(durationQuiz: durationmilisec, examId: listExam[index].id),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFF4993FA);
    const Color bgColor3 = Color.fromRGBO(241, 242, 248, 1);;
    return NormalLayout(headText: "List Quiz",
        child: ListQuizBody(bgColor3, context, bgColor)

    );
  }

  Padding ListQuizBody(Color bgColor3, BuildContext context, Color bgColor) {
    return Padding(
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              decoration: BoxDecoration(
                color: bgColor3,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.24),
                    blurRadius: 20.0,
                    offset: const Offset(0.0, 10.0),
                    spreadRadius: -10,
                    blurStyle: BlurStyle.outer,
                  )
                ],
              ),

            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Student ",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                        fontSize: 21,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    for (var i = 0; i < "Exam!!!".length; i++) ...[
                      TextSpan(
                        text: "Exam!!!"[i],
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                          fontSize: 21 + i.toDouble(),
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: listExam.length,
              itemBuilder: (context, index) {
                final topicsData = listExam[index];
                return GestureDetector(

                  onTap: () {
                    if(topicsData.status.toString() =="OnProcess")
                      {
                        _showConfirmationDialogContinuous(context, index);

                      }
                    else if(topicsData.status.toString() =="Submitted")
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizResultPage(score: 100, totalQuestions: 5),
                          ),
                        );
                      }

                    else if(topicsData.status.toString() =="Wait")
                    {
                      if(isOnprocess)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("You have to finish the current exam before moving to another one!!!"),
                            ),
                          );
                        }
                      else
                        {
                          quizTimerKey.currentState?.restartTimer();
                          _showConfirmationDialog(context, index,topicsData.id);
                        }
                    }
                  },
                  child: Card(
                    color: bgColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.confirmation_num_sharp,
                            color: Colors.white,
                            size: 55,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            topicsData.quiz?.name ?? "No title",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                              "Status:"+listExam[index].status!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                );

              },
            ),
      QuizTimer(
        key: quizTimerKey,
        questionId: 1,
        onTimeUp: (int questionId) {
          // Handle time up
        }, duration: 600000, showText: false,
      )
          ],
        ),
      );
  }
}
