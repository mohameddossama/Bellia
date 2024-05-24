import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Orderdetails extends StatefulWidget {
 final String documentName ;
  const Orderdetails({super.key, required this.documentName});

  @override
  State<Orderdetails> createState() => _OrderdetailsState();
}

class _OrderdetailsState extends State<Orderdetails> {

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


Future<DocumentSnapshot> fetchOrderDocument(String documentName) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(documentName)
        .get();

    return snapshot;
  } catch (error) {
    print("Error fetching order document: $error");
    throw error;
  }
}

@override
  void initState() {
    // get_current_location_app();
    _determinePosition();
    fetchOrderDocument(widget.documentName);
    super.initState();
    print("${widget.documentName}");
  }

   @override
void dispose() {
  super.dispose();
  gm_controller?.dispose(); // Use the null-aware operator ?. to safely call dispose
}

  
  @override
  Widget build(BuildContext context) {
    return 
    SingleChildScrollView(
      child: 
      Column(
        children: [
          Container(
            height: 850,
            child: FutureBuilder<DocumentSnapshot>(
              future: fetchOrderDocument(widget.documentName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching order data'));
                } else {
                  Map<String, dynamic>? orderData = snapshot.data?.data() as Map<String, dynamic>?;
                  if (orderData == null) {
                    return Center(child: Text('No data found for this order'));
                  }
                  // Use orderData to populate your UI
                  return buildOrderDetailsUI(orderData);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderDetailsUI(Map<String, dynamic> orderData) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
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
          Text('Service: ${orderData['Service']}'),
          Text('Date and Time: ${orderData['Date and Time']}'),
          Text('Date and Time: ${orderData['Price']}'),
          Text('Date and Time: ${orderData['Plate number']}'),
         
        ],
      ),
    );
  }
}