import 'dart:developer';

import 'package:chatapp/firebase/firebasefunction.dart';
import 'package:chatapp/helper/dialogbox.dart';
import 'package:chatapp/model/user_chat_model.dart';
import 'package:chatapp/services/api/apiservices.dart';
import 'package:chatapp/view/profile/profilepage.dart';
import 'package:chatapp/view/responsive/responsive.dart';
import 'package:chatapp/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUserModel> list = [];
  final List<ChatUserModel> searchlist = [];
  bool _isSearch = false;

  @override
  void initState() {
    super.initState();
    Firebaseserives.userselfinfo();

    //?update activestatus through lifecycle

    SystemChannels.lifecycle.setMessageHandler((message) {
      log("message:-$message");
      if (Api.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          Firebaseserives.updateActiveStatus(true);
        }

        if (message.toString().contains('pause')) {
          Firebaseserives.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearch) {
            setState(() {
              _isSearch = !_isSearch;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: _isSearch
                ? TextField(
                    onChanged: (value) {
                      searchlist.clear();
                      for (ChatUserModel i in list) {
                        if (i.name!
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email!
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          searchlist.add(i);
                          setState(() {
                            searchlist;
                          });
                        }
                      }
                    },
                    autofocus: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                        hintText: "name,email...",
                        hintStyle: TextStyle(
                            fontSize: Responsive.w(16, context),
                            fontWeight: FontWeight.w300),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  )
                : const Text(
                    "Chat With",
                  ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearch = !_isSearch;
                    });
                  },
                  icon: Icon(_isSearch
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            user: Firebaseserives.me,
                          ),
                        ));
                  },
                  icon: const Icon(Icons.more_vert))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff98c1d9),
            onPressed: () {
              addemaildialog();
            },
            child: const Icon(
              CupertinoIcons.person_add_solid,
            ),
          ),
          // get id of   only users known
          body: StreamBuilder(
            stream: Firebaseserives.getmyuserdata(),
            builder: (context, snap) {
              switch (snap.connectionState) {
                //?if the data is loading

                case ConnectionState.waiting:
                case ConnectionState.none:
                // return const Center(
                //   child: CircularProgressIndicator(),
                // );
                //?if the data is loaded and show it

                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: Firebaseserives.getdata(
                          snap.data?.docs.map((e) => e.id).toList() ?? []),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //?if the data is loading

                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          //?if the data is loaded and show it

                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;

                            list = data
                                    ?.map(
                                        (e) => ChatUserModel.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (list.isNotEmpty) {
                              return ListView.builder(
                                padding: EdgeInsets.only(
                                    top: Responsive.h(8, context)),
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    _isSearch ? searchlist.length : list.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ChatUserCard(
                                    user: _isSearch
                                        ? searchlist[index]
                                        : list[index],
                                  );
                                },
                              );
                            }
                            return Center(
                              child: Text(
                                "No connections found!",
                                style: TextStyle(
                                    fontSize: Responsive.w(24, context),
                                    fontWeight: FontWeight.w500),
                              ),
                            );
                        }
                      });
              }
              // return const Center(
              //   child: CircularProgressIndicator(),
              // );
            },
          ),
        ),
      ),
    );
  }

  addemaildialog() {
    String emailst = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                CupertinoIcons.person_add_solid,
                color: Colors.blue,
              ),
              SizedBox(
                width: Responsive.w(4, context),
              ),
              const Text("Add User"),
            ],
          ),
          content: TextFormField(
            maxLines: null,
            onChanged: (value) => emailst = value,
            decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.blue,
                ),
                hintText: "Email",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                if (emailst.isNotEmpty) {
                  await Firebaseserives.addchatuser(emailst).then((value) {
                    if (!value) {
                      Dialogbox.showSnackbar(context, "User does not Exist");
                    }
                  });
                }
                Navigator.pop(context);
              },
              child: const Text(
                "add",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            )
          ],
        );
      },
    );
  }
}
