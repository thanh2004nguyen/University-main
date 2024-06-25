import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:university/shared/common.dart';
import '../../component/list_chart.dart';
import '../../data_type/ReciveMessage.dart';
import '../../data_type/SendMessage.dart';
import '../../layout/normal_layout.dart';
import '../../model/Message.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared.dart';

class DiscussPage extends StatefulWidget {
  DiscussPage({super.key, required this.roomId, required this.Topic});

  final int roomId;
  final String Topic;

  @override
  State<DiscussPage> createState() => _DiscussState();
}

class _DiscussState extends State<DiscussPage> {
  late StompClient client;
  late SharedPreferences prefs;
  late String jwt;
  final ScrollController _scrollController = ScrollController();
  final messageController = TextEditingController();

  late int userId = 0;

  List<Message> messages = [];

  void onConnectCallback(StompFrame connectFrame) async {
    print("connected");
    client.subscribe(
      destination: '/topic/public/${widget.roomId}',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt,
      },
      callback: (frame) {
        var jsonData = json.decode(frame.body!);

        ReciveMessage data = ReciveMessage.fromJson(jsonData);
        print(frame.body);
        print(userId);
        if (data.type == "CHAT") {
          setState(() {
            messageController.text="";
            messages.add(Message(
              id: data.id,
              text: data.text,
              createAt: data.createAt,
              senderName: data.senderName,
              senderId: data.senderId,
              teacher: true,
            ));
          });

          scrollToBottom();
        }

        if (data.type == "DELETE") {
          messages.forEach((e) {
            if (e.id == data.id) {
              e.text = "This message is deleted";
              e.deleted = true;
            }
            setState(() {});
            scrollToBottom();
          });
        }

        if (data.type == "OVER") {
          if (data.senderId == userId) {
            AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.error,
              body: Center(
                child: Text(
                  "This discussion is expired, can't send new message",
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
              ),
              title: 'This is Ignored',
              desc: 'This is also Ignored',
              btnOkOnPress: () {},
            )..show();
          }
        }
      },
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      // At the bottom of ListView
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void action(response) {
    final List<dynamic> responseData = json.decode(response.body);
    setState(() {
      responseData.forEach((json) {
        messages.add(Message.fromJson(json));
      });
    });
  }

  void sendMessage(String type,int? messId) {
    Map<String, String> headers = {"Content-type": "application/json"};
    SendMessage mess;
    if (type == "CHAT") {
      mess = SendMessage(
        sender: 'new sender',
        content: messageController.text,
        id: userId,
        type: 'CHAT',
        roomId: widget.roomId,
      );
    } else {
      mess = SendMessage(
        sender: 'new sender',
        content: messId!= null ? messId.toString(): "0" ,
        id: userId,
        type: 'DELETE',
        roomId: widget.roomId,
      );
    }

    client.send(
      destination: '/app/chat.sendMessage/${widget.roomId}',
      body: jsonEncode(mess),
      headers: headers,
    );
    scrollToBottom();
  }

  Future getPageData() async {
    prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString("jwt")!;
    userId = prefs.getInt("id")!;
    handleClient(jwt);
    String useUrl = '$mainURL/api/discuss/room/${widget.roomId}';
    Map<String, String> headers = {"Content-type": "application/json"};
    var response = await http.get(Uri.parse(useUrl), headers: headers);
    await CommonMethod.handleGet(response, action, context, Uri.parse(useUrl));
  }

  handleClient(jwt) {
    client = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: onConnectCallback,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) {
          print(error);
          client.deactivate();
        },
        stompConnectHeaders: {'Authorization': 'Bearer ' + jwt},
        webSocketConnectHeaders: {'Authorization': 'Bearer ' + jwt},
      ),
    );
    return client.activate();
  }

  @override
  void initState() {
    getPageData();
    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    client.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    scrollToBottom();
    return NormalLayout(
      headText: "Discuss",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: blurColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            height: 50,
            child: Center(
              child: Text.rich(TextSpan(children: [TextSpan(text: "Topic :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), TextSpan(text: widget.Topic)])),
            ),
          ),
          Flexible(
            child: ListChat(
              messages: messages,
              studentId: userId,
              scrollController: _scrollController,
              sentMessage: sendMessage, // Pass the function directly
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(3, 0),
                ),
              ],
            ),
            height: 50,
            child: Container(
              decoration: BoxDecoration(border: Border.all(width: 1.5, color: MainColor)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Enter your message",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (messageController.text.trim().isNotEmpty) {
                        sendMessage("CHAT",null);
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: Icon(
                      Icons.send,
                      color: MainColor,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
