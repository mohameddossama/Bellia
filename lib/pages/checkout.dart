import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/widgets.dart';
import 'package:fluttercourse/pages/locationPicker.dart';
import 'package:fluttercourse/pages/orders.dart';
import 'package:fluttercourse/paymob/paymob_manager.dart';
import 'package:fluttercourse/util/dimensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Checkout extends StatefulWidget {
  final String subAdministrativeArea;
  final String street;
  List<Map<String, dynamic>> itemDetailsList;
  Checkout({
    super.key,
    required this.subAdministrativeArea,
    required this.street,
    required this.itemDetailsList,
  });

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final customerFormKey = GlobalKey<FormState>();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final phoneController = TextEditingController();
  final statusController = TextEditingController(text: "Waiting confirmation");
  final TextEditingController currentLocation = TextEditingController();
  // final addressController =TextEditingController(text: "Alexandria, 45 Street");
  final landmarkController = TextEditingController();
  Color getLocationButtonColor = Colors.grey;
  late SharedPreferences pref;

  // @override
  // void dispose() {
  //   fNameController.dispose();
  //   lNameController.dispose();
  //   phoneController.dispose();
  //   // addressController.dispose();
  //   landmarkController.dispose();
  //   super.dispose();
  // }

  Future<void> fetchUserData() async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        throw Exception("No user logged in");
      }
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      if (fNameController.text.isEmpty) {
        fNameController.text = userData['first_name'] ?? '';
      }
      if (lNameController.text.isEmpty) {
        lNameController.text = userData['last_name'] ?? '';
      }
      if (phoneController.text.isEmpty) {
        phoneController.text = userData['phone_number'] ?? '';
      }
      setState(() {});
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  CollectionReference belliaMart =
      FirebaseFirestore.instance.collection('Bellia Mart');
  CollectionReference orders = FirebaseFirestore.instance.collection("orders");

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    getCache();
    cacheCartItems(widget.itemDetailsList);
    loadCartItems();
    currentLocation.text = '${widget.subAdministrativeArea} ${widget.street}';
  }

  Future<void> addService() async {
    try {
      setState(() {
        isLoading = true;
      });

      String _addLeadingZero(int number) {
        return number < 10 ? '0$number' : '$number';
      }

      String getCurrentDateTimeString() {
        DateTime now = DateTime.now();

        String formattedDateTime =
            '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)} at '
            '${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)}';

        return formattedDateTime;
      }

      String formattedDateTime = getCurrentDateTimeString();
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail == null) {
        throw Exception("User email is null");
      }

      // DocumentReference userDocRef = belliaMart
      //     .doc("$userEmail - $formattedDateTime - Bellia Mart");
int totalPrice = 0; // Initialize total price as an integer
for (var item in widget.itemDetailsList) {
  double itemPrice = 0.0;
  if (item['itemPrice'] is String) {
    itemPrice = double.tryParse(item['itemPrice']) ?? 0.0;
  } else if (item['itemPrice'] is double) {
    itemPrice = item['itemPrice'];
  } else if (item['itemPrice'] is int) {
    itemPrice = (item['itemPrice'] as int).toDouble(); // Convert integer price to double
  }

  int itemCount = 0;
  if (item['itemCount'] is String) {
    itemCount = int.tryParse(item['itemCount']) ?? 0;
  } else if (item['itemCount'] is int) {
    itemCount = item['itemCount'];
  }

  totalPrice += (itemPrice * itemCount).toInt(); // Convert the product to an integer before adding
}

      DocumentReference userDocRef =
          belliaMart.doc("$userEmail - $formattedDateTime - Bellia Mart");
      await userDocRef.set({
        "User first name": fNameController.text,
        "User last name": lNameController.text,
        "Phone number": phoneController.text,
        "Location": currentLocation.text,
        "Land mark": landmarkController.text,
        "Payment Method": payment,
        "Status": statusController.text,
        'Date and Time': formattedDateTime,
        'Service': 'Bellia Mart',
        'Confirmed Status': 'Processing',
        'Estimated time of arrival': '',
        'Total Service cost': '$totalPrice',
      });

      DocumentReference orderDocRef =
          orders.doc("$userEmail - $formattedDateTime - Bellia Mart");
      await orderDocRef.set({
        "User first name": fNameController.text,
        "User last name": lNameController.text,
        "Phone number": phoneController.text,
        "Location": currentLocation.text,
        "Land mark": landmarkController.text,
        "Payment Method": payment,
        "Status": statusController.text,
        'Date and Time': formattedDateTime,
        'Service': 'Bellia Mart',
        'Confirmed Status': 'Processing',
        'Estimated time of arrival': '',
        'Total Service cost': '$totalPrice',
      });

      for (var item in widget.itemDetailsList) {
        await userDocRef.collection('cartItems').doc(item["itemName"]).set({
          'item': item['itemName'],
          'Price': item['itemPrice'],
          'AMOUNT': item['itemCount'],
        });
        await orderDocRef.collection('cartItems').doc(item["itemName"]).set({
          'item': item['itemName'],
          'Price': item['itemPrice'],
          'AMOUNT': item['itemCount'],
        });
      }

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => orderPage()),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error adding service: $e");
    }
  }

  void saveItemDetailsList(List<Map<String, dynamic>> itemDetailsList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String itemDetailsListJson = jsonEncode(itemDetailsList);
    prefs.setString('itemDetailsList', itemDetailsListJson);
  }

  Future<List<Map<String, dynamic>>> getItemDetailsList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? itemDetailsListJson = prefs.getString('itemDetailsList');
    if (itemDetailsListJson != null) {
      final List<dynamic> decodedList = jsonDecode(itemDetailsListJson);
      final List<Map<String, dynamic>> itemDetailsList =
          List<Map<String, dynamic>>.from(decodedList);
      return itemDetailsList;
    }
    return [];
  }

  Future<void> cacheCartItems(
      List<Map<String, dynamic>> itemDetailsList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String itemDetailsListJson = jsonEncode(itemDetailsList);
    await prefs.setString('cartItems', itemDetailsListJson);
  }

  Future<void> loadCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? itemDetailsListJson = prefs.getString('cartItems');
    if (itemDetailsListJson != null) {
      final List<dynamic> decodedList = jsonDecode(itemDetailsListJson);
      final List<Map<String, dynamic>> itemDetailsList =
          List<Map<String, dynamic>>.from(decodedList);
      setState(() {
        widget.itemDetailsList = itemDetailsList;
      });
    }
  }

  getCache() async {
    pref = await SharedPreferences.getInstance();
    payment = pref.getString('payment') ?? 'cash';

    if (fNameController.text.isEmpty) {
      fNameController.text = pref.getString('fName') ?? '';
    }
    if (lNameController.text.isEmpty) {
      lNameController.text = pref.getString('lName') ?? '';
    }
    if (phoneController.text.isEmpty) {
      phoneController.text = pref.getString('mobilePhone') ?? '';
    }
    if (currentLocation.text.isEmpty) {
      currentLocation.text = pref.getString('address') ?? '';
    }
    if (landmarkController.text.isEmpty) {
      landmarkController.text = pref.getString('surroundingLandmarks3') ?? '';
    }
    setState(() {});
    print('cache get');
  }

  setCache() async {
    pref.setString('payment', payment);
    pref.setString('fName', fNameController.text);
    pref.setString('lName', lNameController.text);
    pref.setString('mobilePhone', phoneController.text);
    pref.setString('address', currentLocation.text);
    pref.setString('surroundingLandmarks3', landmarkController.text);
    print('cache set');
  }

  Future<void> _pay() async {
    double totalPrice = 0.0;
    for (var item in widget.itemDetailsList) {
      double itemPrice = 0.0;
      if (item['itemPrice'] is String) {
        itemPrice = double.tryParse(item['itemPrice']) ?? 0.0;
      } else if (item['itemPrice'] is double) {
        itemPrice = item['itemPrice'];
      }

      int itemCount = 0;
      if (item['itemCount'] is String) {
        itemCount = int.tryParse(item['itemCount']) ?? 0;
      } else if (item['itemCount'] is int) {
        itemCount = item['itemCount'];
      }

      totalPrice += itemPrice * itemCount;
    }
    PaymobManager().payWithPaymob(totalPrice.toInt()).then((String paymentKey)async {
      final Uri paymob = Uri.parse(
        'https://accept.paymob.com/api/acceptance/iframes/848430?payment_token=$paymentKey');
    if (!await launchUrl(paymob)) {
      throw 'Could not launch $paymob';
    }
    });

    
  }

  @override
  void dispose() {
    super.dispose();
    setCache();
  }

  String payment = "cash";
  GlobalKey<ScaffoldState> ScaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'CHECKOUT',
          style: TextStyle(
            fontSize: Dimensions.height22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(Dimensions.height10),
              child: Form(
                key: customerFormKey,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'First Name',
                                    style: TextStyle(
                                      fontSize: Dimensions.height18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height5),
                                  TextFormField(
                                    controller: fNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter first name";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setCache();
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Enter first name',
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(
                                          r'^[a-zA-Z\u0600-\u06FF]+$',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Dimensions.height10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Last Name',
                                    style: TextStyle(
                                      fontSize: Dimensions.height18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height5),
                                  TextFormField(
                                    controller: lNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter last name";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setCache();
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Enter last name',
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[a-zA-Z\u0600-\u06FF]+$')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone',
                              style: TextStyle(
                                fontSize: Dimensions.height18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter phone";
                                } else if (!RegExp(r'^(010|011|012|015)\d{8}$')
                                    .hasMatch(value)) {
                                  return "Enter a valid phone";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setCache();
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter your phone',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                              ],
                            ),
                          ],
                        ),
                        // const SizedBox(height: 15),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     // const Text(
                        //     //   'Address',
                        //     //   style: TextStyle(
                        //     //     fontSize: 16,
                        //     //     fontWeight: FontWeight.w500,
                        //     //   ),
                        //     // ),
                        //     // const SizedBox(height: 5),
                        //     TextFormField(
                        //       controller: addressController,
                        //       maxLength: 50,
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return "Please enter address";
                        //         }
                        //         return null;
                        //       },
                        //       decoration: const InputDecoration(
                        //         hintText: 'Enter your address',
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: Dimensions.height20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => location_picker_page(
                                          service_name: 'mart',
                                        )));
                            setState(() {
                              getLocationButtonColor =
                                  Color.fromARGB(255, 238, 243, 239);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 224, 58, 58),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Location",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimensions.height20),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Dimensions.height20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address',
                              style: TextStyle(
                                fontSize: Dimensions.height18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: currentLocation,
                              // textAlign: TextAlign.center,
                              //maxLines: 2,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter location';
                                }
                                return null;
                              },
                              onChanged: (_) {
                                setCache();
                              },
                              decoration: InputDecoration(
                                hintText: 'Current Location',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // initialValue:
                              //     "${widget.subAdministrativeArea} ${widget.street}",
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Landmark (optional)',
                              style: TextStyle(
                                fontSize: Dimensions.height18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            TextFormField(
                              onChanged: (value) {
                                setCache();
                              },
                              controller: landmarkController,
                              maxLength: 50,
                              decoration: const InputDecoration(
                                hintText: 'Surrounding Landmarks',
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            Text(
                              "Payment method",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.height18),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //SizedBox(width:Dimensions.widht30 ,),
                                Row(
                                  children: [
                                    Radio(
                                        fillColor: WidgetStatePropertyAll(
                                            Color.fromARGB(255, 224, 58, 58)),
                                        value: "Cash",
                                        groupValue: payment,
                                        onChanged: (Val) {
                                          setState(() {
                                            payment = Val!;
                                            setCache();
                                          });
                                        }),
                                    Text(
                                      "cash",
                                      style: TextStyle(
                                          fontSize: Dimensions.height15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                //SizedBox(width:Dimensions.widht50 ,),
                                Row(
                                  children: [
                                    Radio(
                                        fillColor: WidgetStatePropertyAll(
                                            Color.fromARGB(255, 224, 58, 58)),
                                        value: "Card",
                                        groupValue: payment,
                                        onChanged: (Val) {
                                          setState(() {
                                            payment = Val!;
                                            setCache();
                                          });
                                        }),
                                    Text(
                                      "Card",
                                      style: TextStyle(
                                          fontSize: Dimensions.height15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            // payment == 'Card'
                            //     ? SizedBox(height: Dimensions.height15)
                            //     : SizedBox.shrink(),
                            // payment == 'Card'
                            //     ? Center(
                            //         child: Container(
                            //         width: 150,
                            //         height: Dimensions.height40,
                            //         decoration: BoxDecoration(
                            //             color: Color.fromARGB(255, 224, 58, 58),
                            //             borderRadius:
                            //                 BorderRadius.circular(20)),
                            //         child: TextButton(
                            //           onPressed: () async {
                            //             //_pay();
                            //           },
                            //           child: Text(
                            //             "Enter Card info",
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold,
                            //                 color: Colors.white),
                            //           ),
                            //         ),
                            //       ))
                            //     : SizedBox.shrink(),
                            SizedBox(height: Dimensions.height20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Cart Items",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.height18),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.height10),
                            Container(
                              padding: EdgeInsets.all(Dimensions.height10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F6),
                                border:
                                    Border.all(color: Colors.black, width: 0.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: Dimensions.height150,
                              child: ListView.builder(
                                itemCount: widget.itemDetailsList.length,
                                itemBuilder: (context, index) {
                                  final item = widget.itemDetailsList[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: Dimensions.height5),
                                      Text(
                                        "- ${item['itemName']} (${item['itemPrice']} x ${item['itemCount']})",
                                        style: TextStyle(
                                          fontSize: Dimensions.height15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: Dimensions.height5),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.height25,
                    ),
                    FilledButton(
                      onPressed: () {
                        if (customerFormKey.currentState!.validate()) {
                          addService();
                          //clearCache();
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 224, 58, 58),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: Dimensions.height22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //   if (isLoading)
                    // Center(
                    //   child: CircularProgressIndicator(),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
