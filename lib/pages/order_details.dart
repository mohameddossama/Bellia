import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class order_details_page extends StatefulWidget {
  final String documentName ;
  const order_details_page({super.key, required String service_name, required this.documentName});

  @override
  State<order_details_page> createState() => order_details_pageState();
}

class order_details_pageState extends State<order_details_page> {
  String service_name = "e-store";
  double bellia_long = 29.909494;
  double bellia_lat = 31.208805;
  double garage_long = 30.005420;
  double garage_lat = 31.274098;
  bool garage = false;
  double? time;
  double? time_in_min;
  double? time_in_hours;
  double? distance;
  Position? currrent_position;
  Position? position;
  CameraPosition init_camera_position = const CameraPosition(
      target: LatLng(31.207594036592457, 29.90769200026989), zoom: 14);


  GoogleMapController? gm_controller;
  List<Marker> marks = [];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Please Enable Location Service"),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(label: "Ok", onPressed: () {}),
      ));
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("==================");
    print(
        "current lat: ${position!.latitude} current long: ${position!.longitude}");
    print("==================");

    double customer_long = position!.longitude;
    double customer_lat = position!.latitude;

    marks.add(Marker(
        markerId: const MarkerId("1"),
        position: LatLng(customer_lat, customer_long)));
    marks.add(Marker(
        markerId: const MarkerId("2"), position: LatLng(bellia_lat, bellia_long)));

    distance = Geolocator.distanceBetween(
        customer_lat, customer_long, bellia_lat, bellia_long);
    print("==================");
    print(distance! / 1000);
    print("==================");

    double distance_in_killos = distance! / 1000;
    time = distance_in_killos / 40;

    print("==================");
    print("time: ${time} ");
    print("==================");

    if (time! < 1) {
      time_in_min = time! * 60;
    }
    if (time! >= 1) {
      time_in_hours = time!;
    }

    if (service_name == "garage") {
      marks.add(Marker(
          markerId: const MarkerId("2"), position: LatLng(garage_lat, garage_long)));
      init_camera_position =
          CameraPosition(target: LatLng(garage_lat, garage_long), zoom: 14);
      garage = true;    
          
    }

    setState(() {});

    return await Geolocator.getCurrentPosition();
  }

  String? fName;
  String? lName;
  String? mobile;
  String? service;

  Future<void> fetchUserData() async {
  try {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      throw Exception("No user logged in");
    }
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc("${widget.documentName}")
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      fName = userData['User first name'] ?? '';
      lName = userData['User last name'] ?? '';
      mobile = userData['Phone Number'] ?? '';
      service = userData['Service'] ?? '';
      setState(() {});
    } else {
      print('Document does not exist');
    }
  } catch (error) {
    print("Error fetching user data: $error");
  }
}


  @override
  void initState() {
    // get_current_location_app();
    _determinePosition();
    fetchUserData();
    super.initState();
    print("${widget.documentName}");
    print(service);
  }

   @override
