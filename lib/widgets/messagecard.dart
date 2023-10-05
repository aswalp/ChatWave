import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/firebase/firebasefunction.dart';
import 'package:chatapp/helper/dialogbox.dart';
import 'package:chatapp/helper/my_time_utiles.dart';
import 'package:chatapp/model/message_chat_model.dart';
import 'package:chatapp/view/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final MessageUserModel message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool ismessage = Firebaseserives.user.uid == widget.message.formId;
    return InkWell(
      onTap: () => FocusScope.of(context).unfocus(),
      onLongPress: () {
        showbottomsheet(ismessage);
      },
      child: ismessage ? sentmessage() : recivedmessage(),
    );
  }

  Widget recivedmessage() {
    if (widget.message.read!.isEmpty) {
      Firebaseserives.updateMessagestatus(widget.message);
      log("read message updated");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.text
                ? Responsive.w(15, context)
                : Responsive.w(6, context)),
            margin: EdgeInsets.symmetric(
                horizontal: Responsive.w(12, context),
                vertical: Responsive.h(6, context)),
            decoration: BoxDecoration(
              color: const Color(0xFFCAFFD9),
              border: Border.all(color: Colors.green),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg!,
                    style: TextStyle(
                        fontSize: Responsive.w(15, context),
                        color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Responsive.w(20, context)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg!,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: Responsive.w(20, context)),
          child: Text(
            MyDateTime.getFormatedTime(
                context: context, time: widget.message.sent!),
            style: TextStyle(
                fontSize: Responsive.w(12, context), color: Colors.black54),
          ),
        )
      ],
    );
  }

  Widget sentmessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: Responsive.w(20, context),
            ),
            if (widget.message.read!.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            SizedBox(
              width: Responsive.w(4, context),
            ),
            Text(
              MyDateTime.getFormatedTime(
                  context: context, time: widget.message.sent!),
              style: TextStyle(
                  fontSize: Responsive.w(12, context), color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.text
                ? Responsive.w(15, context)
                : Responsive.w(6, context)),
            margin: EdgeInsets.symmetric(
                horizontal: Responsive.w(12, context),
                vertical: Responsive.h(6, context)),
            decoration: BoxDecoration(
              color: const Color(0xFF9FC1F8),
              border: Border.all(color: Colors.blue),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg!,
                    style: TextStyle(
                        fontSize: Responsive.w(15, context),
                        color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Responsive.w(5, context)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg!,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 60,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void showbottomsheet(bool isme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return ListView(
          padding: EdgeInsets.symmetric(vertical: Responsive.h(20, context)),
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: Responsive.h(4, context),
                  horizontal: Responsive.w(120, context)),
              width: MediaQuery.sizeOf(context).width,
              height: Responsive.h(5, context),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(20)),
            ),
            //copy
            widget.message.type == Type.text
                ? OptionTime(
                    icon: const Icon(
                      Icons.copy_all_rounded,
                      color: Colors.blue,
                    ),
                    name: "Copy",
                    ontap: () async {
                      log("clicked");
                      await Clipboard.setData(
                              ClipboardData(text: widget.message.msg!))
                          .then((value) {
                        Navigator.pop(context);
                        log("copied");
                        Dialogbox.showSnackbar(context, "Text Copied");
                      });
                    },
                  )
                : OptionTime(
                    icon: const Icon(
                      Icons.download,
                      color: Colors.blue,
                    ),
                    name: "Save Image",
                    ontap: () {
                      GallerySaver.saveImage(widget.message.msg!,
                              albumName: "Chat app")
                          .then((success) {
                        Navigator.pop(context);
                        if (success != null && success) {
                          Dialogbox.showSnackbar(context, "Image Saved");
                        }
                      });
                    },
                  ),
            //divider
            Divider(
              color: Colors.black54,
              indent: Responsive.w(20, context),
              endIndent: Responsive.h(20, context),
            ),
            //edit
            if (widget.message.type == Type.text && isme)
              OptionTime(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                name: "Edit Message",
                ontap: () {
                  Navigator.pop(context);

                  showeditdialog();
                },
              ),
            //delete
            if (isme)
              OptionTime(
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                name: "Delete Message",
                ontap: () async {
                  await Firebaseserives.deletemessage(widget.message)
                      .then((value) {
                    Navigator.pop(context);

                    Dialogbox.showSnackbar(context, "Message Deleted");
                  });
                },
              ),
            //divider
            if (isme)
              Divider(
                color: Colors.black54,
                indent: Responsive.w(20, context),
                endIndent: Responsive.h(20, context),
              ),
            //sent at
            OptionTime(
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.blue,
              ),
              name: "Sent At:${MyDateTime.getmessagetime(
                context: context,
                time: widget.message.sent!,
              )}",
              ontap: () {},
            ),
            //read at

            OptionTime(
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.green,
              ),
              name: widget.message.read!.isEmpty
                  ? "Read At:Not seen yet"
                  : "Read At:${MyDateTime.getmessagetime(
                      context: context,
                      time: widget.message.read!,
                    )}",
              ontap: () {},
            ),
          ],
        );
      },
    );
  }

  showeditdialog() {
    String updatemsg = widget.message.msg!;
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
                Icons.message,
                color: Colors.blue,
              ),
              SizedBox(
                width: Responsive.w(4, context),
              ),
              const Text("Update Message"),
            ],
          ),
          content: TextFormField(
            initialValue: updatemsg,
            maxLines: null,
            onChanged: (value) => updatemsg = value,
            decoration: InputDecoration(
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
              onPressed: () {
                Firebaseserives.updatemessage(widget.message, updatemsg);
                Navigator.pop(context);
              },
              child: const Text(
                "Update",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            )
          ],
        );
      },
    );
  }
}

class OptionTime extends StatelessWidget {
  const OptionTime(
      {super.key, required this.icon, required this.name, required this.ontap});

  final Icon icon;
  final String name;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: EdgeInsets.only(
            top: Responsive.h(10, context),
            left: Responsive.w(20, context),
            bottom: Responsive.h(10, context)),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: Responsive.w(10, context),
            ),
            Flexible(
              child: Text(
                name,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w300,
                    fontSize: Responsive.w(16, context)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
