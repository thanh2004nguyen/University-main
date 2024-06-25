import 'package:flutter/cupertino.dart';
import 'package:university/shared/function_holder.dart';

import '../model/Message.dart';
import 'chat_item.dart';

class ListChat extends StatefulWidget {
  final List<Message> messages;
  final int studentId;
  final ScrollController scrollController;
  final void Function(String type, int? messId) sentMessage;

  ListChat({
    super.key,
    required this.messages,
    required this.studentId,
    required this.scrollController,
    required this.sentMessage,
  });

  @override
  State<ListChat> createState() => _ListChatState();
}

class _ListChatState extends State<ListChat> {
  bool showChange = false;

  void onTapChatItem() {
    setState(() {
      showChange = !showChange;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(1);
        FunctionHolder.callFunction();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          controller: widget.scrollController,
          itemCount: widget.messages.length,
          itemBuilder: (BuildContext context, int index) {
            return ChatItem(
              isUser: widget.messages[index].senderId == widget.studentId,
              message: widget.messages[index],
              sentMessage: widget.sentMessage, // Pass the function directly

            );
          },
        ),
      ),
    );
  }
}
