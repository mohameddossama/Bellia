import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/itemInfoPage.dart';
import 'package:fluttercourse/util/belliaItems.dart';

class CustomSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the AppBar (e.g., clear query button)
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the AppBar
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
Widget buildResults(BuildContext context) {
  // Show results based on the current query
  List allItems = accessoryCategories.values.expand((items) => items).toList();
  List results = allItems.where((item) => item['description'].toLowerCase().contains(query.toLowerCase())).toList();

  return ListView.builder(
    itemCount: results.length,
    itemBuilder: (context, index) {
      Map<String, dynamic> result = results[index];
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(result['image']),
        ),
        title: Text(result['description']),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ItemInfoPage(
                itemName: result['description'],
                itemPrice: result['price'],
                imagePath: result['image'],
                quantity: 0,
                updateCounter: (itemName, quantity) {},
              ),
            ),
          );
        },
      );
    },
  );
}

@override
Widget buildSuggestions(BuildContext context) {
  // Show suggestions while the user is typing
  List allItems = accessoryCategories.values.expand((items) => items).toList();
  List suggestions = allItems.where((item) => item['description'].toLowerCase().contains(query.toLowerCase())).toList();

  return ListView.builder(
    itemCount: suggestions.length,
    itemBuilder: (context, index) {
      Map<String, dynamic> suggestion = suggestions[index];
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(suggestion['image']),
        ),
        title: Text(suggestion['description']),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ItemInfoPage(
                itemName: suggestion['description'],
                itemPrice: suggestion['price'],
                imagePath: suggestion['image'],
                quantity: 0,
                updateCounter: (itemName, quantity) {},
              ),
            ),
          );
        },
      );
    },
  );
}
}
