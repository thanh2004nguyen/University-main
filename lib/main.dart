import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:university/page/RegisterSubject/subject_register_page.dart';
import 'package:university/page/discuss/discuss_page.dart';
import 'package:university/page/first_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:university/page/discuss/list_class_attend_page.dart';
import 'package:university/page/mark/mark_report_page.dart';
import 'package:university/page/time_table_page.dart';
import 'package:university/route/route.dart';

import 'api/firebase_api.dart';
import 'page/homepage.dart';

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("recieve message");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCK9ilCzQp50v6UNfNdMAfE4AdvHylSW9E',
    appId: '1:888092110713:android:47f9a05620cbd9d34a49a8',
    messagingSenderId: '888092110713',
    projectId: 'myuniversity-71f58',
    storageBucket: 'myuniversity-71f58.appspot.com',
  ));

  FireBaseApi.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: generateRoute
    );
  }
}
