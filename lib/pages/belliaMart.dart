import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/cartPage.dart';
import 'package:fluttercourse/pages/itemInfoPage.dart';
import 'package:fluttercourse/util/belliaItems.dart';
import 'package:fluttercourse/util/customSearch.dart';
import 'package:fluttercourse/util/dimensions.dart';

class BelliaMart extends StatefulWidget {
  
  const BelliaMart({Key? key}) : super(key: key);

  @override
  State<BelliaMart> createState() => _BelliaMartState();
}

class _BelliaMartState extends State<BelliaMart> {
  final ScrollController _accessorieTypeController = ScrollController();
  final ScrollController _accessorieItemsController = ScrollController();
  final List<String> _accessorieTypes = [
    'Interior Accessories',
    'Car Care',
    'Exterior Accessories',
    'Oils and Fluids',
    // 'Tools and Equipments'
  ];

  final Map<String, int> _itemsPerType = {
    'Exterior Accessories': 8,
    'Interior Accessories': 10,
    'Car Care': 8,
    'Oils and Fluids': 8,
    // 'Tools and Equipments': 18
  };

  final Map<String, bool> _isSelected = {};
  final Map<String, int> _quantity = {};

  double calculateScrollOffset(int targetItemIndex) {
    const double itemHeight = 165.0;
    const int crossAxisCount = 2;
    const double crossAxisSpacing = 29.0;

    final int targetGridIndex = targetItemIndex ~/ crossAxisCount;
    final double totalHeightAboveTarget = itemHeight * targetGridIndex;

    final int itemsInLastRow = targetItemIndex % crossAxisCount;
    final double totalHeightOfVisibleItems =
        (itemsInLastRow * (itemHeight + crossAxisSpacing)) +
            (itemsInLastRow * (itemHeight + crossAxisSpacing));

    final double scrollOffset =
        totalHeightAboveTarget + totalHeightOfVisibleItems;

    return scrollOffset;
  }

  String getGridContent(String accessorieType, int index) {
    List<Map<String, dynamic>> categories =
        accessoryCategories[accessorieType] ?? [];

    if (index < categories.length) {
      String image = categories[index]["image"];
      String description = categories[index]["description"];
      String price = categories[index]["price"];
      return "$image,$description,$price";
    } else {
      return "assets/images/electonics1.png";
    }
  }

  void toggleEdit(String itemName) {
    setState(() {
      _isSelected[itemName] = _isSelected[itemName] ?? false;
      _isSelected[itemName] = !_isSelected[itemName]!;
    });
  }
void _updateItemCount(Map<String, int> updatedItems) {
  setState(() {
    if (updatedItems.isEmpty) {
      // If cart is empty, clear quantity and set all items to not selected
      _quantity.clear();
      accessoryCategories.forEach((accessorieType, items) {
        items.forEach((item) {
          _isSelected[item['description']] = false;
        });
      });
    } else {
      // Clear all items to not selected
      _isSelected.forEach((key, value) {
        _isSelected[key] = false;
      });

      // Update quantity for each item and set selected state accordingly
      updatedItems.forEach((itemName, newCount) {
        _quantity[itemName] = newCount;
        if (_quantity[itemName]! > 0) {
          _isSelected[itemName] = true;
        }
      });
    }
  });
}




