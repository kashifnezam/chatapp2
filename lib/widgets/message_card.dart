import 'package:chatapp/screen/auth/api.dart';
import 'package:flutter/material.dart';

import '../models/message_chat.dart';

class MessageCard extends StatefulWidget {
  final MessageChat message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: widget.message.fromId == Api.user.uid ? singleMSg() : doubleMsg(),
    );
  }

  Widget singleMSg() {
    return Text(widget.message.msg);
  }

  Widget doubleMsg() {
    return Container(
      decoration: const BoxDecoration(color: Colors.blueAccent),
      child: Text(widget.message.msg),
    );
  }
}
