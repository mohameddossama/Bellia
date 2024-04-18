import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/belliaMart.dart';
//import 'package:fluttercourse/pages/cartPage.dart';
import 'package:fluttercourse/util/dimensions.dart';

class ItemInfoPage extends StatefulWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final int quantity;
  final Function(String, int) updateCounter; 

  ItemInfoPage({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.quantity,
    required this.updateCounter,
  }) : super(key: key);

  @override
  State<ItemInfoPage> createState() => _ItemInfoPageState();
}

class _ItemInfoPageState extends State<ItemInfoPage> {
  int i = 0;

  @override
  void initState() {
    super.initState();
    i = widget.quantity;
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double totalPrice = double.parse(widget.itemPrice) * i;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Item Details',
          style: TextStyle(
              fontSize: Dimensions.height25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 243, 241, 241)),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: Dimensions.height300,
                width: Dimensions.widht380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.height20),
                  color: Colors.white,
                  image: DecorationImage(image: AssetImage(widget.imagePath)),
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
                height: Dimensions.height200,
                width: Dimensions.widht400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.itemName,
                      style: TextStyle(
                          fontSize: Dimensions.height20,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "EGP ${widget.itemPrice}",
                      style: TextStyle(
                          fontSize: Dimensions.height25,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end,children: [Text("** Prices include tax ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),)],)
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: Dimensions.height45,
                width: Dimensions.widht400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.height10),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(width: Dimensions.widht100),
                    Container(
                      width: Dimensions.widht39,
                      height: Dimensions.height30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.red),
                      child: IconButton(
                        iconSize: Dimensions.height25,
                        color: Colors.white,
                        padding: const EdgeInsets.only(bottom: 1, top: 4),
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (i > 0) {
                              i--;
                              widget.updateCounter(widget.itemName, i);
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(width: Dimensions.widht400 / 10),
                    Text(
                      i.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.height25),
                    ),
                    SizedBox(width: Dimensions.widht400 / 10),
                    Container(
                      width: Dimensions.widht39,
                      height: Dimensions.height30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.red),
                      child: IconButton(
                        iconSize: Dimensions.height25,
                        color: Colors.white,
                        padding: const EdgeInsets.only(bottom: 1, top: 4),
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            i++;
                            widget.updateCounter(
                                widget.itemName, i); 
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height45),
              Container(
                width: Dimensions.widht350,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 218, 27, 13),
                    borderRadius: BorderRadius.circular(5)),
                child: MaterialButton(
                    onPressed: () {
                      print(widget.imagePath);
                      widget.updateCounter(widget.itemName, i);
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  BelliaMart( )
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                          duration: const Duration(seconds: 2),
                          content: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                "Item added to cart successfully",
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 250, 249, 249),
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.height20),
                              ),
                              Icon(Icons.check_circle_outline_rounded,color: Colors.green,size: Dimensions.height25,)
                            ],
                          )));
                    },
                    child: i == 0
                        ? Text(
                            "ADD TO CART",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Dimensions.height20,
                                fontWeight: FontWeight.bold),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "ADD TO CART",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimensions.height20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: Dimensions.widht10),
                              Text(
                                "EGP ${totalPrice.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimensions.height20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
