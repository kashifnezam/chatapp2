import 'package:cached_network_image/cached_network_image.dart';
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
          Container(
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
              padding: widget.message.type == Type.text
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
                  : const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: widget.message.type == Type.text
                        ? Text(widget.message.msg)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              height: 170,
                              width: 170,
                              fit: BoxFit.cover,
                              imageUrl: widget.message.msg,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.image,
                                size: 70,
                              ),
                            ),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        Api.getTime(
                            context: context, time: widget.message.sent),
                        style: TextStyle(
                            fontSize: 12, color: Colors.blueGrey[300]),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      widget.message.read == ""
                          ? const Icon(Icons.check)
                          : const Icon(Icons.done_all),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//////////////////----------------------------------///////////////////////

  Widget otherMsg() {
    if (widget.message.read.isEmpty) {
      Api.updateRead(widget.message);
      debugPrint("updated");
    }
    return Padding(
      padding: widget.message.type == Type.text
          ? const EdgeInsets.only(right: 100, left: 10, top: 10, bottom: 10)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        children: [
          Container(
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
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: widget.message.type == Type.text
                        ? Text(widget.message.msg)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              height: 170,
                              width: 170,
                              fit: BoxFit.cover,
                              imageUrl: widget.message.msg,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.image,
                                size: 70,
                              ),
                            ),
                          ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    heightFactor: 1.5,
                    child: Text(
                      Api.getTime(context: context, time: widget.message.sent),
                      style:
                          TextStyle(fontSize: 12, color: Colors.blueGrey[300]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
