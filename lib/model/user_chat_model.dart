// To parse this JSON data, do
//
//     final chatUserModel = chatUserModelFromJson(jsonString);

import 'dart:convert';

ChatUserModel chatUserModelFromJson(String str) =>
    ChatUserModel.fromJson(json.decode(str));

String chatUserModelToJson(ChatUserModel data) => json.encode(data.toJson());

class ChatUserModel {
  String? image;
  String? about;
  String? name;
  String? createdAt;
  String? id;
  bool? isOnline;
  String? lastActive;
  String? pushToken;
  String? email;

  ChatUserModel({
    this.image,
    this.about,
    this.name,
    this.createdAt,
    this.id,
    this.isOnline,
    this.lastActive,
    this.pushToken,
    this.email,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => ChatUserModel(
        image: json["image"],
        about: json["about"],
        name: json["name"],
        createdAt: json["created_at"],
        id: json["id"],
        isOnline: json["is_online"],
        lastActive: json["last_active"],
        pushToken: json["push_token"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "about": about,
        "name": name,
        "created_at": createdAt,
        "id": id,
        "is_online": isOnline,
        "last_active": lastActive,
        "push_token": pushToken,
        "email": email,
      };
}
