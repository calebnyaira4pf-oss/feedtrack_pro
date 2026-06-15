import 'package:flutter/material.dart';

import '../models/feed_model.dart';
import '../services/feed_service.dart';

class InventoryScreen extends StatefulWidget {

  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() =>
      _InventoryScreenState();
}

class _InventoryScreenState
    extends State<InventoryScreen> {

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List<FeedModel> allFeeds = [];
  List<FeedModel> filteredFeeds = [];
  bool isLoading = true;

  final FeedService service =
  FeedService();

  @override
  void initState() {
    super.initState();
    loadFeeds();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadFeeds() async {
    setState(() {
      isLoading = true;
    });

    allFeeds = await service.getFeeds();
    _applySearchFilter(searchQuery);

    setState(() {
      isLoading = false;
    });
  }

  void _applySearchFilter(String value) {
    searchQuery = value;

    if (value.isEmpty) {
      filteredFeeds = List<FeedModel>.from(allFeeds);
      return;
    }

    filteredFeeds = allFeeds.where((feed) {
      return feed.name.toLowerCase().contains(value.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Inventory",
        ),
      ),

      body: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search feed...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          _applySearchFilter('');
                        });
                      },
                    ),
            ),
            onChanged: (value) {
              setState(() {
                _applySearchFilter(value);
              });
            },
          ),

          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (filteredFeeds.isEmpty
                    ? const Center(
                        child: Text(
                          "No Feed Records Found",
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredFeeds.length,

                        itemBuilder: (context, index) {

                          final feed = filteredFeeds[index];

                          return Card(
                            child: ListTile(

                              title: Text(feed.name),

                              subtitle: Text(
                                "${feed.supplier}\nKES ${feed.price}",
                              ),

                              trailing: Row(
                                mainAxisSize:
                                    MainAxisSize.min,

                                children: [

                                  Text(
                                    "${feed.quantity}kg",
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                    ),

                                    onPressed: () {
                                      editFeed(feed);
                                    },
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                    ),

                                    onPressed: () async {

                                      await service.deleteFeed(
                                        feed.id!,
                                      );

                                      loadFeeds();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
          ),
        ],
      ),

      floatingActionButton:
      FloatingActionButton(

        onPressed: addFeed,

        child: const Icon(Icons.add),
      ),
    );
  }

  void addFeed() {

    final name =
    TextEditingController();

    final quantity =
    TextEditingController();

    final supplier =
    TextEditingController();

    final price =
    TextEditingController();

    showDialog(
      context: context,

      builder: (_) {

        return AlertDialog(

          title:
          const Text("Add Feed"),

          content:
          SingleChildScrollView(

            child: Column(
              children: [

                TextField(
                  controller: name,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Feed Name",
                  ),
                ),

                TextField(
                  controller:
                  quantity,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Quantity",
                  ),
                ),

                TextField(
                  controller:
                  supplier,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Supplier",
                  ),
                ),

                TextField(
                  controller: price,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Price",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            ElevatedButton(
              onPressed: () async {

                // Basic validation to prevent crashes
                if (name.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter feed name')),
                  );
                  return;
                }

                final q = int.tryParse(quantity.text);
                if (q == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter valid quantity')),
                  );
                  return;
                }

                final p = double.tryParse(price.text);
                if (p == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter valid price')),
                  );
                  return;
                }

                await service.insertFeed(
                  FeedModel(
                    name: name.text,
                    quantity: q,
                    supplier: supplier.text,
                    price: p,
                  ),
                );

                if (!mounted) return;

                Navigator.pop(context);

                loadFeeds();
              },

              child:
              const Text("Save"),
            )
          ],
        );
      },
    );
  }

  void editFeed(FeedModel feed) {

    final name =
    TextEditingController(
        text: feed.name);

    final quantity =
    TextEditingController(
        text:
        feed.quantity.toString());

    final supplier =
    TextEditingController(
        text: feed.supplier);

    final price =
    TextEditingController(
        text:
        feed.price.toString());

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,

      builder: (_) {

        return AlertDialog(

          title:
          const Text("Edit Feed"),

          content:
          SingleChildScrollView(

            child: Form(
              key: formKey,
              child: Column(
                children: [

                  TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: "Feed Name",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter feed name';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: quantity,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter quantity';
                      }
                      final parsed = int.tryParse(value);
                      if (parsed == null || parsed < 0) {
                        return 'Enter a valid quantity';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: supplier,
                    decoration: const InputDecoration(
                      labelText: "Supplier",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter supplier';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter price';
                      }
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed < 0) {
                        return 'Enter a valid price';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          actions: [

            ElevatedButton(

              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                await service.updateFeed(
                  FeedModel(
                    id: feed.id,
                    name: name.text,
                    quantity:
                    int.parse(
                      quantity.text,
                    ),
                    supplier:
                    supplier.text,
                    price:
                    double.parse(
                      price.text,
                    ),
                  ),
                );

                if (!mounted) return;

                Navigator.pop(context);

                loadFeeds();
              },

              child:
              const Text("Update"),
            )
          ],
        );
      },
    );
  }
}