  void navigateToCartPage() {
    Map<String, Map<String, String>> selectedItemsWithDetails = {};
    _isSelected.forEach((itemName, isSelected) {
      if (isSelected) {
        accessoryCategories.forEach((accessorieType, items) {
          items.forEach((item) {
            if (item['description'] == itemName) {
              Map<String, String> itemDetails = {
                'price': item['price'],
                'image': item['image'],
                'quantity': _quantity[itemName].toString(),
              };
              selectedItemsWithDetails[itemName] = itemDetails;
            }
          });
        });
      }
    });

    print(selectedItemsWithDetails);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartPage(
                cartItems: selectedItemsWithDetails, updateItemCount: _updateItemCount,

              )),
    );
  }

 void navigateToItemInfoPage(
    String itemName, String itemPrice, String imagePath) {
  if (_isSelected[itemName] == false) {
    _quantity[itemName] = 0;
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ItemInfoPage(
        itemName: itemName,
        itemPrice: itemPrice,
        imagePath: imagePath,
        quantity: _quantity[itemName] ?? 0,
        updateCounter: (itemName, quantity) {
          setState(() {
            _quantity[itemName] = quantity;
            if (quantity > 0) {
              _isSelected[itemName] = true;
            } else {
              _isSelected[itemName] = false;
            }
          });
        },
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bellia Mart',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: CustomSearch());
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  ),
                ),
                IconButton(
              onPressed: () {
                navigateToCartPage();
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 27,
              ),
            )
              ],
            ),
            
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 243, 241, 241)),
        child: Column(
          children: [
            // Container(
            //   margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            //   child: TextFormField(
            //     onTap: () {
            //       showSearch(context: context, delegate: CustomSearch());
            //     },
            //     decoration: const InputDecoration(
            //       prefixIcon: Icon(Icons.search_sharp),
            //       hintText: "Search...",
            //     ),
            //   ),
            // ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _accessorieTypeController,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 235, 226, 226),
                      blurRadius: 4.0,
                      offset: Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 5.0,
                      offset: Offset(-5, 0),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 5.0,
                      offset: Offset(5, 0),
                    )
                  ],
                ),
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  children: _accessorieTypes.map((foodType) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 224, 58, 58),
                          ),
                        ),
                        onPressed: () {
                          final index = _accessorieTypes.indexOf(foodType);
                          final offset = calculateScrollOffset(
                              _itemsPerType[foodType]! * index * 2);
                          _accessorieItemsController.animateTo(
                            offset - 5,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          foodType,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 241, 241),
                ),
                child: ListView(
                  controller: _accessorieItemsController,
                  children: _accessorieTypes.map((accessorieType) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            accessorieType,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: Dimensions.aspectRatio,
                              crossAxisSpacing: Dimensions.widht20,
                              mainAxisSpacing: Dimensions.height15,
                            ),
                            itemCount: _itemsPerType[accessorieType],
                            itemBuilder: (context, index) {
                              String combinedContent =
                                  getGridContent(accessorieType, index);

                              List<String> contentParts =
                                  combinedContent.split(",");

                              print(
                                  'Content parts length: ${contentParts.length}');

                              if (contentParts.length >= 3) {
                                String imagePath = contentParts[0];
                                String itemName = contentParts[1];
                                String itemPrice = contentParts[2];

                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromARGB(
                                        255, 255, 252, 252),
                                  ),
                                  height: Dimensions.gridViewContainerImage,
                                  child: Column(
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          navigateToItemInfoPage(
                                              itemName, itemPrice, imagePath);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: Dimensions.height10),
                                          height: Dimensions
                                              .gridViewContainerImageHeight,
                                          width: Dimensions
                                              .gridViewContainerImageWidht,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(imagePath),
                                            ),
                                            color: const Color.fromARGB(
                                                255, 255, 252, 252),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions.widht10),
                                        margin: EdgeInsets.only(
                                            left: Dimensions.widht20,
                                            top: Dimensions.height15),
                                        child: Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          itemName,
                                          style: const TextStyle(),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: Dimensions.widht5,
                                            top: Dimensions.height10),
                                        child: Text(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          "EGP $itemPrice",
                                          style: TextStyle(
                                            fontSize: Dimensions.height20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:  EdgeInsets.symmetric(
                                            horizontal: Dimensions.widht15, vertical: 0),
                                        margin: EdgeInsets.only(
                                            top: Dimensions.height5),
                                        height: Dimensions.height35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 224, 58, 58),
                                        ),
                                        child: _isSelected[itemName] == true && _quantity[itemName] != 0
                                            ? Container(
                                                width:Dimensions.height150,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin:
                                                           EdgeInsets.only(
                                                              right:5 ),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            if (_quantity[
                                                                    itemName]! >
                                                                1) {
                                                              _quantity[
                                                                      itemName] =
                                                                  (_quantity[itemName] ??
                                                                          1) -
                                                                      1;
                                                            } else {
                                                              _isSelected[
                                                                      itemName] =
                                                                  false;
                                                            }
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.remove),
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:  EdgeInsets
                                                          .symmetric(
                                                          horizontal: Dimensions.height10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255), // Change color as desired
                                                      ),
                                                      child: Text(
                                                        _quantity[itemName]
                                                            .toString(),
                                                        style:  TextStyle(
                                                          color: Colors
                                                              .black, // Change color as desired
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: Dimensions.height17,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 1),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _quantity[
                                                                    itemName] =
                                                                (_quantity[itemName] ??
                                                                        1) +
                                                                    1;
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.add),
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : 
                                            MaterialButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _quantity[itemName] = 1;
                                                    toggleEdit(itemName);
                                                  });
                                                },
                                                child: const Text(
                                                  "ADD TO CART",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
