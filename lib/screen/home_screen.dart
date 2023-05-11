import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/screen/auth/api.dart';
import 'package:chatapp/screen/profile.dart';
import 'package:chatapp/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    Api.getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(_isSearching ? Icons.search : Icons.home),
            centerTitle: true,
            title: _isSearching
                ? TextField(
                    autofocus: true,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 24, 23, 23)),
                        border: InputBorder.none,
                        hintText: "Email, Name ... etc"),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    onChanged: (value) {
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          _searchList.add(i);
                        }
                      }
                      setState(() {
                        _searchList;
                      });
                    },
                  )
                : const Text("My App"),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching ? Icons.close : Icons.search),
              ),
              IconButton(
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(
                          users: Api.mydata,
                        ),
                      ))
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          body: StreamBuilder(
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
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 5),
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      itemBuilder: (context, index) => _isSearching
                          ? MyChat(user: _searchList[index])
                          : MyChat(user: _list[index]),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "No Data",
                        style: TextStyle(fontSize: 33),
                      ),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
