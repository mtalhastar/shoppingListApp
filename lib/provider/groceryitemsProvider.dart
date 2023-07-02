import 'package:shoppinglistapp/data/dummy_items.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/models/groceryitemModel.dart';

class GroceryItemsProvider extends StateNotifier<List<GroceryItem>> {
  GroceryItemsProvider() : super(groceryItems);

  void addGroceryItem(GroceryItem item) {
    state = [...state, item];
  }

  void removeGroceryItem(GroceryItem item) {
    state = state.where((i) => i != item).toList();
  }

  List<GroceryItem> getlist() {
    return state;
  }
}

final groceryItemsProvider = Provider<GroceryItemsProvider>((ref) {
  return GroceryItemsProvider();
});
