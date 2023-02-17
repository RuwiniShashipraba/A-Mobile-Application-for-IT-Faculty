class UserModel {
  String? uid;

  String? firstName;
  String? lastName;
  String? role;
  String? indexNo;
  int? batch;
  String? email;
  String? module;
  String? pw;
  String? img;

  UserModel(
      {this.uid,
      this.firstName,
      this.lastName,
      this.role,
      this.indexNo,
      this.batch,
      this.email,
      this.module,
      this.pw,
      this.img});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      role: map['role'],
      indexNo: map['indexNo'],
      batch: map['batch'],
      email: map['email'],
      module: map['module'],
      pw: map['pw'],
      img: map['img'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'indexNo': indexNo,
      'batch': batch,
      'email': email,
      'pw': pw,
      'module': module,
      'img': img,
    };
  }
}
