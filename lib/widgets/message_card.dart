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
    return widget.message.fromId == Api.user.uid ? selfMsg() : otherMsg();
  }

  Widget selfMsg() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 100, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              // padding: const EdgeInsets.symmetric(vertical: 6),
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  children: [
                    Text(widget.message.msg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.message.sent,
                          style: TextStyle(
                              fontSize: 12, color: Colors.blueGrey[300]),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Icon(Icons.done_all),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//////////////////----------------------------------///////////////////////

  Widget otherMsg() {
    return Padding(
      padding: const EdgeInsets.only(right: 100, left: 10, top: 10, bottom: 10),
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Text(widget.message.msg),
                    Align(
                      alignment: Alignment.bottomRight,
                      heightFactor: 1.5,
                      child: Text(
                        widget.message.read,
                        style: TextStyle(
                            fontSize: 12, color: Colors.blueGrey[300]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
