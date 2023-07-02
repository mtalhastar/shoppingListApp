import 'package:flutter/material.dart';
import 'package:shoppinglistapp/models/groceryitemModel.dart';

class GroceryItemDart extends StatelessWidget {
  const GroceryItemDart(this.item, {super.key});
  final GroceryItem item;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            padding: const EdgeInsets.all(12.0),
            color: item.category.color,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(item.name, style: const TextStyle(color: Colors.white)),
          const Spacer(),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(item.quantity.toString(),
                  style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}
