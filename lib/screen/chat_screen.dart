import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/models/message_chat.dart';
import 'package:chatapp/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'auth/api.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? pImage;
  void pop() {
    Navigator.pop(context, true); // dialog returns true
  }

  bool isMessage = false;
  MessageChat? message;
  List<MessageChat> _list = [];
  final textController = TextEditingController();
  bool isEmoji = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.blue, statusBarColor: Colors.blue),
    );
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () {
            if (isEmoji) {
              setState(() {
                isEmoji = !isEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              flexibleSpace: _appBar(),
            ),
            body: _chatArea(),
          ),
        ),
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
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
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
                padding: const EdgeInsets.only(left: 30),
                onPressed: () => {},
                icon: const Icon(
                  Icons.call,
                  color: Colors.white,
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(left: 20),
                onPressed: () => {},
                icon: const Icon(
                  Icons.video_call_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => {},
                icon: const Icon(
                  Icons.more_vert_sharp,
                  color: Colors.white,
                ),
              ),
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
            stream: Api.getMessages(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              _list =
                  data?.map((e) => MessageChat.fromJson(e.data())).toList() ??
                      [];

              if (_list.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 5),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _list.length,
                  itemBuilder: (context, index) =>
                      MessageCard(message: _list[index]),
                );
              } else {
                return const Center(
                  child: Text(
                    "Say Hi 👋",
                    style: TextStyle(fontSize: 33),
                  ),
                );
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
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      isEmoji = !isEmoji;
                    });
                  },
                  icon: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.blueAccent,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    onTap: () {
                      if (isEmoji) {
                        setState(() {
                          isEmoji = false;
                        });
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        if (value.trimLeft() == '') {
                          isMessage = false;
                        } else if (value == "") {
                          isMessage = false;
                        } else {
                          isMessage = true;
                          isEmoji = false;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Messages.."),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? photo = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 70);
                    if (photo != null) {
                      debugPrint("ChatImage Path $photo");
                      setState(() {
                        pImage = photo.path;
                      });
                      Api.chatImage(widget.user, File(pImage!));
                    }
                  },
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
                        onPressed: () => {
                          if (textController.text.isNotEmpty)
                            {
                              Api.sendMessage(
                                  widget.user, textController.text, Type.text),
                              textController.text = '',
                            }
                        },
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

        // this is An Emoji Section
        if (isEmoji)
          SizedBox(
            height: 240,
            child: EmojiPicker(
              textEditingController: textController,
              onEmojiSelected: (category, emoji) {
                setState(() {
                  isMessage = true;
                });
              },
              config: Config(
                columns: 12,
                bgColor: const Color.fromARGB(255, 226, 237, 247),
                emojiSizeMax: 30 * (Platform.isIOS ? 1.30 : 1.0),
                noRecents: const Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
