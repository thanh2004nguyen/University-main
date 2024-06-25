import 'package:flutter/material.dart';

import '../../component/Hien/Model/subject.dart';
import '../../shared/shared.dart';

class CustomSearchDialog extends StatelessWidget {
  final List<Subject> searchResults;

  CustomSearchDialog({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    print(searchResults.toString());
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {

    return Container(
      color: BackgroundColor,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Search Results',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.transparent),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0XFFD9D9D9),
                      
                    ),
                    child: ListTile(
                      title: Text(searchResults[index].name!,style: TextStyle(
                        color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500,
                      ),),
                      // You can customize the ListTile as needed
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
