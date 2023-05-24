import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/helper/dialogs.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/screen/auth/api.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'auth/authentication.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.users});
  final ChatUser users;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? pImage;
  final _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    void pop() {
      Navigator.pop(context, true); // dialog returns true
    }

    void showBottom() {
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
                  top: 30, bottom: 80, right: 15, left: 20),
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
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 70);
                        if (image != null) {
                          debugPrint("Image: ${image.path}");
                          setState(() {
                            pImage = image.path;
                          });
                          Api.updateProfilePic(File(pImage!));
                          pop();
                        }
                      },
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
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? photo = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (photo != null) {
                          debugPrint("path is: ${photo.path}");
                          setState(() {
                            pImage = photo.path;
                          });
                          Api.updateProfilePic(File(pImage!));
                          pop();
                        }
                      },
                      child: const Column(
                        children: [
                          Icon(
                            size: 122,
                            Icons.add_photo_alternate_rounded,
                          ),
                          Text("Camera"),
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
                      pImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                File(pImage!),
                                height: 170,
                                width: 170,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                height: 170,
                                width: 170,
                                fit: BoxFit.cover,
                                imageUrl: widget.users.image,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: -20,
                        child: MaterialButton(
                          onPressed: () => showBottom(),
                          height: 45,
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(
                            Icons.camera_enhance_rounded,
                            color: Colors.lightBlue,
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
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () => {
                      if (_fromKey.currentState!.validate())
                        {
                          _fromKey.currentState!.save(),
                          Api.updateUsers(),
                          debugPrint("Kashif tussi greate ho"),
                          FocusScope.of(context).unfocus(),
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
