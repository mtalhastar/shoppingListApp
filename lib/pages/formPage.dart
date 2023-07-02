import 'package:flutter/material.dart';
import 'package:shoppinglistapp/data/categories.dart';
import 'package:shoppinglistapp/models/categorymodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/models/groceryitemModel.dart';
import 'package:shoppinglistapp/provider/groceryitemsProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<FormPage> createState() {
    // TODO: imp;lement createState
    return _FormPage();
  }
}

class _FormPage extends ConsumerState<FormPage> {
  // Create a GlobalKey for the form
  final _formKey = GlobalKey<FormState>();

  // Define variables to store form field values
  String _name = '';
  String _price = '';
  var category = categories[Categories.carbs]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey, // Assign the GlobalKey to the form
        child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return 'Must be between 1 and 50';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Price'),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50 ||
                          int.tryParse(value) == null ||
                          int.tryParse(value)! < 0) {
                        return 'Must be between 1 and 50';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _price = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(category.value.title)
                                ],
                              ))
                      ],
                      onChanged: (value) {
                        setState(() {
                          category = value!;
                        });
                      }),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.reset();
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _submitForm();
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    final url = Uri.https(
        'starbase-70ac2-default-rtdb.firebaseio.com', 'shoppinglist-app.json');
    await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'Name': _name,
          'Quantity': _price.toString(),
          'Category': category.title
        }));
    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();
    // Navigator.of(context).pop(GroceryItem(
    //     id: DateTime.now().toString(),
    //     name: _name,
    //     quantity: int.parse(_price),
    //     category: category));
  }
}
