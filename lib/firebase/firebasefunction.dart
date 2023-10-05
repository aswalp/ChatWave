import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'dart:math';

import 'package:chatapp/helper/dialogbox.dart';
import 'package:chatapp/model/message_chat_model.dart';
import 'package:chatapp/model/user_chat_model.dart';
import 'package:chatapp/services/api/apiservices.dart';
import 'package:chatapp/view/auth/loginsrceen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

class Firebaseserives {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //?  for firebase storage images
  static FirebaseStorage stroage = FirebaseStorage.instance;

  static User get user => Api.auth.currentUser!;

  static late ChatUserModel me;

  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  static Future<void> getfirebasemessages() async {
    await fmessaging.requestPermission();
    await fmessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log("token:-$t");
      }

      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   log('Got a message whilst in the foreground!');
      //   log('Message data: ${message.data}');

      //   if (message.notification != null) {
      //     log('Message also contained a notification: ${message.notification}');
      //   }
      // });
    });
  }

  static Future<void> sendpushnotification(
      ChatUserModel chatuser, String msg) async {
    try {
      final body = {
        "to": chatuser.pushToken,
        "notification": {
          "title": chatuser.name,
          "body": msg,
          "android_channel_id": "chats",
        },
        "data": {
          "some_data": "User_id=${me.id}",
        },
      };
      var response =
          await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    "key=AAAAChvMQVs:APA91bHaOMtEPY7tdm7cm4OEpxRALrwTFhP1u0g5l-J4pNJSf3z1Vow4z1RrSoPKuI_lxKOuWQDahQc_j2q0dxB4-B11KpYYyn6JlJ_IwqlOJ0zTLlKeLSyddN7_7vcAy1Tr9BbufasQ",
              },
              body: jsonEncode(body));
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log('sendpushnotification:$e');
    }
  }

  //? for google signin

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (e) {
      log('select your account:$e');
      Dialogbox.showSnackbar(context, "select your account");
      return null;
    } catch (e) {
      log('Signwithgoogle:$e');
      Dialogbox.showSnackbar(context, "Something went wrong(check internet)");

      return null;
    }
  }
  //? for google signout

  static void signout(BuildContext context) async {
    await Api.auth.signOut().then((value) async {
      await GoogleSignIn().signOut().then((value) {
        //? remove the progress bar
        Navigator.pop(context);
        //?for moving to home screen
        Navigator.pop(context);
        //?replacing home screen  with login screen
        Api.auth = FirebaseAuth.instance;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      });
    });
  }

  //? for getting all user data expect logined users

  static Stream<QuerySnapshot<Map<String, dynamic>>> getdata(
      List<String> userids) {
    log("Userid:-$userids");
    return firestore
        .collection("user")
        .where('id', whereIn: userids.isEmpty ? [''] : userids)
        .snapshots();
  }

