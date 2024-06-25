import 'dart:convert';

import 'package:university/page/RegisterSubject/search_resul.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../component/Hien/Model/category.dart';
import '../../component/Hien/Model/student_subject.dart';
import '../../component/Hien/Model/subject.dart';
import '../../component/toLogin.dart';
import '../../layout/normal_layout.dart';
import '../../shared/common.dart';
import '../../shared/shared.dart';
import 'list_class.dart';
import 'list_register_subject.dart';


class RegisterPage extends StatefulWidget {

 const RegisterPage({super.key});


  @override
  State<RegisterPage> createState() {

   return ApiState();
  }
}

class ApiState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late SharedPreferences prefs;
  late  String jwt ="";
  late  int studentId ;
  late final int subjectId;
  late final String subjectName;
  bool showAllSubject = true;
  late List<Subject> pData = [];
  late List<Subject> searchSubject = [];
  late List<Subject> relearnSubject = [];
  late List<Subject> newSubject = [];
  late List<Category> category = [];
  late TextEditingController subjectSearchController;
  late String selectedCategory = '';
  late List<dynamic> categoryList = [];
  late String searchText = "";

  // set data for page when page start
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    initializeData(); // Call the method to initialize data
  }
  void initializeData() async {
    try {
      await CallApList();
      await ListCategory();
      await listStudentSubjects();

      setState(() {
      });
    } catch (error) {
      print('Error initializing data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return NormalLayout(
      headText: 'Register Subject',
      child: Container(
        padding: EdgeInsets.only(top: 30),
        color: BackgroundColor,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'NEW'),
                Tab(text: 'RE-LEARN'),
                Tab(text: 'On-Going-Register'),

              ],
              labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              indicatorColor: Color(0xFF546ECB),
              unselectedLabelColor: Colors.black,
              labelColor: Color(0xFF546ECB),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNew_Relearn_Tab(newSubject),
                  _buildNew_Relearn_Tab(relearnSubject),
                  _current_register_subject()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _current_register_subject(){
    return CurentRegisCLass();
  }


  Widget _buildNew_Relearn_Tab(List<Subject> foundSubject) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter code or name subject',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0XFFD9D9D9),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjust width and height
                  ),
                  onChanged: (value) {
                    searchText = value;
                    // Handle search functionality here
                  },
                ),
              ),
              SizedBox(width: 10), // Add space between search input and search button
              ElevatedButton(
                onPressed: () async {
                  print(searchText);
                  await performSearch();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomSearchDialog(searchResults: searchSubject);
                    },
                  );
                },
                child: Icon(Icons.search),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFFD9D9D9),
                  fixedSize: Size(40, 40), // Background color
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        Expanded(
          child: categoryList.length == 0
              ? Center(child: CircularProgressIndicator())
              : subject_register_body(foundSubject),
        ),
      ],
    );
  }

  Container subject_register_body(List<Subject> foundSubject) {
    return Container(
      color: BackgroundColor,
      child: Column(
        children: [

            Expanded(
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.transparent, // Remove the divider line color
                ),
                child: ListView.builder(

                  itemCount: categoryList.length,
                  itemBuilder: (context, categoryIndex) {
                    final category = categoryList[categoryIndex];
                    final categoryRooms = foundSubject.where((room) =>
                    room.subjectlevel?.name == category).toList();
                    return Container(
                      decoration: BoxDecoration(),
                      child: ExpansionTile(

                        title: Container(
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.black)),
                          ),
                          child: Text(category, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                        ),
                        children: categoryRooms.map((room) {
                         
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color(0XFFD9D9D9),
                                ),
                                child: ListTile(
                                  onTap:(){
                                    Navigator.push(
                                      context,

                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: ClassList(subjectId: room.id!, subjectName: room.name!),
                                        ctx: context,
                                      ),
                                    );
                                  },
                                  title: Text(room.name!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16), // Add space between each room
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }



  Future<void> _showSearchForm(BuildContext context) async {
    try {
      if (searchSubject == null || searchSubject.isEmpty) {
        // Show AlertDialog with message when no results are found
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Search Results'),
              content: Text('No results found'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        // Show AlertDialog with search results when available
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Search Results'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchSubject.length,
                      itemBuilder: (context, index) {
                        Subject subject = searchSubject[index];
                        return ListTile(
                          title: Text(subject.name!),
                          subtitle: Text('ID: ${subject.id}'),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error showing search form: $e');
    }
  }



  Future<void> CallApList() async {

    prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString("jwt")!;
    studentId = prefs.getInt("id")!;
    String useUrl = Ipv4PFT + "api/ClassRegister/list";

    Map<String, dynamic> requestBody = {
      "studentId": studentId
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + jwt,
    };
    var url = Uri.parse(useUrl);

    final result = await http.post(
        url, headers: headers, body: jsonEncode(requestBody));
    if (result.statusCode == 200) {
      var bodyData = jsonDecode(result.body) as List;
      List<Subject> posts = bodyData.map((postData) {
        return Subject.fromJson(postData);
      }).toList();
      setState(() {
        pData = posts;
        newSubject = pData;
      });
    }
    else if (result.statusCode == 403) {
      String? newToken = await CommonMethod.refreshToken();
      if (newToken == null) {
        if (mounted) {
          toLogin(context);
        }
      }
      else {
        var result = await http.post(
          url,
          headers: CommonMethod.createHeader(newToken),
            body: jsonEncode(requestBody)
        );

        var bodyData = jsonDecode(result.body) as List;
        List<Subject> posts = bodyData.map((postData) {
          return Subject.fromJson(postData);
        }).toList();
        setState(() {
          pData = posts;
          newSubject = pData;
        });
      }
    }
    else
      {
        print(result.statusCode);
      }
  }

  Future<void> performSearch() async {
    String url =Ipv4PFT + "searchSubject";
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
      searchText,
    );
    if (response.statusCode == 200) {
      var bodyData = jsonDecode(response.body);

      if (bodyData is List) {
        // Response is a list of subjects
        List<Subject> subjects = bodyData.map((item) => Subject.fromJson(item)).toList();

        setState(() {
          searchSubject = subjects;
        });
      } else if (bodyData is Map<String, dynamic>) {
        // Response is a single map
        Subject subject = Subject.fromJson(bodyData);

        setState(() {
          searchSubject = [subject]; // Convert the single subject to a list
        });
      }
    }
  }
  Future<void> listStudentSubjects() async {
    String url = Ipv4PFT + "listSS";
    Map<String, dynamic> requestBody = {
      "userid": 3
    };
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: "3",
    );
    if (response.statusCode == 200) {
      var bodyData = jsonDecode(response.body) as List;
      List<StudentSubject> studentSubjects = bodyData.map((studentSubjectData) {
        return StudentSubject.fromJson(studentSubjectData);
      }).toList();
      List<Subject> subjects = studentSubjects.map((studentSubject) {
        return studentSubject.classForSubject!.subject!;
      }).toList();
      setState(() {
        relearnSubject = subjects;
      });
    }
  }

  Future<void> ListCategory() async {
      jwt = prefs.getString("jwt")!;
     String useUrl = Ipv4PFT + "api/listcate";
     Map<String, String> headers = {
       'Content-Type': 'application/json',
       'Accept': 'application/json',
       'Authorization': 'Bearer ' + jwt,
     };
     var url = Uri.parse(useUrl);
     final resutl = await http.get(url, headers: headers);

    print(resutl.statusCode);
    if (resutl.statusCode == 200) {
      var bodyData = jsonDecode(resutl.body) as List;
      List<Category> listcate = bodyData.map((postData) {
        return Category.fromJson(postData);
      }).toList();
      setState(() {
        category = listcate;
        categoryList = listcate.map((category) => category.name!).toList();
        selectedCategory = categoryList.isNotEmpty ? categoryList.first : '';
      });
    }
    else if (resutl.statusCode == 403) {
      String? newToken = await CommonMethod.refreshToken();
      if (newToken == null) {
        if (mounted) {
          toLogin(context);
        }
      } else {
        var responseTwo = await http.get(
          url,
          headers: CommonMethod.createHeader(newToken),
        );
        var bodyData = jsonDecode(resutl.body) as List;
        List<Category> listcate = bodyData.map((postData) {
          return Category.fromJson(postData);
        }).toList();
        setState(() {
          category = listcate;
          categoryList = listcate.map((category) => category.name!).toList();
          selectedCategory = categoryList.isNotEmpty ? categoryList.first : '';
        });
      }
    }
    else
    {
      print("Error");
    }
  }


}