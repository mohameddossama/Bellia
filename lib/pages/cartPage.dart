import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/checkout.dart';
import 'package:fluttercourse/util/dimensions.dart';

class CartPage extends StatefulWidget {
  final Map<String, Map<String, dynamic>> cartItems;
final Function(Map<String, int>) updateItemCount; // New callback


  // final void Function(Map<String, int>) updateCartItems; // Callback function

  const CartPage({
    Key? key,
    required this.cartItems, required this.updateItemCount,
    
    // required this.updateCartItems
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, int> itemCounts = {};
  @override
  void initState() {
    super.initState();
    itemCounts.addAll(widget.cartItems.map(
        (key, value) => MapEntry(key, int.parse(value['quantity'] ?? '0'))));
    
  }

  List<Map<String, dynamic>> getItemDetailsList() {
    List<Map<String, dynamic>> itemDetailsList = [];

    itemCounts.forEach((itemName, itemCount) {
      String itemPrice = widget.cartItems[itemName]!['price'];
      itemDetailsList.add({
        'itemName': itemName,
        'itemPrice': itemPrice,
        'itemCount': itemCount,
      });
    });

    return itemDetailsList;
  }

  void updateItem(String itemName, int quantity) {
    setState(() {
      widget.cartItems[itemName] = {
        
        'quantity': quantity.toString(),
      };

      itemCounts[itemName] = quantity;
    });
  }

  void _updateItemCount(String itemName, int newCount) {
    widget.updateItemCount({itemName: newCount});
  }

   double calculateTotalPrice() {
    double totalPrice = 0.0;
    itemCounts.forEach((itemName, quantity) {
      double itemPrice = double.parse(widget.cartItems[itemName]!['price']);
      totalPrice += itemPrice * quantity;
    });
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(
            fontSize: Dimensions.height25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
             Navigator.of(context).pop(widget.updateItemCount(itemCounts));
            },
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 243, 241, 241),
        ),
        padding: EdgeInsets.only(
            top: Dimensions.height10, bottom: Dimensions.height10),
        child: itemCounts.isEmpty 
            ? Center(
                child: Text(
                  "Cart is empty",
                  style: TextStyle(
                    fontSize: Dimensions.height25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.height20),
                      ),
                      child: ListView(
                        children: itemCounts.entries.map((entry) {
                           String itemName = entry.key;
                           String itemPrice =
                               widget.cartItems[itemName]!['price'];
                                  
                          String imagePath =
                               widget.cartItems[itemName]!['image'];
                               
                          int itemCount = entry.value;

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: Dimensions.height10,
                              vertical: Dimensions.height5,
                            ),
                            height: Dimensions.height150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: Dimensions.height100,
                                      height: Dimensions.height85,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(imagePath),
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      child: Text(
                                        "Remove",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 218, 27, 13),
                                          fontWeight: FontWeight.bold,
                                          fontSize: Dimensions.height15,
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                
                                                title: const Text(
                                                    "Are you sure you want to remove this item ?",
                                                    style: TextStyle(fontSize: 20)
                                                    ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          widget.cartItems
                                                              .remove(itemName);
                                                          itemCounts
                                                              .remove(itemName);
                                                        });
                                                      },
                                                      child:
                                                          const Text("Remove",style: TextStyle(fontSize: 15),)),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Cancel",style: TextStyle(fontSize: 15))),
                                                ],
                                              );
                                            });
                                        // setState(() {
                                        //   widget.cartItems.remove(itemName);
                                        //   itemCounts.remove(itemName);
                                        // });
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: Dimensions.height5),
                                      width: Dimensions.widht250,
                                      child: Text(
                                     itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height10),
                                    Container(
                                      width: Dimensions.widht250,
                                      child: Text(
                                        "EGP $itemPrice",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Dimensions.height15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height35),
                                    Row(
                                      children: [
                                        SizedBox(width: Dimensions.widht120),
                                        Container(
                                          width: Dimensions.widht39,
                                          height: Dimensions.height30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Colors.red,
                                          ),
                                          child: IconButton(
                                            iconSize: Dimensions.height25,
                                            color: Colors.white,
                                            padding: const EdgeInsets.only(
                                                bottom: 1, top: 4),
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              setState(() {
                                                if (itemCount > 0) {
                                                  itemCount--;
                                                  itemCounts[itemName] =
                                                      itemCount;
                                                }
                                                if (itemCount == 0) {
                                                  widget.cartItems
                                                      .remove(itemName);
                                                  itemCounts.remove(itemName);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: Dimensions.widht30),
                                        Text(
                                          itemCount.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimensions.height15,
                                          ),
                                        ),
                                        SizedBox(width: Dimensions.widht30),
                                        Container(
                                          width: Dimensions.widht39,
                                          height: Dimensions.height30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Colors.red,
                                          ),
                                          child: IconButton(
                                            iconSize: Dimensions.height25,
                                            color: Colors.white,
                                            padding: const EdgeInsets.only(
                                                bottom: 1, top: 4),
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              setState(() {
                                                itemCount++;
                                                itemCounts[itemName] =
                                                    itemCount;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Container(
                    width: Dimensions.widht350,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 218, 27, 13),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        print(getItemDetailsList());
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Checkout(
                            itemDetailsList: getItemDetailsList(),
                            subAdministrativeArea: '',
                            street: '',
                          ),
                        ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "CHECKOUT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "EGP ${calculateTotalPrice().toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      
    );
  }
}