//? get all users for particlar  users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getmyuserdata() {
    return firestore
        .collection("user")
        .doc(user.uid)
        .collection("my_users")
        .snapshots();
  }

  //? check wheather the user exist or not

  static Future<bool> userExist() async {
    return (await firestore.collection("user").doc(user.uid).get()).exists;
  }

  //?add the chat  users

  static Future<bool> addchatuser(String email) async {
    final data = await firestore
        .collection("user")
        .where("email", isEqualTo: email)
        .get();

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      firestore
          .collection("user")
          .doc(user.uid)
          .collection("my_users")
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      return false;
    }
  }

  static Future<void> createuser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = ChatUserModel(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "hey chat with me",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: "",
    );
    return await firestore
        .collection("user")
        .doc(user.uid)
        .set(chatuser.toJson());
  }

  //? to get yourself data
  static Future<void> userselfinfo() async {
    await firestore
        .collection("user")
        .doc(user.uid)
        .get()
        .then((userdata) async {
      if (userdata.exists) {
        me = ChatUserModel.fromJson(userdata.data()!);
        await getfirebasemessages();
        //?update active when app app open
        Firebaseserives.updateActiveStatus(true);
      } else {
        await createuser().then((value) => userselfinfo());
      }
    });
  }
  //? to show other user to message on there chat page

  static Future<void> sendfirstmessage(
      ChatUserModel chatUserModel, String msg, Type type) async {
    await firestore
        .collection("user")
        .doc(chatUserModel.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendmessage(chatUserModel, msg, type));
  }

  //?for user info data

  static Future<void> profileupdate() async {
    await firestore
        .collection("user")
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> updateprofilepicture(File file) async {
    final ext = file.path.split(".").last;
    log("extraction:-$ext");
    final ref = stroage.ref().child("profile_picture/${user.uid}.$ext");

    await ref
        .putFile(file, SettableMetadata(contentType: "image/*$ext"))
        .then((p0) {
      log('data transferred:${p0.bytesTransferred / 1000}Kb');
    });
    me.image = await ref.getDownloadURL();
    await firestore
        .collection("user")
        .doc(user.uid)
        .update({'image': me.image});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getuserInfo(
      ChatUserModel chatuser) {
    return firestore
        .collection("user")
        .where('id', isEqualTo: chatuser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isonline) async {
    firestore.collection('user').doc(user.uid).update({
      "is_online": isonline,
      "last_active": DateTime.now().millisecondsSinceEpoch.toString(),
      "push_token": me.pushToken
    });
  }

//!-------------chat screen Message functioms---------!//
  //? chats(collections)--> conversation_id(doc)-->messages(collection)-->messages(doc)

  static String getconversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getmessagedata(
      ChatUserModel user) {
    return firestore
        .collection("chats")
        .doc(getconversationID(user.id!))
        .collection("messages")
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendmessage(
      ChatUserModel chatuser, String msg, Type type) async {
    //message sending time also used as time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final MessageUserModel message = MessageUserModel(
        toId: chatuser.id,
        msg: msg,
        read: '',
        type: type,
        formId: user.uid,
        sent: time);

    final ref = firestore
        .collection("chats")
        .doc(getconversationID(chatuser.id!))
        .collection("messages");
    await ref.doc(time).set(message.toJson()).then((value) {
      sendpushnotification(chatuser, type == Type.text ? msg : "image");
      log("message send");
    });
  }

  //?to update read status of messages

  static Future<void> updateMessagestatus(MessageUserModel message) async {
    firestore
        .collection("chats")
        .doc(getconversationID(message.formId!))
        .collection("messages")
        .doc(message.sent)
        .update({
      'read': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  //?for getting last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getlastmessage(
      ChatUserModel user) {
    return firestore
        .collection("chats")
        .doc(getconversationID(user.id!))
        .collection("messages")
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendchatImage(ChatUserModel chatuser, File file) async {
    final ext = file.path.split(".").last;
    log("extraction:-$ext");
    final ref = stroage.ref().child(
        "images/${getconversationID(chatuser.id!)}/${DateTime.now().millisecondsSinceEpoch}.$ext");

    await ref
        .putFile(file, SettableMetadata(contentType: "image/*$ext"))
        .then((p0) {
      log('data transferred:${p0.bytesTransferred / 1000}Kb');
    });
    final imageurl = await ref.getDownloadURL();
    await sendmessage(chatuser, imageurl, Type.image);
  }

  static Future<void> deletemessage(MessageUserModel message) async {
    await firestore
        .collection("chats")
        .doc(getconversationID(message.toId!))
        .collection("messages")
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      stroage.refFromURL(message.msg!);
    }
  }

  static Future<void> updatemessage(
      MessageUserModel message, String upmsg) async {
    await firestore
        .collection("chats")
        .doc(getconversationID(message.toId!))
        .collection("messages")
        .doc(message.sent)
        .update({'msg': upmsg});
  }
}
