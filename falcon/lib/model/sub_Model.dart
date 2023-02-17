class SubModel {
  String? subName;

  SubModel({
    this.subName,
  });

  // receiving data from server
  factory SubModel.fromMap(map) {
    return SubModel(
      subName: map['subName'],
    );
  }
}
