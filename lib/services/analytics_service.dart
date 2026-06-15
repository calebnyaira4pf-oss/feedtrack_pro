import '../services/feed_service.dart';
import '../services/order_service.dart';

class AnalyticsService {

  final FeedService feedService =
      FeedService();

  final OrderService orderService =
      OrderService();

  Future<double> getInventoryValue() async {

    final feeds =
        await feedService.getFeeds();

    double total = 0;

    for (var feed in feeds) {
      total +=
          feed.price * feed.quantity;
    }

    return total;
  }

  Future<int> getFeedCount() async {

    final feeds =
        await feedService.getFeeds();

    return feeds.length;
  }

  Future<int> getPendingOrders() async {

    final orders =
        await orderService.getOrders();

    return orders
        .where(
          (order) =>
              order.status ==
              "Pending",
        )
        .length;
  }

  Future<double> getMonthlySpend()
      async {

    final orders =
        await orderService.getOrders();

    double total = 0;

    for (var order in orders) {
      total += order.total;
    }

    return total;
  }
}