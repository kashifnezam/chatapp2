import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/screen/chat_screen.dart';
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
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(13)),
        color: const Color.fromARGB(255, 241, 242, 245),
        margin: const EdgeInsets.all(5),
        child: ListTile(
          subtitle: Text(widget.user.course),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              imageUrl: widget.user.image,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Text(widget.user.name),
          trailing: const Text("12:55 PM"),
        ),
      ),
    );
  }
}
