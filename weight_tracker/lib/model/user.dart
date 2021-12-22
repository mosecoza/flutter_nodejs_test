import 'dart:ffi';

class User {
  String email ="";
  String name ="";
  String token ="";
  DateTime createAt = new DateTime(100);
  String uid = "";

  User(this.email, this.createAt, this.uid, this.token, this.name);

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    createAt = json['createAt'];
    uid = json['uid'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['name'] = this.name;
    data['uid'] = this.uid;
    data['createAt'] = this.createAt;
    data['email'] = this.email;
    return data;
  }
}
