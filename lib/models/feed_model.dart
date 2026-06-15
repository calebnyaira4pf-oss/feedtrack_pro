class FeedModel {

  int? id;
  String name;
  int quantity;
  String supplier;
  double price;

  FeedModel({
    this.id,
    required this.name,
    required this.quantity,
    required this.supplier,
    required this.price,
  });

  Map<String, dynamic> toMap() {

    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'supplier': supplier,
      'price': price,
    };
  }

  factory FeedModel.fromMap(
      Map<String, dynamic> map) {

    return FeedModel(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      supplier: map['supplier'],
      price: map['price'],
    );
  }
}