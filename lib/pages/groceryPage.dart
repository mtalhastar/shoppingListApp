import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppinglistapp/data/categories.dart';
import 'package:shoppinglistapp/models/categorymodel.dart';
import 'package:shoppinglistapp/widgets/groceryItem.dart';
import 'package:shoppinglistapp/pages/formPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/provider/groceryitemsProvider.dart';
import 'package:http/http.dart' as http;
import 'package:shoppinglistapp/models/groceryitemModel.dart';

class GroceryPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<GroceryPage> createState() {
    // TODO: implement createState
    return _GroceryPage();
  }
}

class _GroceryPage extends ConsumerState<GroceryPage> {
  List<GroceryItem> groceryitems = [];
  // TODO: implement initState

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadItems();
  }

  void loadItems() async {
    final url = Uri.https(
        'starbase-70ac2-default-rtdb.firebaseio.com', 'shoppinglist-app.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    if (response.statusCode == 200) {
      print('GOOD');
    }
    final List<GroceryItem> groceryitemslist = [];

    for (final item in listData.entries) {
      final categoryitem = categories.entries.firstWhere((category) {
        return (item.value['Category'] == category.value.title);
      }).value;
      groceryitemslist.add(GroceryItem(
          id: item.key,
          name: item.value['Name'],
          quantity: int.parse(item.value['Quantity']),
          category: categoryitem));
    }
    setState(() {
      groceryitems = groceryitemslist;
      print(groceryitems);
    });
  }

  void removeItems(GroceryItem groceryItem) async {
    final url = Uri.https('starbase-70ac2-default-rtdb.firebaseio.com',
        'shoppinglist-app/${groceryItem.id}.json');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      setState(() {
        groceryitems.remove(groceryItem);
      });
    }
  }

  void addItem() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SafeArea(
              child:
                  FormPage()); // Replace YourNewScreen() with the widget/screen you want to navigate to
        },
      ),
    );
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addItem,
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => Dismissible(
            onDismissed: (direction) => removeItems(groceryitems[index]),
            key: ValueKey(groceryitems[index].id),
            child: GroceryItemDart(groceryitems[index])),
        itemCount: groceryitems.length,
      ),
    );
  }
}
