class PayModel {
  String? pName;

  PayModel({
    this.pName,
  });

  // receiving data from server
  factory PayModel.fromMap(map) {
    return PayModel(
      pName: map['pName'],
    );
  }
}
