import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth/api.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isMessage = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.blue, statusBarColor: Colors.blue),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          // title: Text(widget.user.name),
          flexibleSpace: _appBar(),
        ),
        body: _chatArea(),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () => {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                  imageUrl: widget.user.image,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "last seen not Available",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
            ],
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  padding: EdgeInsets.only(left: 30),
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.call,
                    color: Colors.white,
                  )),
              IconButton(
                  padding: EdgeInsets.only(left: 20),
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.video_call_outlined,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.more_vert_sharp,
                    color: Colors.white,
                  )),
            ],
          )),
        ],
      ),
    );
  }

  Widget _chatArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: StreamBuilder(
            stream: Api.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  // final data = snapshot.data?.docs;
                  // _list =
                  //     data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                  //         [];
                  final list = ['hi', 'this'];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                        padding: const EdgeInsets.only(top: 5),
                        physics: const BouncingScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) => Text(list[index]));
                  } else {
                    return const Center(
                      child: Text(
                        "Say Hi 👋",
                        style: TextStyle(fontSize: 33),
                      ),
                    );
                  }
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: const Color.fromARGB(255, 226, 237, 247),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.blueAccent,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        if (value == "") {
                          isMessage = false;
                        } else {
                          isMessage = true;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Messages.."),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.attach_file,
                    color: Colors.blueAccent,
                  ),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.blueAccent,
                  ),
                ),
                isMessage
                    ? IconButton(
                        onPressed: () => {},
                        icon: const Icon(
                          Icons.send_outlined,
                          color: Colors.blueAccent,
                        ),
                      )
                    : IconButton(
                        onPressed: () => {},
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.blueAccent,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
