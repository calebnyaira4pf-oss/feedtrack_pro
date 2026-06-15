import '../models/supplier_model.dart';
import 'database_service.dart';

class SupplierService {

  Future<void> insertSupplier(
      SupplierModel supplier) async {

    final db =
    await DatabaseService().database;

    await db.insert(
      'suppliers',
      supplier.toMap(),
    );
  }

  Future<List<SupplierModel>>
      getSuppliers() async {

    final db =
    await DatabaseService().database;

    final maps =
    await db.query('suppliers');

    return List.generate(
      maps.length,
          (i) =>
          SupplierModel.fromMap(
            maps[i],
          ),
    );
  }
}