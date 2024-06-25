import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/Message.dart';
import '../shared/function_holder.dart';
import '../shared/shared.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({super.key, required this.isUser,
    required this.message,
    required this.sentMessage,
    });

  final bool isUser;
  final Message message;
  final void Function(String type,int? messId) sentMessage;


  checkTap(String val){
    print(val);
  }

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  bool isDelete = false;


check(){
setState(() {
  isDelete= false;
});
}




  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isDelete
            ? GestureDetector(
          onTap: (){
            widget.sentMessage("DELETE",widget.message.id);
          },
              child: Container(
                  width: 50,
                  margin: EdgeInsets.only(right: 10,bottom: 25),
                  height: 30,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(5),
                   border:  Border.all(width: 1.0, color: MainColor)
    ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5,left: 4),
                  child: Text("Delete",style: TextStyle(color: Colors.red),),
                ),
                ),
            )
            : SizedBox(),
        GestureDetector(
          onLongPress: () {
            FunctionHolder.setFunction(check);
            if (widget.isUser && !widget.message.deleted!) {
              setState(() {
                isDelete = true;
              });
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(8),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            decoration: BoxDecoration(
              color: widget.isUser ? Colors.green : Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: widget.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!widget.isUser)
                  Text.rich(TextSpan(children: [TextSpan(text: widget.message.senderName, style: TextStyle(fontSize: 16, color: widget.message.teacher! ? randomColor[1] : randomColor[2])), if (widget.message.teacher!) TextSpan(text: "(Teacher)", style: TextStyle(fontWeight: FontWeight.bold))])),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 8),
                  child: Text(widget.message.text!, style: TextStyle(fontSize: 16, color: widget.message.deleted! ? Colors.red : Colors.black)),
                ),
                Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(DateTime.parse(widget.message.createAt!)),
                  style: TextStyle(color: Colors.black54),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
