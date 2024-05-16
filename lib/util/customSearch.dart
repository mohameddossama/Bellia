import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/itemInfoPage.dart';
import 'package:fluttercourse/util/belliaItems.dart';

class CustomSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
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
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List allItems =
        accessoryCategories.values.expand((items) => items).toList();
    List results = allItems
        .where((item) =>
            item['description'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text("No results found for \"$query\".", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> result = results[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2, color: const Color.fromARGB(255, 3, 0, 0))),
              padding: EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundImage: AssetImage(result['image']),
              ),
            ),
            title: Text(
              result['description'],
              overflow: TextOverflow.ellipsis,
            ),
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
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List allItems =
        accessoryCategories.values.expand((items) => items).toList();
    List suggestions = allItems
        .where((item) =>
            item['description'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> suggestion = suggestions[index];
        return Card(
          margin: EdgeInsets.only(bottom: 10, top: 5),
          color: Color.fromARGB(255, 252, 249, 249),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2, color: const Color.fromARGB(255, 3, 0, 0))),
              padding: EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundImage: AssetImage(suggestion['image']),
              ),
            ),
            title: Text(
                overflow: TextOverflow.ellipsis, suggestion['description']),
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
          ),
        );
      },
    );
  }
}
