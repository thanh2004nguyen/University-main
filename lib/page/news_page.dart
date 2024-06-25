import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:university/layout/normal_layout.dart';
import 'package:http/http.dart' as http;
import 'package:university/model/news.dart';

import '../shared/shared.dart';

class NewsPage extends StatelessWidget {
   NewsPage({super.key, required this.id});
   final int id;
   late  News data;
   late String bodyshow;

    getApi() async{
     String url="${mainURL}/api/public/news/view/${id}";
var response = await http.get(Uri.parse(url));
if(response.statusCode==200){
  var jsonData= jsonDecode(response.body);
  data= News.fromJson(jsonData);
  bodyshow=transformImageStyle(data.content!);

}
   }


   String transformImageStyle(String text) {
     RegExp regex = RegExp(r'style="height:\d+px; width:\d+px"');
     String updatedText = text.replaceAllMapped(
       regex,
           (match) => match.group(0)!.replaceFirst('wid', 'style="width:100%"'),
     );

     print(updatedText);
     return [updatedText].toString();
   }


  @override
  Widget build(BuildContext context) {
   return NormalLayout(

      headText: 'News page',
      child: FutureBuilder(
        future: getApi(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(child: Text("have error happen"),);
          }else if(snapshot.connectionState== ConnectionState.waiting){
            return Center(
                child: LoadingAnimationWidget.discreteCircle(
                  size: 70,
                  color: Colors.purple,
                ));
          }else{
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text(data.title!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  Html(data:bodyshow,)
                ],
              ),
            );
          }


        },
      )
    );
  }
}
