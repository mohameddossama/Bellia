import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/pages/orderDetails.dart';
import 'package:fluttercourse/pages/order_details.dart';
import 'package:fluttercourse/paymob/paymob_manager.dart';
import 'package:fluttercourse/util/dimensions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';

class Orderhistory extends StatefulWidget {
  const Orderhistory({Key? key}) : super(key: key);

  @override
  State<Orderhistory> createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {
  late Stream<List<Map<String, dynamic>>> orderDataStream;

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
        markerId: const MarkerId("2"),
        position: LatLng(bellia_lat, bellia_long)));

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
          markerId: const MarkerId("2"),
          position: LatLng(garage_lat, garage_long)));
      init_camera_position =
          CameraPosition(target: LatLng(garage_lat, garage_long), zoom: 14);
      garage = true;
    }

    setState(() {});

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
    orderDataStream = fetchOrderDataStream();
  }

  @override
  void dispose() {
    super.dispose();
    gm_controller?.dispose();
  }

  // String? userEmail = FirebaseAuth.instance.currentUser?.email;
  // Stream<List<Map<String, dynamic>>> fetchOrderDataStream() {
  //   try {
  //     String? userEmail = FirebaseAuth.instance.currentUser?.email;
  //     if (userEmail == null) {
  //       throw Exception("No user logged in");
  //     }
  //     String queryPrefix = '$userEmail - ';

  //     return FirebaseFirestore.instance
  //         .collection('orders')
  //         .where(FieldPath.documentId, isGreaterThanOrEqualTo: queryPrefix)
  //         .where(FieldPath.documentId, isLessThan: queryPrefix + '\uf8ff')
  //         .snapshots()
  //         .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  //   } catch (error) {
  //     print("Error fetching order data: $error");
  //     return Stream.value([]);
  //   }
  // }

  Future<void> _launchPhoneCall() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '0122446449',
    );

    if (!await launchUrl(phoneUri)) {
      throw 'Could not launch $phoneUri';
    }
  }

  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  Stream<List<Map<String, dynamic>>> fetchOrderDataStream() {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        throw Exception("No user logged in");
      }
      String queryPrefix = '$userEmail - ';
      List<String> options = [
        'Roadside Assistance',
        'car wash: our center',
        'car wash: your place',
        'Car Towing',
        'Bellia Mart',
        'Garage',
        "Maintenance"
      ];

      return FirebaseFirestore.instance
          .collection('orders')
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

  Future<void> _pay() async {
    PaymobManager().payWithPaymob(300).then((String paymentKey) async {
      final Uri paymob = Uri.parse(
          'https://accept.paymob.com/api/acceptance/iframes/848430?payment_token=$paymentKey');
      if (!await launchUrl(paymob)) {
        throw 'Could not launch $paymob';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
        title: const Text(
          'Orders History',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => CommerceHome()),
              (route) => false,
            );
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 241, 241),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: orderDataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Error fetching order data'));
            } else {
              List<Map<String, dynamic>> orders = snapshot.data!;
              return snapshot.data!.isEmpty
                  ? Center(
                      child: Text(
                      "No Orders Made",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ))
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> order = orders[index];
                        return order['Status'] == 'Completed' ||
                                order['Status'] == 'Canceled'
                            ? Container(
                                padding: EdgeInsets.all(Dimensions.height5),
                                margin: EdgeInsets.only(
                                    top: Dimensions.height12,
                                    left: 8,
                                    right: 8),
                                height: Dimensions.height130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1.5,
                                    color:
                                        const Color.fromARGB(255, 153, 12, 12),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.height15),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          order['Service'] ?? '',
                                          style: TextStyle(
                                            fontSize: Dimensions.height20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 211, 57, 46),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: order['Status'] == 'Canceled'
                                                ? const Color.fromARGB(
                                                    255, 216, 12, 12)
                                                : const Color.fromARGB(
                                                    255, 49, 179, 9),
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Text(
                                            order['Status'] ?? '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimensions.height12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(order["User first name"],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: Dimensions
                                                            .height15)),
                                                SizedBox(
                                                    width: Dimensions.widht10),
                                                Text(order["User last name"],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: Dimensions
                                                            .height15)),
                                              ],
                                            ),
                                            SizedBox(
                                                height: Dimensions.height10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    // Navigator.of(context).push(
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         order_details_page(
                                                    //       service_name: order['Service'], documentName: '${FirebaseAuth.instance.currentUser?.email} - ${order['Date and Time']} - ${order['Service']}',
                                                    //     ),
                                                    //   ),
                                                    // );
                                                    Scaffold.of(context)
                                                        .showBottomSheet(
                                                            (BuildContext
                                                                context) {
                                                      return Container(
                                                        height: order[
                                                                    'Service'] ==
                                                                'Garage'
                                                            ? Dimensions
                                                                .height580
                                                            : order['Service'] ==
                                                                    'car wash: your Place'
                                                                ? Dimensions
                                                                    .height605
                                                                : Dimensions
                                                                    .height575,
                                                        width:
                                                            Dimensions.widht500,
                                                        padding: EdgeInsets.all(
                                                            Dimensions
                                                                .height10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                              child: Container(
                                                                height: 200,
                                                                width: 360,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20)),
                                                                  border: Border
                                                                      .all(
                                                                    width: 2,
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        224,
                                                                        58,
                                                                        58),
                                                                  ),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20)),
                                                                  child:
                                                                      GoogleMap(
                                                                    initialCameraPosition: garage
                                                                        ? init_camera_position
                                                                        : CameraPosition(
                                                                            target: LatLng(garage_lat,
                                                                                garage_long),
                                                                            zoom:
                                                                                14),
                                                                    markers: marks
                                                                        .toSet(),
                                                                    mapType: MapType
                                                                        .normal,
                                                                    onMapCreated:
                                                                        (controller) {
                                                                      gm_controller =
                                                                          controller;
                                                                    },
                                                                    onTap:
                                                                        (argument) async {
                                                                      print(
                                                                          "======================");
                                                                      print(
                                                                          "lat is ${argument.latitude} and long is ${argument.longitude}");
                                                                      print(
                                                                          "======================");

                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    gestureRecognizers:
                                                                        Set()
                                                                          ..add(Factory<PanGestureRecognizer>(() =>
                                                                              PanGestureRecognizer()))
                                                                          ..add(Factory<ScaleGestureRecognizer>(() =>
                                                                              ScaleGestureRecognizer()))
                                                                          ..add(Factory<TapGestureRecognizer>(() =>
                                                                              TapGestureRecognizer()))
                                                                          ..add(Factory<OneSequenceGestureRecognizer>(() =>
                                                                              EagerGestureRecognizer())),
                                                                  ),
                                                                ),
                                                              ),

                                                              //   SizedBox(width: Dimensions.widht10,),
                                                            ),
                                                            // SizedBox(
                                                            //   height: Dimensions
                                                            //       .height10,
                                                            // ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: Dimensions
                                                                      .height20,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .location_on,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          224,
                                                                          58,
                                                                          58),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    SizedBox(
                                                                        width: Dimensions
                                                                            .widht350,
                                                                        child:
                                                                            Text(
                                                                          order['Location'] ??
                                                                              '123 Hamed Ahmed Street',
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        )),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      Dimensions
                                                                          .height5,
                                                                ),
                                                                order['Land mark'] ==
                                                                            null ||
                                                                        order['Land mark'] ==
                                                                            ' '
                                                                    ? Container()
                                                                    : Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.star_rate,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                224,
                                                                                58,
                                                                                58),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          SizedBox(
                                                                              width: Dimensions.widht350,
                                                                              child: Text(
                                                                                order['Land mark'] ?? '',
                                                                                overflow: TextOverflow.ellipsis,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                SizedBox(
                                                                  height: Dimensions
                                                                      .height10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'Ordered : ',
                                                                      style: TextStyle(
                                                                          fontSize: Dimensions
                                                                              .height15,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              224,
                                                                              58,
                                                                              58)),
                                                                    ),
                                                                    SizedBox(
                                                                      width: Dimensions
                                                                          .widht160,
                                                                      child:
                                                                          Text(
                                                                        order['Date and Time'] ??
                                                                            '',
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: Dimensions
                                                                  .height10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Service : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .height15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          224,
                                                                          58,
                                                                          58)),
                                                                ),
                                                                SizedBox(
                                                                  width: Dimensions
                                                                      .widht160,
                                                                  child: Text(
                                                                    order['Service'] ??
                                                                        '',
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: Dimensions
                                                                  .height10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Customer : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .height15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          224,
                                                                          58,
                                                                          58)),
                                                                ),
                                                                Text(
                                                                  order['User first name'] ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Text(
                                                                  order['User last name'] ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                            order['Payment Method'] ==
                                                                        null ||
                                                                    order['Payment Method'] ==
                                                                        ''
                                                                ? SizedBox
                                                                    .shrink()
                                                                : SizedBox(
                                                                    height: Dimensions
                                                                        .height10,
                                                                  ),
                                                            order['Payment Method'] ==
                                                                        null ||
                                                                    order['Payment Method'] ==
                                                                        ''
                                                                ? SizedBox
                                                                    .shrink()
                                                                : Row(
                                                                    children: [
                                                                      Text(
                                                                        'Payment Method : ',
                                                                        style: TextStyle(
                                                                            fontSize: Dimensions
                                                                                .height15,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                224,
                                                                                58,
                                                                                58)),
                                                                      ),
                                                                      Text(
                                                                        order['Payment Method'] ??
                                                                            '',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            order['Service'] ==
                                                                    'Bellia Mart'
                                                                ? SizedBox
                                                                    .shrink()
                                                                : SizedBox(
                                                                    height: Dimensions
                                                                        .height10,
                                                                  ),
                                                            order['Service'] ==
                                                                    'Garage'
                                                                ? Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                'Package Name : ',
                                                                                style: TextStyle(fontSize: Dimensions.height15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                              ),
                                                                              Text(
                                                                                order['Package name'] ?? '',
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.height12),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                Dimensions.widht20,
                                                                          ),
                                                                          Text(
                                                                            'Package Price : ',
                                                                            style: TextStyle(
                                                                                fontSize: Dimensions.height15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: const Color.fromARGB(255, 224, 58, 58)),
                                                                          ),
                                                                          Text(
                                                                            order['Single Week Price'] ??
                                                                                '',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.height12),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                Dimensions.widht5,
                                                                          ),
                                                                          Text(
                                                                            '/ Week',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.height12),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            Dimensions.height10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Number Of Weeks: ',
                                                                            style: TextStyle(
                                                                                fontSize: Dimensions.height15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: const Color.fromARGB(255, 224, 58, 58)),
                                                                          ),
                                                                          Text(
                                                                            order['Number of weeks'] ??
                                                                                '',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                : order['Service'] ==
                                                                        'Bellia Mart'
                                                                    ? SizedBox
                                                                        .shrink()
                                                                    : order['Issue'] !=
                                                                                '' ||
                                                                            order['Description(Optional)'] !=
                                                                                ''
                                                                        ? Row(
                                                                            children: [
                                                                              Text(
                                                                                'Customer Notes :  ',
                                                                                style: TextStyle(fontSize: Dimensions.height15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                              ),
                                                                              SizedBox(
                                                                                width: Dimensions.widht228,
                                                                                child: Text(
                                                                                  order['Issue'] ?? order['Description(Optional)'],
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        : SizedBox
                                                                            .shrink(),
                                                            order['Issue'] !=
                                                                        '' ||
                                                                    order['Description(Optional)'] !=
                                                                        ''
                                                                ? SizedBox(
                                                                    height: Dimensions
                                                                        .height10,
                                                                  )
                                                                : SizedBox
                                                                    .shrink(),
                                                            order['Service'] ==
                                                                    'Bellia Mart'
                                                                ? SizedBox
                                                                    .shrink()
                                                                : Row(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Car : ',
                                                                            style: TextStyle(
                                                                                fontSize: Dimensions.height15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: const Color.fromARGB(255, 224, 58, 58)),
                                                                          ),
                                                                          Text(
                                                                            order['Car brand'] ??
                                                                                '',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                Dimensions.widht10,
                                                                            child:
                                                                                Text(
                                                                              '-',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            order['Car model'] ??
                                                                                '',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        width: Dimensions
                                                                            .widht45,
                                                                      ),
                                                                      Text(
                                                                        'Plate Number : ',
                                                                        style: TextStyle(
                                                                            fontSize: Dimensions
                                                                                .height15,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                224,
                                                                                58,
                                                                                58)),
                                                                      ),
                                                                      Text(
                                                                        order['Plate number'] ??
                                                                            '',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            order['Service'] ==
                                                                    'Bellia Mart'
                                                                ? SizedBox
                                                                    .shrink()
                                                                : SizedBox(
                                                                    height: Dimensions
                                                                        .height10,
                                                                  ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Order Status: ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .height15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          224,
                                                                          58,
                                                                          58)),
                                                                ),
                                                                Text(
                                                                  order['Confirmed Status'] ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: Dimensions
                                                                  .height10,
                                                            ),
                                                            order['Status'] ==
                                                                    'Completed'
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Center(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              Dimensions.height35,
                                                                          decoration: BoxDecoration(
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                              borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                          child:
                                                                              TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              //   Navigator.of(context).push(
                                                                              //   MaterialPageRoute(
                                                                              //     builder: (context) =>
                                                                              //         Orderdetails(
                                                                              //        documentName: '${FirebaseAuth.instance.currentUser?.email} - ${order['Date and Time']} - ${order['Service']}',
                                                                              //     ),
                                                                              //   ),
                                                                              // );
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  if (order['Service'] == 'Garage') {
                                                                                    return AlertDialog(
                                                                                      title: Container(
                                                                                          width: 10,
                                                                                          padding: EdgeInsets.all(5),
                                                                                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                                                                                          child: Center(
                                                                                              child: Text(
                                                                                            'Order Receipt',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                                          ))),
                                                                                      content: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            height: Dimensions.height10,
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              Icon(Icons.attach_money_rounded, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              SizedBox(
                                                                                                width: Dimensions.widht5,
                                                                                              ),
                                                                                              Text('Single Week Price: ${order['Single Week Price']}', style: TextStyle(fontSize: Dimensions.height17)),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: Dimensions.height10,
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              Icon(Icons.calendar_month_outlined, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              SizedBox(
                                                                                                width: Dimensions.widht5,
                                                                                              ),
                                                                                              Text('Number Of Weeks: ${order['Number of weeks']}', style: TextStyle(fontSize: Dimensions.height17)),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: Dimensions.height50,
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              // Icon(Icons.add,color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              // SizedBox(width: Dimensions.widht5,),
                                                                                              Text('Total Price: ${order['Total Service cost']}', style: TextStyle(fontSize: Dimensions.height17, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 224, 58, 58))),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: Dimensions.height5,
                                                                                          ),
                                                                                          order['Status'] == 'Completed'
                                                                                              ? Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                        width: Dimensions.widht150,
                                                                                                        child: Text(
                                                                                                          "Please Contact Us as soon as possible regarding the contract",
                                                                                                          style: TextStyle(fontSize: Dimensions.height10, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                                          maxLines: 2,
                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                        ))
                                                                                                  ],
                                                                                                )
                                                                                              : Container(),
                                                                                        ],
                                                                                      ),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Text(
                                                                                            'Close',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  } else if (order['Service'] == 'Car Towing') {
                                                                                    return AlertDialog(
                                                                                      title: Container(
                                                                                          width: 10,
                                                                                          padding: EdgeInsets.all(5),
                                                                                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                                                                                          child: Center(
                                                                                              child: Text(
                                                                                            'Order Receipt',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                                          ))),
                                                                                      content: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            height: Dimensions.height10,
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              Icon(Icons.speed, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              SizedBox(
                                                                                                width: Dimensions.widht5,
                                                                                              ),
                                                                                              Text('Single Kilometer Price: ${order['Single kilometer price']}', style: TextStyle(fontSize: Dimensions.height15)),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: Dimensions.height10,
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              Icon(Icons.numbers_outlined, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              SizedBox(
                                                                                                width: Dimensions.widht5,
                                                                                              ),
                                                                                              Text('Towing Distance: ${order['Number of kilometers']}', style: TextStyle(fontSize: Dimensions.height15)),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: Dimensions.height50,
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              // Icon(Icons.add,color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              // SizedBox(width: Dimensions.widht5,),
                                                                                              Text('Total Price: ${order['Total Service cost']}', style: TextStyle(fontSize: Dimensions.height17, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 224, 58, 58))),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Text(
                                                                                            'Close',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  } else if (order['Service'] == 'Roadside Assistance') {
                                                                                    return AlertDialog(
                                                                                      title: Container(
                                                                                          width: 10,
                                                                                          padding: EdgeInsets.all(5),
                                                                                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                                                                                          child: Center(
                                                                                              child: Text(
                                                                                            'Order Receipt',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                                          ))),
                                                                                      content: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            height: Dimensions.height10,
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              Icon(Icons.speed, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              SizedBox(
                                                                                                width: Dimensions.widht5,
                                                                                              ),
                                                                                              Text('Single Kilometer Price: ${order['Single kilometer price']}', style: TextStyle(fontSize: Dimensions.height15)),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: Dimensions.height10,
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              Icon(Icons.numbers_outlined, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              SizedBox(
                                                                                                width: Dimensions.widht5,
                                                                                              ),
                                                                                              Text('Towing Distance: ${order['Number of kilometers']}', style: TextStyle(fontSize: Dimensions.height15)),
                                                                                            ],
                                                                                          ),
                                                                                          order['Additional services cost 1'] != '' || order['Additional services 1'] != ''
                                                                                              ? SizedBox(
                                                                                                  height: Dimensions.height10,
                                                                                                )
                                                                                              : SizedBox.shrink(),
                                                                                          order['Additional services cost 1'] != '' || order['Additional services 1'] != ''
                                                                                              ? Row(
                                                                                                  children: [
                                                                                                    Icon(Icons.note_add, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                                    SizedBox(
                                                                                                      width: Dimensions.widht5,
                                                                                                    ),
                                                                                                    Text('${order['Additional services 1']} : ${order['Additional services cost 1']} ', style: TextStyle(fontSize: Dimensions.height15)),
                                                                                                  ],
                                                                                                )
                                                                                              : SizedBox.shrink(),
                                                                                          order['Additional services cost 2'] != '' || order['Additional services 2'] != ''
                                                                                              ? SizedBox(
                                                                                                  height: Dimensions.height10,
                                                                                                )
                                                                                              : SizedBox.shrink(),
                                                                                          order['Additional services cost 2'] != '' || order['Additional services 2'] != ''
                                                                                              ? Row(
                                                                                                  children: [
                                                                                                    Icon(Icons.note_add, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                                    SizedBox(
                                                                                                      width: Dimensions.widht5,
                                                                                                    ),
                                                                                                    Text('${order['Additional services 2']} : ${order['Additional services cost 2']} ', style: TextStyle(fontSize: Dimensions.height15)),
                                                                                                  ],
                                                                                                )
                                                                                              : SizedBox.shrink(),
                                                                                          order['Additional services cost 3'] != '' || order['Additional services 3'] != ''
                                                                                              ? SizedBox(
                                                                                                  height: Dimensions.height10,
                                                                                                )
                                                                                              : SizedBox.shrink(),
                                                                                          order['Additional services cost 3'] != '' || order['Additional services 3'] != ''
                                                                                              ? Row(
                                                                                                  children: [
                                                                                                    Icon(Icons.note_add, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                                    SizedBox(
                                                                                                      width: Dimensions.widht5,
                                                                                                    ),
                                                                                                    Text('${order['Additional services 3']} : ${order['Additional services cost 3']} ', style: TextStyle(fontSize: Dimensions.height15)),
                                                                                                  ],
                                                                                                )
                                                                                              : SizedBox.shrink(),
                                                                                          SizedBox(
                                                                                            height: Dimensions.height50,
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              // Icon(Icons.add,color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              // SizedBox(width: Dimensions.widht5,),
                                                                                              Text('Total Price: ${order['Total Service cost']}', style: TextStyle(fontSize: Dimensions.height17, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 224, 58, 58))),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Text(
                                                                                            'Close',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  } else if (order['Service'] == 'Bellia Mart') {
                                                                                    return AlertDialog(
                                                                                      title: Container(
                                                                                        width: 10,
                                                                                        padding: EdgeInsets.all(5),
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.black,
                                                                                          borderRadius: BorderRadius.circular(20),
                                                                                        ),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'Order Receipt',
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      content: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          SizedBox(height: Dimensions.height10),
                                                                                          StreamBuilder<QuerySnapshot>(
                                                                                            stream: FirebaseFirestore.instance.collection('orders').doc("${FirebaseAuth.instance.currentUser?.email} - ${order['Date and Time']} - ${order['Service']}").collection('cartItems').snapshots(),
                                                                                            builder: (context, snapshot) {
                                                                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                return const Center(child: CircularProgressIndicator());
                                                                                              } else if (snapshot.hasError) {
                                                                                                return const Center(child: Text('Error fetching data'));
                                                                                              } else if (snapshot.data!.docs.isEmpty) {
                                                                                                return const Center(child: Text('No items found'));
                                                                                              } else {
                                                                                                return Column(
                                                                                                  children: snapshot.data!.docs.map((doc) {
                                                                                                    var cartData = doc.data() as Map<String, dynamic>;
                                                                                                    return Padding(
                                                                                                      padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "${cartData['AMOUNT']}X",
                                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.height15, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                                          ),
                                                                                                          SizedBox(width: Dimensions.widht10),
                                                                                                          Container(
                                                                                                              width: Dimensions.widht150,
                                                                                                              child: Text(
                                                                                                                "${cartData['item']}",
                                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                                style: TextStyle(fontSize: Dimensions.height12),
                                                                                                              )),
                                                                                                          SizedBox(width: Dimensions.widht20),
                                                                                                          Text("${cartData['Price']} LE", style: TextStyle(fontSize: Dimensions.height12)),
                                                                                                        ],
                                                                                                      ),
                                                                                                    );
                                                                                                  }).toList(),
                                                                                                );
                                                                                              }
                                                                                            },
                                                                                          ),
                                                                                          SizedBox(height: Dimensions.height50),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              // Icon(Icons.add, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              // SizedBox(width: Dimensions.widht15),
                                                                                              Text(
                                                                                                'Total Price: ${order['Total Service cost']}',
                                                                                                style: TextStyle(fontSize: Dimensions.height15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Text(
                                                                                            'Close',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  } else if (order['Service'] == 'Car Maintenance') {
                                                                                    return AlertDialog(
                                                                                      title: Container(
                                                                                        width: 10,
                                                                                        padding: EdgeInsets.all(5),
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.black,
                                                                                          borderRadius: BorderRadius.circular(20),
                                                                                        ),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'Order Receipt',
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      content: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          SizedBox(height: Dimensions.height10),
                                                                                          StreamBuilder<QuerySnapshot>(
                                                                                            stream: FirebaseFirestore.instance.collection('orders').doc("${FirebaseAuth.instance.currentUser?.email} - ${order['Date and Time']} - ${order['Service']}").collection('services').snapshots(),
                                                                                            builder: (context, snapshot) {
                                                                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                                return const Center(child: CircularProgressIndicator());
                                                                                              } else if (snapshot.hasError) {
                                                                                                return const Center(child: Text('Error fetching data'));
                                                                                              } else if (snapshot.data!.docs.isEmpty) {
                                                                                                return const Center(child: Text('No items found'));
                                                                                              } else {
                                                                                                return Column(
                                                                                                  children: snapshot.data!.docs.map((doc) {
                                                                                                    var cartData = doc.data() as Map<String, dynamic>;
                                                                                                    return Padding(
                                                                                                      padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "${cartData['task']}",
                                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.height13, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                                          ),
                                                                                                          // SizedBox(width: Dimensions.widht10),
                                                                                                          // Container(
                                                                                                          //   width: Dimensions.widht150,
                                                                                                          //   child: Text("${cartData['item']}",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:Dimensions.height12),)),
                                                                                                          SizedBox(width: Dimensions.widht15),
                                                                                                          Text("${cartData['price']} LE", style: TextStyle(fontSize: Dimensions.height12, fontWeight: FontWeight.bold)),
                                                                                                        ],
                                                                                                      ),
                                                                                                    );
                                                                                                  }).toList(),
                                                                                                );
                                                                                              }
                                                                                            },
                                                                                          ),
                                                                                          SizedBox(height: Dimensions.height50),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              // Icon(Icons.add, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              // SizedBox(width: Dimensions.widht15),
                                                                                              Text(
                                                                                                'Total Price: ${order['Total Service cost']}',
                                                                                                style: TextStyle(fontSize: Dimensions.height15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 224, 58, 58)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Text(
                                                                                            'Close',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  } else {
                                                                                    return AlertDialog(
                                                                                      title: Text('Unknown Service'),
                                                                                      content: Text('Details about the service are not available.'),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Text(
                                                                                            'Close',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  }
                                                                                },
                                                                              );
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'View Receipt',
                                                                              style: TextStyle(
                                                                                fontSize: Dimensions.height15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: const Color.fromARGB(255, 255, 255, 255),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Container()
                                                          ],
                                                        ),
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    'More',
                                                    style: TextStyle(
                                                      fontSize:
                                                          Dimensions.height15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: Dimensions.widht10),
                                                TextButton(
                                                  onPressed: () {
                                                    _launchPhoneCall();
                                                  },
                                                  child: Text(
                                                    'Contact us',
                                                    style: TextStyle(
                                                      fontSize:
                                                          Dimensions.height15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Date of order",
                                              style: TextStyle(
                                                fontSize: Dimensions.height15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              order['Date and Time'] ?? '',
                                              style: TextStyle(
                                                fontSize: Dimensions.height15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink();
                      });
            }
          },
        ),
      ),
    );
  }
}
