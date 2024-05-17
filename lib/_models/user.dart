
import '../products/productsCtr.dart';

class ScUser {


  //personal
  String id;
  String email;
  String name ;
  String pwd;
  String phone;
  String workSpace;
  String role;

  bool haveAccess;
  bool isAdmin;
  bool verified;

  //GeoPoint cords;


  //time
  String joinTime;






  ScUser({
    this.id = '',
    this.email = '',
    this.pwd = '',
    this.name = '',
    this.phone = '',
    this.haveAccess = false,
    this.isAdmin = false,
    this.joinTime = '',
    this.workSpace = '',

    this.verified = false,

    this.role = '',

  });



  // Convert ScUser object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'pwd': pwd,
      'phone': phone,
      'haveAccess': haveAccess,
      'isAdmin': isAdmin,
      'verified': verified,
      'joinTime': joinTime,
      'workSpace': workSpace,
      'role': role,
      'name': name,
    };
  }

  // Create ScUser object from JSON
  factory ScUser.fromJson(Map<String, dynamic> json) {
    return ScUser(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      pwd: json['pwd'] ?? '',
      phone: json['phone'] ?? '',
      haveAccess: json['haveAccess'] ?? false,
      isAdmin: json['isAdmin'] ?? false,
      verified: json['verified'] ?? false,
      joinTime: json['joinTime'] ?? '',

        role: json['role'] ?? '',
      workSpace: json['workSpace'] ?? workSpaces[0],
    );
  }
}
