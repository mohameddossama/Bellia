import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/locationPicker.dart';
import 'package:fluttercourse/pages/orders.dart';
import 'package:fluttercourse/paymob/paymob_manager.dart';
import 'package:fluttercourse/util/dimensions.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CarWash extends StatefulWidget {
  final String subAdministrativeArea;
  final String street;
  const CarWash(
      {Key? key, required this.subAdministrativeArea, required this.street})
      : super(key: key);

  @override
  State<CarWash> createState() => _CarWashState();
}

class _CarWashState extends State<CarWash> {
  int selectedPackageIndex = -1; // Initially no package is selected
  int selectedPackageeIndex = -1; // Initially no package is selected
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTime? selectedDatee;
  TimeOfDay? selectedTimee;
  String? currentLocation;
  String currentTabName = 'our center';
  bool isLoading = false;
  List<Map<String, String>> OurCenterpackages = [
    {
      "title": "Quick Shine",
      "subtitle":
          "Thorough exterior wash,\nWheel cleaning included,\nHand drying for spot-free finish",
      "price": "100"
    },
    {
      "title": "Shine & Detail",
      "subtitle":
          "Comprehensive exterior wash,\nHand-applied wax treatment for enhanced shine and protection,\nMeticulous interior detailing  including vacuuming, upholstery shampooing, and leather conditioning",
      "price": "150"
    },
    {
      "title": "Ultimate Cleanse",
      "subtitle":
          "Complete interior and exterior rejuvenation Exterior wash with ,\nHigh-quality products,\nThorough undercarriage wash",
      "price": "200"
    }
  ];

  List<Map<String, String>> yourlocationpackages = [
    {
      "title": "On-the-Go Refresh",
      "subtitle":
          "Professional exterior wash at your doorstep ,\n Hand washing and drying ",
      "price": "100"
    },
    {
      "title": "VIP Mobile Spa",
      "subtitle":
          "Comprehensive exterior and interior cleaning,\nIncludes interior vacuming, window cleaning, and tire dressing",
      "price": "200"
    },
  ];

  String? fName;
  String? lName;
  String? mobile;

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

      fName = userData['first_name'] ?? '';

      lName = userData['last_name'] ?? '';

      mobile = userData['phone_number'] ?? '';

      setState(() {});
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  CollectionReference ourcenter =
      FirebaseFirestore.instance.collection('car wash: our center');