void dispose() {
  super.dispose();
  gm_controller?.dispose(); // Use the null-aware operator ?. to safely call dispose
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.red,
          title: const Text("Order Details", style: TextStyle(color: Colors.white)),
        ),
        body: ListView(
          children: [
            Container(
              height: 400,
              child: GoogleMap(
                initialCameraPosition: garage ? init_camera_position : CameraPosition(target: LatLng(garage_lat, garage_long), zoom: 14),
                markers: marks.toSet(),
                mapType: MapType.normal,
                onMapCreated: (controller) {
                  gm_controller = controller;
                },
                onTap: (argument) async {
                  print("======================");
                  print(
                      "lat is ${argument.latitude} and long is ${argument.longitude}");
                  print("======================");

                  setState(() {});
                },
              ),
            ),

            // roadside service
           // if (service_name == "roadside assistance")
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(8),
                      child:  Text(
                        service!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 8),
                    child:  Row(
                      children: [
                        Icon(Icons.directions_car_sharp),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          fName!,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 8),
                    child:  Row(
                      children: [
                        Icon(Icons.badge_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          service!,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 8),
                    child: const Row(
                      children: [
                        Icon(Icons.help_outline_rounded),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            "i don't know the exact fault, but the car stopped suddenly and start making noises",
                          ),
                        )
                      ],
                    ),
                  ),
                  if (time != null && time! < 1)
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Estimated Time: ${time_in_min!.toStringAsFixed(0)} minutes",
                          )
                        ],
                      ),
                    ),
                  if (time != null && time! >= 1)
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Estimated Time: ${time_in_hours!.toStringAsFixed(2)} hours",
                          )
                        ],
                      ),
                    ),
                ],
              ),


            //   //maintenance service
            // if (service_name == "maintenance")
            //   Column(
            //     children: [
            //       Container(
            //           padding: const EdgeInsets.all(8),
            //           child: const Text(
            //             "Maintenance",
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold, fontSize: 20),
            //           )),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.directions_car_sharp),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "BMW , x6",
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.badge_outlined),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "2 5 9 4   س ج ط",
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.car_repair_outlined),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Expanded(
            //               child: Text(
            //                 "Tire Change , Routine Check",
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.help_outline_rounded),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Expanded(
            //               child: Text(
            //                 "Please be careful with my car",
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),


            // // car wash service
            // if (service_name == "car wash")
            //   Column(
            //     children: [
            //       Container(
            //           padding: const EdgeInsets.all(8),
            //           child: const Text(
            //             "Car Wash",
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold, fontSize: 20),
            //           )),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.workspace_premium_outlined),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Expanded(
            //               child: Text(
            //                 "Quick Shine",
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.directions_car_sharp),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "BMW , x6",
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.badge_outlined),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "2 5 9 4   س ج ط",
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.attach_money_outlined),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "250 EGP",
            //             )
            //           ],
            //         ),
            //       ),
            //       if (time != null && time! < 1)
            //         Container(
            //           margin: const EdgeInsets.only(left: 20, top: 8),
            //           child: Row(
            //             children: [
            //               const Icon(Icons.timer_outlined),
            //               const SizedBox(
            //                 width: 15,
            //               ),
            //               Text(
            //                 "Estimated Time: ${time_in_min!.toStringAsFixed(0)} minutes",
            //               )
            //             ],
            //           ),
            //         ),
            //       if (time != null && time! >= 1)
            //         Container(
            //           margin: const EdgeInsets.only(left: 20, top: 8),
            //           child: Row(
            //             children: [
            //               const Icon(Icons.timer_outlined),
            //               const SizedBox(
            //                 width: 15,
            //               ),
            //               Text(
            //                 "Estimated Time: ${time_in_hours!.toStringAsFixed(2)} hours",
            //               )
            //             ],
            //           ),
            //         ),
            //     ],
            //   ),

            // // garage service
            // if (service_name == "garage")
            //   Column(
            //     children: [
            //       Container(
            //           padding: const EdgeInsets.all(8),
            //           child: const Text(
            //             "Garage",
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold, fontSize: 20),
            //           )),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.workspace_premium_outlined),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Expanded(
            //               child: Text(
            //                 "Gold",
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.directions_car_sharp),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "BMW , x6",
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.badge_outlined),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "2 5 9 4   س ج ط",
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.numbers_rounded),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "2 Weeks",
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.attach_money_outlined),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "4000 EGP",
            //             )
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),

            // // e-store service
            // if (service_name == "e-store")
            //   Column(
            //     children: [
            //       Container(
            //           padding: const EdgeInsets.all(8),
            //           child: const Text(
            //             "Bellia Mart",
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold, fontSize: 20),
            //           )),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.production_quantity_limits),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Expanded(
            //               child: Text(
            //                 "Plain Rubber",
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.numbers),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "2 Items",
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.rate_review),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Expanded(
            //               child: Text(
            //                 "1roll plain rubber double-sided car tire Anti-collision tape",
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(left: 20, top: 8),
            //         child: const Row(
            //           children: [
            //             Icon(Icons.attach_money_outlined),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             Text(
            //               "300 EGP",
            //             )
            //           ],
            //         ),
            //       ),
            //       if (time != null && time! < 1)
            //         Container(
            //           margin: const EdgeInsets.only(left: 20, top: 8),
            //           child: Row(
            //             children: [
            //               const Icon(Icons.timer_outlined),
            //               const SizedBox(
            //                 width: 15,
            //               ),
            //               Text(
            //                 "Estimated Time: ${time_in_min!.toStringAsFixed(0)} minutes",
            //               )
            //             ],
            //           ),
            //         ),
            //       if (time != null && time! >= 1)
            //         Container(
            //           margin: const EdgeInsets.only(left: 20, top: 8),
            //           child: Row(
            //             children: [
            //               const Icon(Icons.timer_outlined),
            //               const SizedBox(
            //                 width: 15,
            //               ),
            //               Text(
            //                 "Estimated Time: ${time_in_hours!.toStringAsFixed(2)} hours",
            //               )
            //             ],
            //           ),
            //         ),
            //     ],
            //   ),

            Center(
                child: Container(
                    margin: const EdgeInsets.all(8),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    )))
          ],
        ));
  }
}
