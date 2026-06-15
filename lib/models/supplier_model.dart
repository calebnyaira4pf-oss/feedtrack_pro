class SupplierModel {

  int? id;
  String name;
  String phone;
  String email;

  SupplierModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toMap() {

    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  factory SupplierModel.fromMap(
      Map<String, dynamic> map) {

    return SupplierModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}