  Future<void> addUserc(BuildContext context) async {
    if (selectedPackageIndex != -1 &&
        selectedDate != null &&
        selectedTime != null) {
      String _addLeadingZero(int number) {
        return number < 10 ? '0$number' : '$number';
      }

      String getCurrentDateTimeString() {
        DateTime now = DateTime.now();

        String formattedDateTime =
            '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}  at '
            '${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)}';

        return formattedDateTime;
      }

      String formattedDateTime = getCurrentDateTimeString();
      Map<String, dynamic> userData = {
        'package_title': OurCenterpackages[selectedPackageIndex]["title"],
        'package_price': OurCenterpackages[selectedPackageIndex]["price"],
        'User first name': fName,
        'User last name': lName,
        'Phone number': mobile,
        'date': selectedDate!.toString(),
        'time': selectedTime!.toString(),
        'Date and Time': formattedDateTime,
        "tab": currentTabName,
        'Estimated time of arrival': '',
        'Status': 'Waiting confirmation',
        'Confirmed Status': 'Processing',
        "Payment Method": 'Cash',
        'Description(Optional)': '',
        'id': FirebaseAuth.instance.currentUser?.email
      };
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      ourcenter
          .doc(userEmail! +
              " - " +
              formattedDateTime +
              " - " +
              'car wash: our center')
          .set(userData)
          .then((value) {
        print("User Added");
        Navigator.of(context).pushReplacementNamed("homepage");
      }).catchError((error) => print("Failed to add user: $error"));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a package, date, and time.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> addorders(BuildContext context) async {
    if (selectedPackageIndex != -1 &&
        selectedDate != null &&
        selectedTime != null) {
      String _addLeadingZero(int number) {
        return number < 10 ? '0$number' : '$number';
      }

      String getCurrentDateTimeString() {
        DateTime now = DateTime.now();

        String formattedDateTime =
            '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}  at '
            '${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)}';

        return formattedDateTime;
      }

      String formattedDateTime = getCurrentDateTimeString();
      Map<String, dynamic> orderData = {
        'package_title': OurCenterpackages[selectedPackageIndex]["title"],
        'package_price': OurCenterpackages[selectedPackageIndex]["price"],
        'date': selectedDate!.toString(),
        'time': selectedTime!.toString(),
        'User first name': fName,
        'User last name': lName,
        'Car model': carModelController.text.trim(),
        'Car brand': carNameController.text.trim(),
        'Plate number': plateNumber.text,
        'Phone number': mobile,
        'Date and Time': formattedDateTime,
        "Service": "car wash: $currentTabName",
        'id': FirebaseAuth.instance.currentUser?.email,
        'Estimated time of arrival': '',
        'Status': 'Waiting confirmation',
        'Confirmed Status': 'Processing',
        "Payment Method": 'Cash',
        'Description(Optional)': '',
      };

      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      orders
          .doc((userEmail! +
              " - " +
              formattedDateTime +
              " - " +
              'car wash: our center'))
          .set(orderData)
          .then((value) {
        print("order Added");
        Navigator.of(context).pushReplacementNamed("homepage");
      }).catchError((error) => print("Failed to add user: $error"));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a package, date, and time.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  CollectionReference yourplace =
      FirebaseFirestore.instance.collection('car wash: your Place');

  Future<void> addUsery(BuildContext context) async {
    if (selectedPackageeIndex != -1 &&
        selectedDatee != null &&
        selectedTimee != null) {
      Map<String, dynamic> userData = {
        'package_title': yourlocationpackages[selectedPackageeIndex]["title"],
        'package_price': yourlocationpackages[selectedPackageeIndex]["price"],
        'date': selectedDatee!.toString(),
        'time': selectedTimee!.toString(),
        'Customers location': currentLocation,
        'Additional location info': '',
        'status': 'Waiting confirmation',
        "tab": currentTabName,
        'Estimated time of arrival': '',
        'Status': 'Waiting confirmation',
        'Confirmed Status': 'Processing',
        "Payment Method": 'Cash',
        'Description(Optional)': '',
      };

      String _addLeadingZero(int number) {
        return number < 10 ? '0$number' : '$number';
      }

      String getCurrentDateTimeString() {
        DateTime now = DateTime.now();

        String formattedDateTime =
            '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}  at '
            '${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)}';

        return formattedDateTime;
      }

      String formattedDateTime = getCurrentDateTimeString();
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      yourplace
          .doc(userEmail! +
              " - " +
              formattedDateTime +
              " - " +
              'car wash: your Place')
          .set(userData)
          .then((value) {
        print("User Added");
        Navigator.of(context).pushReplacementNamed("homepage");
      }).catchError((error) => print("Failed to add user: $error"));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a package, date, and time.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  CollectionReference orderss = FirebaseFirestore.instance.collection('orders');

  Future<void> addorderss(BuildContext context) async {
    if (selectedPackageeIndex != -1 &&
        selectedDatee != null &&
        selectedTimee != null) {
      String _addLeadingZero(int number) {
        return number < 10 ? '0$number' : '$number';
      }

      String getCurrentDateTimeString() {
        DateTime now = DateTime.now();

        String formattedDateTime =
            '${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}  at '
            '${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)}';

        return formattedDateTime;
      }

      String formattedDateTime = getCurrentDateTimeString();
      Map<String, dynamic> orderData = {
        'package_title': yourlocationpackages[selectedPackageeIndex]["title"],
        'package_price': yourlocationpackages[selectedPackageeIndex]["price"],
        'date': selectedDatee!.toString(),
        'time': selectedTimee!.toString(),
        'User first name': fName,
        'User last name': lName,
        'Phone number': mobile,
        'Car model': carModelController.text.trim(),
        'Car brand': carNameController.text.trim(),
        'Estimated time of arrival': '',
        'Status': 'Waiting confirmation',
        'Confirmed Status': 'Processing',
        "Payment Method": 'Cash',
        'Date and Time': formattedDateTime,
        'Location': currentLocation,
        'Land mark': additionalLocation.text.isNotEmpty
            ? additionalLocation.text.trim()
            : "",
        'Plate number': plateNumber.text,
        "Service": "car wash: $currentTabName",
        'Description(Optional)': '',
        'id': FirebaseAuth.instance.currentUser?.email
      };

      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      orderss
          .doc(userEmail! +
              " - " +
              formattedDateTime +
              " - " +
              'car wash: your Place')
          .set(orderData)
          .then((value) {
        print("order Added");
        Navigator.of(context).pushReplacementNamed("homepage");
      }).catchError((error) => print("Failed to add user: $error"));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a package, date, and time.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDatee(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDatee ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null && picked != selectedDatee) {
      _saveCache();
      setState(() {
        selectedDatee = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null && picked != selectedDate) {
      _saveCache();
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      _saveCache();
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _submit() {
    if (selectedPackageIndex != -1 &&
        selectedDate != null &&
        selectedTime != null) {
      _saveCache();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Selected Choices"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Package: ${OurCenterpackages[selectedPackageIndex]["title"]}"),
                Text(
                    "Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                Text("Time: ${selectedTime!.hour}:${selectedTime!.minute}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoading = false;
                  });
                  addUserc(context);
                  addorders(context);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => orderPage()));
                },
                child:
                    isLoading ? CircularProgressIndicator() : const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a package, date, and time.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitt() {
    if (selectedPackageeIndex != -1 &&
        selectedDatee != null &&
        selectedTimee != null) {
      _saveCache();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Selected Choices"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Package: ${yourlocationpackages[selectedPackageeIndex]["title"]}"),
                Text(
                    "Date: ${selectedDatee!.day}/${selectedDatee!.month}/${selectedDatee!.year}"),
                Text("Time: ${selectedTimee!.hour}:${selectedTimee!.minute}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  addUsery(context);
                  addorderss(context);
                  setState(() {
                    isLoading = false;
                  });
                  clearCache();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => orderPage()));
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a package, date, and time.',
            style: TextStyle(color: Colors.black),
          ),
          //backgroundColor: Colors.black,
        ),
      );
    }
  }

  Future<void> _selectTimee(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimee ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTimee) {
      _saveCache();
      setState(() {
        selectedTimee = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCars();
    currentLocation = '${widget.subAdministrativeArea} ${widget.street}';
    _loadCache();
  }

  Future<void> _loadCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedPackageIndex = prefs.getInt('selectedPackageIndex') ?? -1;
      selectedPackageeIndex = prefs.getInt('selectedPackageeIndex') ?? -1;
      final int? savedDateMillis = prefs.getInt('selectedDate');
      if (savedDateMillis != null) {
        selectedDate = DateTime.fromMillisecondsSinceEpoch(savedDateMillis);
      }
      final int? savedDateMillis2 = prefs.getInt('selectedDatee');
      if (savedDateMillis2 != null) {
        selectedDatee = DateTime.fromMillisecondsSinceEpoch(savedDateMillis2);
      }
      final int? savedTimeMillis = prefs.getInt('selectedTime');
      if (savedTimeMillis != null) {
        final hours = savedTimeMillis ~/ 60;
        final minutes = savedTimeMillis % 60;
        selectedTime = TimeOfDay(hour: hours, minute: minutes);
      }
      final int? savedTimeeMillis = prefs.getInt('selectedTimee');
      if (savedTimeeMillis != null) {
        final hours = savedTimeeMillis ~/ 60;
        final minutes = savedTimeeMillis % 60;
        selectedTimee = TimeOfDay(hour: hours, minute: minutes);
      }
      // selectedLocation = prefs.getString('selectedLocation');
    });
  }

  Future<void> _saveCache() async {
    print('save cache');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedPackageIndex', selectedPackageIndex);
    prefs.setInt('selectedPackageeIndex', selectedPackageeIndex);
    if (selectedDate != null) {
      prefs.setInt('selectedDate', selectedDate!.millisecondsSinceEpoch);
    }
    if (selectedDatee != null) {
      prefs.setInt('selectedDatee', selectedDatee!.millisecondsSinceEpoch);
    }
    if (selectedTime != null) {
      prefs.setInt(
          'selectedTime', selectedTime!.hour * 60 + selectedTime!.minute);
    }
    if (selectedTimee != null) {
      prefs.setInt(
          'selectedTimee', selectedTimee!.hour * 60 + selectedTimee!.minute);
    }
    //prefs.setString('selectedLocation', selectedLocation ?? '');
  }

  clearCache() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
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

  final TextEditingController additionalLocation = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController plateNumber = TextEditingController();

  Map<String, dynamic>? selectedCarData;
  List<Map<String, dynamic>> carsList = [];

  Future<void> fetchCars() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      print("No user logged in");
      return;
    }
    QuerySnapshot carSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('cars')
        .get();

    carsList = carSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    // if (carsList.isNotEmpty) {
    //   selectedCarData = carsList[0];
    //   updateTextFields();
    // }
    setState(() {});
  }

