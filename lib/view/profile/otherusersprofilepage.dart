import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/helper/my_time_utiles.dart';
import 'package:chatapp/model/user_chat_model.dart';
import 'package:flutter/material.dart';

import '../responsive/responsive.dart';

class OtherUserProfile extends StatefulWidget {
  const OtherUserProfile({super.key, required this.user});
  final ChatUserModel user;

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.user.name!),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: Responsive.h(50, context),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(Responsive.w(100, context)),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height: Responsive.h(170, context),
              width: Responsive.w(170, context),
              imageUrl: widget.user.image!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.person),
            ),
          ),
          SizedBox(
            height: Responsive.h(20, context),
          ),
          Text(
            widget.user.email!,
            style: const TextStyle(fontSize: 22, color: Colors.black54),
          ),
          SizedBox(
            height: Responsive.h(10, context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "About:",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                widget.user.about!,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Joined on:",
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500),
          ),
          Text(
            MyDateTime.getLastMessageTime(
                context: context, sent: widget.user.createdAt!, showyear: true),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
