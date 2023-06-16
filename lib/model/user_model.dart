import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? userName;
  String? dob;
  String? email;
  String? mobile;
  DocumentReference? reference;
  String? id;

  UserModel(
      {this.userName,
        this.dob,
        this.email,
        this.mobile,
        this.id,
      });

  factory UserModel.fromJson(Map<String, dynamic> json) {

    return UserModel(
      userName: json['userName'],
      dob: json['dob'],
      email: json['email'],
      mobile: json['mobile'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'dob': dob,
    'email': email,
    'mobile': mobile,
    'id': id,
  };
  // static String encode(List<UserModel> userModelList) => json.encode(
  //   userModelList
  //       .map<Map<String, dynamic>>((userModel) => UserModel.toJson(userModel))
  //       .toList(),
  // );
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    UserModel userModel =
    UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    userModel.reference = snapshot.reference;
    return userModel;
  }
}
