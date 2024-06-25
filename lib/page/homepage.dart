import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:page_transition/page_transition.dart';
import 'package:university/page/news_page.dart';

import '../layout/normal_layout.dart';
import '../model/news.dart';
import '../shared/shared.dart';
import 'test_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  List<News> data = [];

  getApiData()async{
String url="${mainURL}/api/public/news/all";
var response= await http.get(Uri.parse(url));
if(response.statusCode==200){
  data.clear();
  final List<dynamic> responseData = json.decode(response.body);
  responseData.forEach((json) {
    data.add(News.fromJson(json));
  });
}
  }

  @override
  Widget build(BuildContext context) {
    return NormalLayout(
      headText: 'home page',
      child: FutureBuilder(
          future: getApiData(),
          builder: (context, snapshot) {

            if(snapshot.hasError){
              return Center(child: Text("Have error happen"),);
            }else if(snapshot.connectionState== ConnectionState.waiting){
              return Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    size: 70,
                    color: Colors.purple,
                  ));
            }else{
              return Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.3,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                        ),
                        items: data.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context,
                                      PageTransition(type: PageTransitionType.rightToLeftPop,
                                          child: NewsPage(id: i.id!,), childCurrent: this));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          "${mainURL}/getimage/${i.image}",
                                          fit: BoxFit.fill,
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 40,
                                        left: 5,
                                        right: 5,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width - 20,
                                          ),
                                          child: Text(
                                            i.title!,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 22,
                                            ),
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  /* // list news*/
                  Expanded(
                    flex: 4,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                  PageTransition(type: PageTransitionType.rightToLeftPop,
                                      child: NewsPage(id: data[i].id!,), childCurrent: this));
                            },
                            child: Container(

                                height: 120,
                                margin: EdgeInsets.only(bottom: 15),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: blurColor,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(1, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child:Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Image.network(
                                        "${mainURL}/getimage/${data[i].image}",
                                        height: MediaQuery.of(context).size.height,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Title text with maxLines and overflow properties
                                            Text(
                                              data[i].title!,
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              maxLines: 2, // Adjust maxLines as needed
                                              overflow: TextOverflow.ellipsis, // Handles overflow with ellipsis
                                            ),
                                            Text(
                                              DateFormat('dd/MM/yyyy hh:mm').format(DateTime.parse(data[i].createDate!)),
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          );
                        }),
                  )
                ],
              );
            }



          }),
    );
  }
}
