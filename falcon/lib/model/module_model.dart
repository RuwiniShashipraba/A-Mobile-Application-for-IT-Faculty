class ModuleModel {
  String? mId;
  String? mIndex;
  String? mName;

  ModuleModel({
    this.mId,
    this.mIndex,
    this.mName,
  });

  // receiving data from server
  factory ModuleModel.fromMap(map) {
    return ModuleModel(
      mId: map['mId'],
      mIndex: map['mIndex'],
      mName: map['mName'],
    );
  }

  // // sending data to our server
  // Map<String, dynamic> toMap() {
  //   return {
  //     'm1': m1,
  //     'm2': m2,
  //     'm3': m3,
  //     'm4': m4,
  //     'm5': m5,
  //     //'m6': m6,
  //   };
  // }
}
