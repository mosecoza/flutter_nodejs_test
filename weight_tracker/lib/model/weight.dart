import 'dart:ffi';

class Weight {
  String id ="";
  double weight = 0.0;
  DateTime createdAt = new DateTime(100);
  String uid = "";

  Weight(this.id, this.weight, this.createdAt, this.uid);

  Weight.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weight = json['weight'];
    createdAt = json['createdAt'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['createdAt'] = this.createdAt;
    data['weight'] = this.weight;
    data['id'] = this.id;
    return data;
  }
}
