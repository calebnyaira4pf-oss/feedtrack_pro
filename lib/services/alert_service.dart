import '../models/feed_model.dart';
import 'feed_service.dart';

class AlertService {

  Future<List<FeedModel>>
      getLowStockFeeds() async {

    final feeds =
        await FeedService()
            .getFeeds();

    return feeds
        .where(
          (feed) =>
              feed.quantity < 20,
        )
        .toList();
  }
}