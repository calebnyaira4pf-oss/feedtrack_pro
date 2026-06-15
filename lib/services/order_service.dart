import '../models/order_model.dart';
import 'database_service.dart';

class OrderService {

  Future<void> insertOrder(
      OrderModel order) async {

    final db =
    await DatabaseService().database;

    await db.insert(
      'orders',
      order.toMap(),
    );
  }

  Future<List<OrderModel>>
      getOrders() async {

    final db =
    await DatabaseService().database;

    final maps =
    await db.query('orders');

    return List.generate(
      maps.length,
          (i) => OrderModel.fromMap(
        maps[i],
      ),
    );
  }

  Future<void> updateStatus(
      int id,
      String status) async {

    final db =
    await DatabaseService().database;

    await db.update(
      'orders',
      {'status': status},
      where: 'id=?',
      whereArgs: [id],
    );
  }
}