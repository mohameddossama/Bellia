//import 'package:fluttercourse/pages/carWash.dart';
import 'package:fluttercourse/pages/checkout.dart';
import 'package:fluttercourse/pages/roadSideAssistance.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class location_picker_page extends StatefulWidget {
  final String service_name;
 
  const location_picker_page({super.key, required this.service_name,});

  @override
  State<location_picker_page> createState() => _location_picker_pageState();
}

class _location_picker_pageState extends State<location_picker_page> {
  double bellia_long = 29.909494;
  double bellia_lat = 31.208805;
  double? customer_long;
  double? customer_lat;
  String? country;
  String? administrativeArea;
  String? subAdministrativeArea;
  String? street;
  String? locality;
  String? subLocality;
  TextEditingController country_controller = TextEditingController();
  TextEditingController administrativeArea_controller = TextEditingController();
  TextEditingController subAdministrativeArea_controller =
      TextEditingController();
  TextEditingController street_controller = TextEditingController();
  TextEditingController locality_controller = TextEditingController();

  CameraPosition? init_camera_position;

  Position? position;

  GoogleMapController? gm_controller;

  List<Marker> marks = [
    // Marker(markerId: MarkerId("1"), position: LatLng(30.028306, 31.273045)),
  ];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("==================");
    print(
        "current lat: ${position!.latitude} current long: ${position!.longitude}");
    print("==================");

    setState(() {
      customer_long = position!.longitude;
      customer_lat = position!.latitude;
      init_camera_position = CameraPosition(
        target: LatLng(customer_lat ?? 0, customer_long ?? 0),
        zoom: 14,
      );
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    _determinePosition();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    gm_controller
        ?.dispose(); // Use the null-aware operator ?. to safely call dispose
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Location",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   isExtended: true,
        //   child: Text(
        //     "Select Location",
        //     style: TextStyle(color: Colors.white),
        //     textAlign: TextAlign.center,
        //   ),
        //   backgroundColor: const Color.fromARGB(255, 224, 58, 58),
        //   onPressed: () {
        //     // if service name = "roadside assistance" then navigate to roadside assistance service page
        //     // if service name = "e-store" then navigate to roadside customer info page
        //     // if service name = "car wash" then navigate to car wash service page
        //   },
        // ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: init_camera_position ??
                  CameraPosition(
                      target: LatLng(bellia_lat, bellia_long), zoom: 14),
              markers: marks.toSet(),
              mapType: MapType.normal,
              indoorViewEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              compassEnabled: true,
              onMapCreated: (controller) {
                gm_controller = controller;
              },
              onTap: (argument) async {
                print("======================");
                print(
                    "lat is ${argument.latitude} and long is ${argument.longitude}");
                print("======================");
                marks.add(Marker(
                    markerId: const MarkerId("1"),
                    position: LatLng(argument.latitude, argument.longitude)));
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    argument.latitude, argument.longitude);
                print("country is: ${placemarks[0].country}");
                print("street is: ${placemarks[0].street}");
                print(
                    "administrativeArea is: ${placemarks[0].administrativeArea}");
                print(
                    "subAdministrativeArea is: ${placemarks[0].subAdministrativeArea}");
                print("locality is: ${placemarks[0].locality}");
                print("subLocality is: ${placemarks[0].subLocality}");

                country = placemarks[0].country;
                administrativeArea = placemarks[0].administrativeArea;
                subAdministrativeArea = placemarks[0].subAdministrativeArea;
                street = placemarks[0].street;
                locality = placemarks[0].locality;
                subLocality = placemarks[0].subLocality;

                setState(() {});
              },
            ),
            Container(
              alignment: Alignment.topCenter,
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.map_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${country ?? ""} ${administrativeArea ?? ""}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${subAdministrativeArea ?? ""} ${street ?? ""}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin:
                  const EdgeInsets.only(top: 0, bottom: 8, right: 8, left: 8),
              child: MaterialButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                minWidth: 200,
                onPressed: () {
                  print("niggggggggggggggga is $subAdministrativeArea");
                  if(widget.service_name == 'mart'){
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Checkout(subAdministrativeArea: subAdministrativeArea ?? "", street: street ?? "", itemDetailsList: [] ,)));
                  }
                  if(widget.service_name == 'road'){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoadSideAssistance(subAdministrativeArea: subAdministrativeArea ?? "", street: street ?? "")));
                  }
                  // if(widget.service_name == 'wash'){
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => CarWash(subAdministrativeArea: subAdministrativeArea ?? "", street: street ?? "")));
                  // }
                  if (country == null &&
                      administrativeArea == null &&
                      subAdministrativeArea == null &&
                      street == null &&
                      locality == null &&
                      subLocality == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Please Select a Location"),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(label: "Ok", onPressed: () {}),
                    ));
                  } else {
                    // if service name = "roadside assistance" then navigate to ...
                    //if service name = "car wash" then navigate to ...
                    //if service name = "e-store" then navigate to ...
                  }
                },
                child: const Text(
                  "Select Location",
                  style: TextStyle(color: Colors.white),
                ),
                color: const Color.fromARGB(255, 224, 58, 58),
              ),
            ),
            Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(
                    top: 430, bottom: 0, right: 15, left: 0),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        init_camera_position = CameraPosition(
                          target: LatLng(customer_lat!, customer_long!),
                          zoom: 14,
                        );
                      });
                    },
                    icon: const Icon(
                      Icons.my_location_rounded,
                      size: 37,
                      color: Color.fromARGB(255, 224, 58, 58),
                    ))),
          ],
        ));
  }
}
