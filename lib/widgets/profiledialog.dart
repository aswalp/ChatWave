import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/model/user_chat_model.dart';
import 'package:chatapp/view/profile/otherusersprofilepage.dart';
import 'package:flutter/material.dart';

import '../view/responsive/responsive.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUserModel user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(
          top: Responsive.h(1, context), left: Responsive.w(8, context)),
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.6,
        height: MediaQuery.sizeOf(context).height * 0.35,
        child: Stack(
          children: [
            SizedBox(
              width: Responsive.w(200, context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user.name!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Responsive.w(100, context)),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: Responsive.h(190, context),
                  width: Responsive.w(190, context),
                  imageUrl: user.image!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherUserProfile(user: user),
                      ));
                },
                icon: const Icon(Icons.info_outlined),
                iconSize: 34,
              ),
            )
          ],
        ),
      ),
    );
  }
}
