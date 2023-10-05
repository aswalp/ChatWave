// To parse this JSON data, do
//
//     final messageUserModel = messageUserModelFromJson(jsonString);

import 'dart:convert';

MessageUserModel messageUserModelFromJson(String str) =>
    MessageUserModel.fromJson(json.decode(str));

String messageUserModelToJson(MessageUserModel data) =>
    json.encode(data.toJson());

class MessageUserModel {
  String? formId;
  String? msg;
  String? toId;
  String? read;
  Type? type;
  String? sent;

  MessageUserModel({
    this.formId,
    this.msg,
    this.toId,
    this.read,
    this.type,
    this.sent,
  });

  factory MessageUserModel.fromJson(Map<String, dynamic> json) =>
      MessageUserModel(
        formId: json["formId"].toString(),
        msg: json["msg"].toString(),
        toId: json["toId"].toString(),
        read: json["read"].toString(),
        type:
            json["type"].toString() == Type.image.name ? Type.image : Type.text,
        sent: json["sent"].toString(),
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data["formId"] = formId;
    data["msg"] = msg;
    data["toId"] = toId;
    data["read"] = read;
    data["type"] = type!.name;
    data["sent"] = sent;
    return data;
  }
}

enum Type { text, image }
