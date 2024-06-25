import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:university/extention/text_extention.dart';
import 'package:university/shared/shared.dart';

import '../data_type/KeyType.dart';

class InfoTag extends StatelessWidget {
  InfoTag({required this.data, this.icon, this.page, this.status, this.onIconPressed});

  List<KeyValue> data = [];
  late final Icon? icon;
  late final Widget? page;
  late final String? status;
  late final VoidCallback? onIconPressed;

  Map<String, Color> statusIcon = {
    "attend": Colors.green,
    "absent": Colors.red,
    "half": Colors.yellowAccent,
    "waiting": Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: MainColor),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3,
              offset: Offset(3, 3), // Shadow position
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < data.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: data[i].key + " : ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: data[i].value,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        softWrap: true, // Enable auto line break
                      ),
                    ),
                ],
              ),
            ),
            if (icon != null && page != null)
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: page!,
                      ctx: context,
                    ),
                  );
                },
                iconSize: 40,
                color: MainColor,
                icon: icon!,
              ),
            if (icon != null && status != null)
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      if (onIconPressed != null) {
                        onIconPressed!();
                      }

                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: page!,
                          ctx: context,
                        ),
                      );
                    },
                    iconSize: 40,
                    color: statusIcon[status] ?? Colors.grey,
                    icon: icon!,
                  ),
                  Text(
                    status!.capitalize(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
