import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/firebase/firebasefunction.dart';
import 'package:chatapp/helper/my_time_utiles.dart';
import 'package:chatapp/model/message_chat_model.dart';
import 'package:chatapp/model/user_chat_model.dart';
import 'package:chatapp/view/profile/otherusersprofilepage.dart';
import 'package:chatapp/widgets/messagecard.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../responsive/responsive.dart';

class ChatPage extends StatefulWidget {
  final ChatUserModel user;
  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageUserModel> list = [];
  final TextEditingController textController = TextEditingController();
  bool emoji = false;
  final ImagePicker picker = ImagePicker();
  bool isuploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (emoji) {
              setState(() {
                emoji = !emoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFCDE1F1),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: customappbar(context),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: Firebaseserives.getmessagedata(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //?if the data is loading

                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child: SizedBox(),
                          );
                        //?if the data is loaded and show it

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final datachat = snapshot.data?.docs;
                          list = datachat
                                  ?.map((e) =>
                                      MessageUserModel.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              padding: EdgeInsets.only(
                                  top: Responsive.h(8, context)),
                              physics: const BouncingScrollPhysics(),
                              itemCount: list.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                // return ChatUserCard(
                                //   user: _isSearch ? searchlist[index] : list[index],
                                // );
                                return MessageCard(
                                  message: list[index],
                                );
                              },
                            );
                          }
                          return Center(
                            child: Text(
                              "Say Hii 👋",
                              style: TextStyle(
                                  fontSize: Responsive.w(24, context),
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                      }
                    },
                  ),
                ),
                //?process indicator for showing uploading
                if (isuploading)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Responsive.w(10, context),
                            horizontal: Responsive.h(20, context)),
                        child: const CircularProgressIndicator(),
                      )),
                chatinputbar(context),
                if (emoji)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.35,
                    child: EmojiPicker(
                      textEditingController: textController,
                      config: Config(
                          bgColor: const Color(0xFFCDE1F1),
                          backspaceColor: const Color(0xFFCDE1F1),
                          columns: 7,
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0)),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customappbar(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtherUserProfile(user: widget.user),
            ));
      },
      child: StreamBuilder(
          stream: Firebaseserives.getuserInfo(widget.user),
          builder: (context, snapshot) {
            final datachat = snapshot.data?.docs;
            final listactive = datachat
                    ?.map((e) => ChatUserModel.fromJson(e.data()))
                    .toList() ??
                [];
            return Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Responsive.w(75, context)),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: Responsive.h(50, context),
                    width: Responsive.w(50, context),
                    imageUrl: listactive.isNotEmpty
                        ? listactive[0].image!
                        : widget.user.image!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                  ),
                ),
                SizedBox(
                  width: Responsive.w(10, context),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listactive.isNotEmpty
                          ? listactive[0].name!
                          : widget.user.name!,
                      style: TextStyle(
                          fontSize: Responsive.w(18, context),
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    ),
                    SizedBox(
                      height: Responsive.h(2, context),
                    ),
                    Text(
                      listactive.isNotEmpty
                          ? listactive[0].isOnline!
                              ? 'Online'
                              : MyDateTime.getactiveTime(
                                  context: context,
                                  activetime: listactive[0].lastActive!)
                          : MyDateTime.getactiveTime(
                              context: context,
                              activetime: widget.user.lastActive!),
                      style: TextStyle(
                          fontSize: Responsive.w(12, context),
                          fontWeight: FontWeight.w300,
                          color: Colors.black54),
                    )
                  ],
                )
              ],
            );
          }),
    );
  }

  Widget chatinputbar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(8, context),
          vertical: Responsive.h(7, context)),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => setState(() {
                            FocusScope.of(context).unfocus();
                            emoji = !emoji;
                          }),
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.black87,
                      )),
                  Expanded(
                      child: TextField(
                    controller: textController,
                    onTap: () => setState(() {
                      if (emoji) {
                        emoji = !emoji;
                      }
                    }),
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(fontWeight: FontWeight.w300),
                        hintText: "type something...",
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        //?selecting muitile images
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        //?uploading and sending image one by one
                        for (var i in images) {
                          log("path:-${i.path}");
                          setState(() {
                            isuploading = true;
                          });

                          Firebaseserives.sendchatImage(
                              widget.user, File(i.path));
                          setState(() {
                            isuploading = false;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.image,
                        color: Colors.black87,
                      )),
                  IconButton(
                      onPressed: () async {
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 60);

                        if (image != null) {
                          log("path:-${image.path}");
                          Firebaseserives.sendchatImage(
                              widget.user, File(image.path));
                        }

                        // if (image) {
                        //   // log("path:-${image.path}");
                        //   Firebaseserives.sendchatImage(
                        //       widget.user, File(image.path));
                        // }
                      },
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.black87,
                      ))
                ],
              ),
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.only(
                top: Responsive.w(15, context),
                left: Responsive.w(15, context),
                right: Responsive.w(10, context),
                bottom: Responsive.w(15, context)),
            minWidth: 0,
            shape: const CircleBorder(),
            color: Colors.green,
            onPressed: () {
              if (textController.text.isNotEmpty) {
                if (list.isEmpty) {
                  Firebaseserives.sendfirstmessage(
                      widget.user, textController.text, Type.text);
                } else {
                  Firebaseserives.sendmessage(
                      widget.user, textController.text, Type.text);
                }

                textController.clear();
              }
            },
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
