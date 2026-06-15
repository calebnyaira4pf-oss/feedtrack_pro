class OrderModel {

  int? id;
  String feedName;
  int quantity;
  String supplier;
  double total;
  String orderDate;
  String status;

  OrderModel({
    this.id,
    required this.feedName,
    required this.quantity,
    required this.supplier,
    required this.total,
    required this.orderDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'feedName': feedName,
      'quantity': quantity,
      'supplier': supplier,
      'total': total,
      'orderDate': orderDate,
      'status': status,
    };
  }

  factory OrderModel.fromMap(
      Map<String, dynamic> map) {

    return OrderModel(
      id: map['id'],
      feedName: map['feedName'],
      quantity: map['quantity'],
      supplier: map['supplier'],
      total: map['total'],
      orderDate: map['orderDate'],
      status: map['status'],
    );
  }
}