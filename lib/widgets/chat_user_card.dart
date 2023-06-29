import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/models/message_chat.dart';
import 'package:chatapp/screen/chat_screen.dart';
import 'package:flutter/material.dart';

import '../screen/auth/api.dart';

class MyChat extends StatefulWidget {
  final ChatUser user;
  const MyChat({super.key, required this.user});

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  MessageChat? _message;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                user: widget.user,
              ),
            ));
      },
      child: Card(
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(13)),
          color: const Color.fromARGB(255, 241, 242, 245),
          margin: const EdgeInsets.all(5),
          child: StreamBuilder(
            stream: Api.getLastMsg(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => MessageChat.fromJson(e.data())).toList() ??
                      [];
              if (list.isNotEmpty) {
                _message = list[0];
              }
              return ListTile(
                subtitle: _message != null
                    ? Text(
                        _message!.msg.length > 25
                            ? _message!.type == Type.text
                                ? "${_message!.msg.substring(0, 24)}..."
                                : "📷 image"
                            : _message!.msg,
                        style: _message!.read.isEmpty
                            ? _message!.fromId == widget.user.id
                                ? const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16)
                                : const TextStyle()
                            : null,
                      )
                    : Text(
                        widget.user.course,
                      ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(widget.user.name),
                trailing: _message != null
                    ? _message!.read.isEmpty
                        ? _message!.fromId == widget.user.id
                            ? const Icon(
                                Icons.circle,
                                color: Colors.blueAccent,
                              )
                            : Text(Api.getTime(
                                context: context, time: _message!.sent))
                        : Text(
                            Api.getTime(context: context, time: _message!.sent))
                    : null,
              );
            },
          )),
    );
  }
}
