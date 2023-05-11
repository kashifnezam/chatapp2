import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/helper/dialogs.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/screen/auth/api.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth/authentication.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.users});
  final ChatUser users;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    void _showBottom() {
      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          context: context,
          builder: (_) {
            return ListView(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 50, right: 15, left: 20),
              shrinkWrap: true,
              children: [
                const Text(
                  "Profile Picture",
                  // textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => {},
                      child: const Column(
                        children: [
                          Icon(
                            size: 122,
                            Icons.camera,
                          ),
                          Text("Gallary"),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {},
                      child: const Column(
                        children: [
                          Icon(
                            size: 122,
                            Icons.add_photo_alternate_rounded,
                          ),
                          Text("Gallary"),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          });
    }

    final mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Profile"),
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => {
                  Dialogs.showProgressbar(context),
                  Api.auth.signOut().then(
                        (value) => GoogleSignIn().signOut().then(
                          (value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AuthScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                },
            icon: const Icon(Icons.logout_outlined),
            label: const Text("Logout")),
        body: Form(
          key: _fromKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          height: 170,
                          fit: BoxFit.fill,
                          imageUrl: widget.users.image,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                        top: mq.height * 0.15,
                        left: mq.width * 0.25,
                        child: MaterialButton(
                          onPressed: () => _showBottom(),
                          height: 45,
                          shape: const CircleBorder(),
                          color: Colors.lightBlue,
                          child: const Icon(
                            Icons.camera_enhance_rounded,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.users.email,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  TextFormField(
                    onSaved: (newValue) => Api.mydata.name = newValue ?? "",
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "Required Field",
                    initialValue: widget.users.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      hintText: "eg. Kashif Nezam",
                      label: Text("Your Name"),
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (newValue) => Api.mydata.about = newValue ?? "",
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "Required Field",
                    initialValue: widget.users.about,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      hintText: "eg. feeling Happy",
                      label: Text("Status"),
                      prefixIcon:
                          Icon(Icons.info_outline_rounded, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MaterialButton(
                    onPressed: () => {
                      if (_fromKey.currentState!.validate())
                        {
                          _fromKey.currentState!.save(),
                          Api.updateUsers(),
                          debugPrint("Kashif tussi greate ho"),
                          Dialogs.showMsgbar(context, "Changes Updated!")
                        }
                    },
                    color: Colors.blue[300],
                    child: const Text("Submit"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
