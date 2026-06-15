import '../models/feed_model.dart';
import 'database_service.dart';

class FeedService {

  Future<void> insertFeed(
      FeedModel feed) async {

    final db =
        await DatabaseService().database;

    await db.insert(
      'feeds',
      feed.toMap(),
    );
  }

  Future<List<FeedModel>>
      getFeeds() async {

    final db =
        await DatabaseService().database;

    final List<Map<String, dynamic>>
    maps = await db.query('feeds');

    return List.generate(
      maps.length,
          (i) => FeedModel.fromMap(maps[i]),
    );
  }

  Future<void> deleteFeed(
      int id) async {

    final db =
        await DatabaseService().database;

    await db.delete(
      'feeds',
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<void> updateFeed(
      FeedModel feed) async {

    final db =
        await DatabaseService().database;

    await db.update(
      'feeds',
      feed.toMap(),
      where: 'id=?',
      whereArgs: [feed.id],
    );
  }
}