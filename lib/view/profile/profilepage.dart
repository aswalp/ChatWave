// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/helper/dialogbox.dart';
import 'package:chatapp/model/user_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../firebase/firebasefunction.dart';
import '../responsive/responsive.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});

  final ChatUserModel user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formkey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.all(Responsive.w(10, context)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Responsive.h(40, context),
                    width: MediaQuery.sizeOf(context).width,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Responsive.w(75, context)),
                              child: Image.file(
                                File(_image!),
                                fit: BoxFit.cover,
                                height: Responsive.h(150, context),
                                width: Responsive.w(150, context),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Responsive.w(75, context)),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: Responsive.h(150, context),
                                width: Responsive.w(150, context),
                                imageUrl: widget.user.image!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.person),
                              ),
                            ),
                      Positioned(
                        top: Responsive.h(100, context),
                        left: Responsive.w(80, context),
                        child: MaterialButton(
                          elevation: 1,
                          shape: const CircleBorder(),
                          color: Colors.white,
                          onPressed: () {
                            bottamsheet();
                          },
                          child: const Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Responsive.h(30, context),
                  ),
                  Text(
                    widget.user.email!,
                    style: TextStyle(
                        fontSize: Responsive.w(20, context),
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  SizedBox(
                    height: Responsive.h(20, context),
                  ),
                  TextFormField(
                    onSaved: (newValue) =>
                        Firebaseserives.me.name = newValue ?? "",
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "required field",
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "eg:-happy singh",
                        hintStyle: TextStyle(
                            fontSize: Responsive.w(16, context),
                            color: Colors.black87,
                            fontWeight: FontWeight.w300),
                        labelText: "Name",
                        labelStyle: TextStyle(
                            fontSize: Responsive.w(16, context),
                            color: Colors.black87,
                            fontWeight: FontWeight.w300),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                  SizedBox(
                    height: Responsive.h(20, context),
                  ),
                  TextFormField(
                    onSaved: (newValue) =>
                        Firebaseserives.me.about = newValue ?? "",
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "required field",
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.info_outline),
                        hintText: "eg:-feeling happy",
                        hintStyle: TextStyle(
                            fontSize: Responsive.w(16, context),
                            color: Colors.black87,
                            fontWeight: FontWeight.w300),
                        labelText: "About",
                        labelStyle: TextStyle(
                            fontSize: Responsive.w(16, context),
                            color: Colors.black87,
                            fontWeight: FontWeight.w300),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                  SizedBox(
                    height: Responsive.h(20, context),
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(Responsive.w(150, context),
                              Responsive.h(40, context)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blueAccent),
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          Firebaseserives.profileupdate().then((value) {
                            Dialogbox.showSnackbar(context, "Profile updated");
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () async {
            await Firebaseserives.updateActiveStatus(false);

            Dialogbox.progressbar(context);
            Firebaseserives.signout(context);
          },
          label: const Text(
            "Logout",
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void bottamsheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
              top: Responsive.h(15, context),
              bottom: Responsive.h(20, context)),
          children: [
            Text(
              "Pick Profile picture  ",
              style: TextStyle(
                fontSize: Responsive.w(22, context),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: Responsive.h(20, context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.white,
                      fixedSize: Size(Responsive.h(130, context),
                          Responsive.w(130, context))),
                  onPressed: () async {
                    //? Pick an image gallery.
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 80);

                    if (image != null) {
                      log("path:-${image.path}");
                      setState(() {
                        _image = image.path;
                      });
                      Firebaseserives.updateprofilepicture(File(_image!));

                      //?to remove the bottom sheet
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset(
                    "assets/icons/maincamera.png",
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.white,
                        fixedSize: Size(Responsive.h(130, context),
                            Responsive.w(130, context))),
                    onPressed: () async {
                      //? Pick an image gallery.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);

                      if (image != null) {
                        log("path:-${image.path} ");
                        setState(() {
                          _image = image.path;
                        });
                        Firebaseserives.updateprofilepicture(File(_image!));

                        //?to remove the bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset(
                      "assets/icons/picture.png",
                    ))
              ],
            )
          ],
        );
      },
    );
  }
}