  void updateTextFields() {
    if (selectedCarData != null) {
      carNameController.text = selectedCarData!['car_brand'] ?? '';
      carModelController.text = selectedCarData!['car_model'] ?? '';
      // carColorController.text = selectedCarData!['car_color'] ?? '';
      plateNumber.text = selectedCarData!['plate_number'] ?? '';
    } else if (selectedCarData == null) {
      carNameController.text = "";
      carModelController.text = "";
      plateNumber.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
          title: const Text(
            "Car Wash Service",
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          bottom: TabBar(
            indicatorColor: Color.fromARGB(255, 197, 181, 181),
            indicatorWeight: 5,
            unselectedLabelStyle: TextStyle(
                fontSize: Dimensions.height10, fontWeight: FontWeight.bold),
            labelColor: Color.fromARGB(255, 255, 246, 246),
            tabs: [
              Tab(
                icon: Icon(Icons.build_circle_outlined),
                text: "Our Center",
              ),
              Tab(
                icon: Icon(Icons.add_location_alt_outlined),
                text: "Your Place",
              ),
            ],
            onTap: (index) {
              setState(() {
                currentTabName = index == 0 ? 'our center' : 'your Place';
              });
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: TabBarView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Packages",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: OurCenterpackages.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPackageIndex = i;
                              _saveCache();
                            });
                            Scaffold.of(context)
                                .showBottomSheet((BuildContext context) {
                              return Container(
                                padding: EdgeInsets.all(Dimensions.height10),
                                margin: EdgeInsets.all(0.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(Dimensions.height20),
                                      topRight:
                                          Radius.circular(Dimensions.height20)),
                                  color: Colors.grey[100],
                                ),
                                width: 500,
                                height: Dimensions.height500,
                                child: Column(
                                  children: [
                                    Center(
                                        child: Container(
                                      height: Dimensions.height10,
                                      width: Dimensions.widht45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(255, 59, 57, 57)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(""),
                                      ),
                                    )),
                                    SizedBox(height: Dimensions.height20,),
                                    Text(
                                      "Choose a car or register a new car",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color.fromARGB(
                                              255, 224, 58, 58)),
                                      child: Center(
                                        child: DropdownButton<
                                            Map<String, dynamic>>(
                                          focusColor: Colors.black,
                                          value: selectedCarData,
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedCarData = newValue;
                                              updateTextFields();
                                            });
                                          },
                                          items: [
                                            DropdownMenuItem<
                                                Map<String, dynamic>>(
                                              value: null,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.car_repair,
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    size: 25,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Add a new car",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 0, 0)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ...carsList.map<
                                                    DropdownMenuItem<
                                                        Map<String, dynamic>>>(
                                                (Map<String, dynamic> value) {
                                              return DropdownMenuItem<
                                                  Map<String, dynamic>>(
                                                value: value,
                                                child: Text(
                                                  value['plate_number'] ??
                                                      "Unknown Plate",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0)),
                                                ),
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: carNameController,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              hintText: 'Car Name',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              hintStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a car name';
                                              }
                                              return null;
                                            },
                                            onChanged: (_) {
                                              //setCache();
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: TextFormField(
                                            controller: carModelController,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              hintText: 'Car Model',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              hintStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a car model';
                                              }
                                              return null;
                                            },
                                            onChanged: (_) {
                                              // setCache();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    TextFormField(
                                      controller: plateNumber,
                                      textAlign: TextAlign.center,
                                      //keyboardType: TextInputType.te,
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter.allow(
                                      //       RegExp(r'[A-Za-z0-9 ]')),
                                      //   LengthLimitingTextInputFormatter(10),
                                      // ],
                                      decoration: InputDecoration(
                                        hintText: 'Plate Number e.g., ABC-1234',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the plate number';
                                        }
                                        RegExp plateExp =
                                            RegExp(r'^[A-Za-z]{1,3}-?\d{1,4}$');
                                        if (!plateExp.hasMatch(value)) {
                                          return 'Enter a valid plate format (e.g., ABC-1234)';
                                        }
                                        return null;
                                      },
                                      onChanged: (_) {
                                        //setCache();
                                      },
                                    ),
                                    SizedBox(
                                      height: Dimensions.height15,
                                    ),
                                    Container(
                                      width: Dimensions.widht250,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black),
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                        child: Text(
                                          selectedDate == null
                                              ? 'Select Date'
                                              : 'Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                                          style: TextStyle(
                                              fontSize: Dimensions.height17,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height10),
                                    Container(
                                      width: Dimensions.widht250,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black),
                                        onPressed: () {
                                          _selectTime(context);
                                        },
                                        child: Text(
                                          selectedTime == null
                                              ? 'Select Time'
                                              : 'Time: ${selectedTime!.hour}:${selectedTime!.minute}',
                                          style: TextStyle(
                                              fontSize: Dimensions.height17,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(height: 10),
                                    // ElevatedButton(
                                    //   onPressed: (){
                                    //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const location_picker_page(service_name: "maintenance")));
                                    //   },
                                    //   child: const Text('Select Location'),
                                    // ),

                                    SizedBox(height: Dimensions.height45),
                                    Container(
                                      width: Dimensions.widht200,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255, 224, 58, 58)),
                                        onPressed: () {
                                          //_pay();
                                          _submit();
                                        },
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                              fontSize: Dimensions.height20,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Dimensions.height10),
                            padding: EdgeInsets.all(Dimensions.height20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: selectedPackageIndex == i
                                  ? Colors.green[200]
                                  : Colors.grey[200],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  OurCenterpackages[i]["title"] ??
                                      "Title Not Available",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: Dimensions.height10),
                                Text(
                                  OurCenterpackages[i]["subtitle"] ??
                                      "Subtitle Not Available",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: Dimensions.height10),
                                Text(
                                  OurCenterpackages[i]["price"] ??
                                      "price Not Available",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  //SizedBox(height: Dimensions.height20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _selectDate(context);
                  //   },
                  //   child: Text(selectedDate == null
                  //       ? 'Select Date'
                  //       : 'Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                  // ),
                  // const SizedBox(height: 10),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _selectTime(context);
                  //   },
                  //   child: Text(selectedTime == null
                  //       ? 'Select Time'
                  //       : 'Time: ${selectedTime!.hour}:${selectedTime!.minute}'),
                  // ),
                  // // const SizedBox(height: 10),
                  // // ElevatedButton(
                  // //   onPressed: (){
                  // //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const location_picker_page(service_name: "maintenance")));
                  // //   },
                  // //   child: const Text('Select Location'),
                  // // ),
                  // const SizedBox(height: 20),
                  // const SizedBox(height: 20),
                  // ElevatedButton(
                  //   // style: ButtonStyle(backgroundColor: ),
                  //   onPressed: () {
                  //     _pay();
                  //     _submit();
                  //   },
                  //   child: const Text('Submit'),
                  // )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Packages",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Dimensions.height25),
                  Expanded(
                    child: ListView.builder(
                      itemCount: yourlocationpackages.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPackageeIndex = i;
                              _saveCache();
                              Scaffold.of(context)
                                  .showBottomSheet((BuildContext context) {
                                return SingleChildScrollView(
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(Dimensions.height10),
                                    margin: EdgeInsets.all(0.5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              Dimensions.height20),
                                          topRight: Radius.circular(
                                              Dimensions.height20)),
                                      color: Colors.grey[100],
                                    ),
                                    width: 500,
                                    height: Dimensions.height665,
                                    child: Column(
                                      children: [
                                        SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Center(
                                                  child: Container(
                                                height: Dimensions.height10,
                                                width: Dimensions.widht45,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 0)),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                               const Color.fromARGB(255, 59, 57, 57)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(""),
                                                ),
                                              )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: Dimensions.widht5,
                                                  ),
                                                  Text(
                                                    "Address",
                                                    style: TextStyle(
                                                        fontSize:
                                                            Dimensions.height17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 0, 0)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: Dimensions.height5),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 0.5)),
                                                width: Dimensions.widht350,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFF2F2F6)),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        location_picker_page(
                                                                          service_name:
                                                                              'wash',
                                                                        )));
                                                  },
                                                  child: Text(
                                                    maxLines: 2,
                                                    currentLocation == null
                                                        ? 'Select Location'
                                                        : currentLocation!,
                                                    style: TextStyle(
                                                        fontSize:
                                                            Dimensions.height17,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 0, 0)),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: Dimensions.height20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: Dimensions.widht5,
                                                  ),
                                                  Text(
                                                    "LandMark (optional)",
                                                    style: TextStyle(
                                                        fontSize:
                                                            Dimensions.height17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 0, 0)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: Dimensions.height5),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: additionalLocation,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                onChanged: (_) {
                                                  //setCache();
                                                },
                                                decoration: InputDecoration(
                                                  //contentPadding:EdgeInsets.only(top: 5),
                                                  hintText:
                                                      'Surrounding Landmarks',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  hintStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: Dimensions.height15),
                                              Text(
                                                "Choose a car or register a new car",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: const Color.fromARGB(
                                                        255, 224, 58, 58)),
                                                child: Center(
                                                  child: DropdownButton<
                                                      Map<String, dynamic>>(
                                                    focusColor: Colors.black,
                                                    value: selectedCarData,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedCarData =
                                                            newValue;
                                                        updateTextFields();
                                                      });
                                                    },
                                                    items: [
                                                      DropdownMenuItem<
                                                          Map<String, dynamic>>(
                                                        value: null,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.car_repair,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255, 0, 0, 0),
                                                              size: 25,
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(
                                                              "Add a new car",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      0,
                                                                      0,
                                                                      0)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      ...carsList.map<
                                                              DropdownMenuItem<
                                                                  Map<String,
                                                                      dynamic>>>(
                                                          (Map<String, dynamic>
                                                              value) {
                                                        return DropdownMenuItem<
                                                            Map<String,
                                                                dynamic>>(
                                                          value: value,
                                                          child: Text(
                                                            value['plate_number'] ??
                                                                "Unknown Plate",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0)),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          carNameController,
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Car Name',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter a car name';
                                                        }
                                                        return null;
                                                      },
                                                      onChanged: (_) {
                                                        //setCache();
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          carModelController,
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Car Model',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter a car model';
                                                        }
                                                        return null;
                                                      },
                                                      onChanged: (_) {
                                                        // setCache();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              TextFormField(
                                                controller: plateNumber,
                                                textAlign: TextAlign.center,
                                                //keyboardType: TextInputType.te,
                                                // inputFormatters: [
                                                //   FilteringTextInputFormatter.allow(
                                                //       RegExp(r'[A-Za-z0-9 ]')),
                                                //   LengthLimitingTextInputFormatter(10),
                                                // ],
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Plate Number e.g., ABC-1234',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter the plate number';
                                                  }
                                                  RegExp plateExp = RegExp(
                                                      r'^[A-Za-z]{1,3}-?\d{1,4}$');
                                                  if (!plateExp
                                                      .hasMatch(value)) {
                                                    return 'Enter a valid plate format (e.g., ABC-1234)';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (_) {
                                                  //setCache();
                                                },
                                              ),
                                              SizedBox(
                                                height: Dimensions.height10,
                                              ),
                                              Container(
                                                width: Dimensions.widht200,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.black),
                                                  onPressed: () {
                                                    _selectDatee(context);
                                                    _saveCache();
                                                  },
                                                  child: Text(
                                                    selectedDatee == null
                                                        ? 'Select Date'
                                                        : 'Date: ${selectedDatee!.day}/${selectedDatee!.month}/${selectedDatee!.year}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            Dimensions.height17,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                width: Dimensions.widht200,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.black),
                                                  onPressed: () {
                                                    _selectTimee(context);
                                                    _saveCache();
                                                  },
                                                  child: Text(
                                                    selectedTimee == null
                                                        ? 'Select Time'
                                                        : 'Time: ${selectedTimee!.hour}:${selectedTimee!.minute}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            Dimensions.height17,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: Dimensions.height45),
                                        Container(
                                          width: Dimensions.widht200,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 224, 58, 58)),
                                            onPressed: _submitt,
                                            child: Text(
                                              'Submit',
                                              style: TextStyle(
                                                  fontSize: Dimensions.height20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Dimensions.height20),
                            padding: EdgeInsets.all(Dimensions.height20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: selectedPackageeIndex == i
                                  ? Colors.green[200]
                                  : Colors.grey[200],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  yourlocationpackages[i]["title"] ??
                                      "title Not Available",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  yourlocationpackages[i]["subtitle"] ??
                                      "Subtitle Not Available",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  yourlocationpackages[i]["price"] ??
                                      "price Not Available",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
