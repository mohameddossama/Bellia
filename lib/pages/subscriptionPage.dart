import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionPage extends StatefulWidget {
  SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool isGarageSelected = true;
  bool isloading = true;
  List<DocumentSnapshot> data = [];

  // void getData() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("car wash our center")
  //       .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.email)
  //       .get();
  //   await Future.delayed(Duration(seconds: 1));
  //   data.addAll(querySnapshot.docs);
  //   isloading = false;
  //   setState(() {});
  // }

  // List<DocumentSnapshot> datta = [];

  // void gettData() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("Garage")
  //       .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.email)
  //       .get();
  //   await Future.delayed(Duration(seconds: 1));
  //   data.addAll(querySnapshot.docs);
  //   isloading = false;
  //   setState(() {});
  // }

  late StreamSubscription<List<Map<String, dynamic>>>? garageSubscription;
  late StreamSubscription<List<Map<String, dynamic>>>? washSubscription;
  List<Map<String, dynamic>> garageData = [];
  List<Map<String, dynamic>> washData = [];

  @override
  void initState() {
    super.initState();
    garageSubscription = fetchOrderDataStream().listen((data) {
      if (mounted) {
        setState(() {
          garageData = data;
        });
      }
    }, onError: (error) {
      print('Error fetching garage data: $error');
    });

    washSubscription = fetchWashrDataStream().listen((data) {
      if (mounted) {
        setState(() {
          washData = data;
        });
      }
    }, onError: (error) {
      print('Error fetching wash data: $error');
    });
  }

  @override
  void dispose() {
    garageSubscription?.cancel();
    washSubscription?.cancel();
    super.dispose();
  }

  Stream<List<Map<String, dynamic>>> fetchWashrDataStream() {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        throw Exception("No user logged in");
      }
      String queryPrefix = '$userEmail - ';
      List<String> options = ['car wash our center'];

      return FirebaseFirestore.instance
          .collection('car wash our center')
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: queryPrefix)
          .where(FieldPath.documentId, isLessThan: queryPrefix + '\uf8ff')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .where((doc) =>
                  doc.id.startsWith(queryPrefix) &&
                  options.any((option) => doc.id.contains(option)))
              .map((doc) => doc.data())
              .toList());
    } catch (error) {
      print("Error fetching order data: $error");
      return Stream.value([]);
    }
  }

  Stream<List<Map<String, dynamic>>> fetchOrderDataStream() {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        throw Exception("No user logged in");
      }
      String queryPrefix = '$userEmail - ';
      List<String> options = ['Garage'];

      return FirebaseFirestore.instance
          .collection('Garage')
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: queryPrefix)
          .where(FieldPath.documentId, isLessThan: queryPrefix + '\uf8ff')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .where((doc) =>
                  doc.id.startsWith(queryPrefix) &&
                  options.any((option) => doc.id.contains(option)))
              .map((doc) => doc.data())
              .toList());
    } catch (error) {
      print("Error fetching order data: $error");
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Subscription",
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
      ),
      //
      // PreferredSize(
      //   preferredSize: const Size.fromHeight(100.0),
      //   child: Container(
      //     color: const Color.fromARGB(255, 224, 58, 58),
      //     width: double.infinity,
      //     height: 90,
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     child: const Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Icon(Icons.arrow_back, color: Colors.white),
      //         SizedBox(width: 10),
      //         Text("Subscription",
      //             style: TextStyle(
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.white,
      //             )),
      //       ],
      //     ),
      //   ),
      // ),
      body: garageData.isEmpty && washData.isEmpty
          ? Center(
              child: Text(
              "No Packages Purchased",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (garageData.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.all(50),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const ListTile(
                            title: Center(
                              child: Text('Garage',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.grade, color: Colors.amber),
                                  SizedBox(width: 5),
                                  Text(
                                    garageData[0]["Package name"] as String? ??
                                        'Package name',
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_month,
                                      color: Colors.red.shade800),
                                  const SizedBox(width: 5),
                                  Text(garageData[0]["Date and Time"]
                                          as String? ??
                                      ''),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.event_busy,
                                      color: Colors.red.shade800),
                                  const SizedBox(width: 5),
                                  Text(garageData[0]["expirationdate"]
                                          as String? ??
                                      '2024-05-14 at 14:06:33'),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Request a Photo'),
                                    content: const Text(
                                        "Would you like the photo to be sent to +201125564479?"),
                                    actions: <TextButton>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Request a photo',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(255, 224, 58, 58)),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  if (washData.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.only(
                          left: 50, right: 50, bottom: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const ListTile(
                            title: Center(
                              child: Text('Car Wash',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //Icon(Icons.format_paint, color: Colors.blue),
                                  Icon(Icons.cleaning_services,
                                      color: Colors.amber),
                                  // Icon(Icons.shower, color: Colors.amber),
                                  //Icon(Icons.brightness_high, color: Colors.amber),
                                  // Icon(Icons.wb_sunny, color: Colors.amber),
                                  SizedBox(width: 5),
                                  Text(
                                      washData[0]["package_title"] as String? ??
                                          'Title'),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_month,
                                      color: Colors.red.shade800),
                                  const SizedBox(width: 5),
                                  Text(
                                      washData[0]["Date and Time"] as String? ??
                                          '15/3/2024'),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.event_busy,
                                      color: Colors.red.shade800),
                                  const SizedBox(width: 5),
                                  Text(washData[0]["Expiration"] as String? ??
                                      "Expiration Date: 15/3/2024"),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
