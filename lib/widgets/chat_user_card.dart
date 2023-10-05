import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/firebase/firebasefunction.dart';
import 'package:chatapp/helper/my_time_utiles.dart';
import 'package:chatapp/model/message_chat_model.dart';
import 'package:chatapp/model/user_chat_model.dart';
import 'package:chatapp/view/chat_page/chatpage.dart';
import 'package:chatapp/view/responsive/responsive.dart';
import 'package:chatapp/widgets/profiledialog.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.user});

  final ChatUserModel user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  MessageUserModel? message;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(
          horizontal: Responsive.w(8, context),
          vertical: Responsive.h(4, context)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    user: widget.user,
                  ),
                ));
          },
          child: StreamBuilder(
            stream: Firebaseserives.getlastmessage(widget.user),
            builder: (context, snapshot) {
              final datachat = snapshot.data?.docs;
              final list = datachat
                      ?.map((e) => MessageUserModel.fromJson(e.data()))
                      .toList() ??
                  [];
              if (list.isNotEmpty) {
                message = list[0];
              }
              return ListTile(
                leading: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ProfileDialog(user: widget.user),
                    );
                  },
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Responsive.w(25, context)),
                    child: CachedNetworkImage(
                      height: Responsive.h(50, context),
                      width: Responsive.w(50, context),
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image!,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                    ),
                  ),
                ),
                title: Text(widget.user.name!),
                subtitle: Row(
                  children: [
                    message != null && message!.type == Type.image
                        ? const Icon(
                            Icons.image,
                            size: 16,
                          )
                        : const SizedBox(),
                    const SizedBox(
                      width: 3,
                    ),
                    Flexible(
                      child: Text(
                        message != null
                            ? message!.type == Type.image
                                ? "image"
                                : message!.msg!
                            : widget.user.about!,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                // : const Row(
                //     children: [
                //       Icon(Icons.image),
                //       Text(
                //         "image",
                //       )
                //     ],
                //   ),

                trailing: message == null
                    ? null
                    : message!.read!.isEmpty &&
                            message!.formId! != Firebaseserives.user.uid
                        ? Container(
                            height: Responsive.h(15, context),
                            width: Responsive.w(15, context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.greenAccent),
                          )
                        : Text(
                            MyDateTime.getLastMessageTime(
                                context: context, sent: message!.sent!),
                            style: const TextStyle(color: Colors.black54),
                          ),
                // trailing: const Text(
                //   "11:30am",
                //   style: TextStyle(color: Colors.black54),
                // ),
              );
            },
          )),
    );
  }
}
