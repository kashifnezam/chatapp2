import 'package:chatapp/models/chat_user.dart';
import 'package:flutter/material.dart';

class MyChat extends StatefulWidget {
  final ChatUser user;
  const MyChat({super.key, required this.user});

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(13)),
        color: const Color.fromARGB(255, 241, 242, 245),
        margin: const EdgeInsets.all(5),
        child: ListTile(
          subtitle: Text(widget.user.course),
          leading: const CircleAvatar(
            foregroundImage: NetworkImage("https://t.ly/mDUd"),
          ),
          title: Text(widget.user.name),
          trailing: const Text("12:55 PM"),
        ),
      ),
    );
  }
}
