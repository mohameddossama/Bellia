import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/locationPicker.dart';
import 'package:fluttercourse/pages/orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      "price": "30 EGP"
    },
    {
      "title": "Shine & Detail",
      "subtitle":
          "Comprehensive exterior wash,\nHand-applied wax treatment for enhanced shine and protection,\nMeticulous interior detailing  including vacuuming, upholstery shampooing, and leather conditioning",
      "price": "60 EGP"
    },
    {
      "title": "Ultimate Cleanse",
      "subtitle":
          "Complete interior and exterior rejuvenation Exterior wash with ,\nHigh-quality products,\nThorough undercarriage wash",
      "price": "100 EGP"
    }
  ];

  List<Map<String, String>> yourlocationpackages = [
    {
      "title": "On-the-Go Refresh",
      "subtitle":
          "Professional exterior wash at your doorstep ,\n Hand washing and drying ",
      "price": "50 EGP"
    },
    {
      "title": "VIP Mobile Spa",
      "subtitle":
          "Comprehensive exterior and interior cleaning ,\n Includes interior vacuuming, window cleaning, and tire dressing",
      "price": "80 EGP"
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
        "Payment Method": '',
        'Description(Optional)':'',
        'id': FirebaseAuth.instance.currentUser?.email
      };
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      ourcenter
          .doc(userEmail! + " - " + formattedDateTime + " - " +'car wash: our center')
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
        'Phone number': mobile,
        'Date and Time': formattedDateTime,
        "Service": "car wash: $currentTabName",
        'id': FirebaseAuth.instance.currentUser?.email,
        'Estimated time of arrival': '',
        'Status': 'Waiting confirmation',
        'Confirmed Status': 'Processing',
        "Payment Method": '',
        'Description(Optional)':'',
      };

      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      orders
          .doc((userEmail! + " - " + formattedDateTime + " - " +'car wash: our center'))
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
      FirebaseFirestore.instance.collection('car wash: your place');

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
        "Payment Method": '',
        'Description(Optional)':'',
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
          .doc(userEmail! + " - " + formattedDateTime + " - " +'car wash: your place')
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
        'package_title': OurCenterpackages[selectedPackageeIndex]["title"],
        'package_price': OurCenterpackages[selectedPackageeIndex]["price"],
        'date': selectedDatee!.toString(),
        'time': selectedTimee!.toString(),
        'User first name': fName,
        'User last name': lName,
        'Phone number': mobile,
        'Estimated time of arrival': '',
        'Status': 'Waiting confirmation',
        'Confirmed Status': 'Processing',
        "Payment Method": '',
        'Date and Time': formattedDateTime,
        'Customers location': currentLocation,
        'Additional location info': '',
        "Service": "car wash: $currentTabName",
        'Description(Optional)':'',
        'id': FirebaseAuth.instance.currentUser?.email
      };

      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      orderss
          .doc(userEmail! + " - " + formattedDateTime + " - " +'car wash: your place')
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
            style: TextStyle(color: Color.fromARGB(255, 255, 20, 3)),
          ),
          backgroundColor: Colors.black,
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
            unselectedLabelStyle: TextStyle(fontSize: 9),
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
          padding: const EdgeInsets.all(20),
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
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(20),
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
                                const SizedBox(height: 10),
                                Text(
                                  OurCenterpackages[i]["subtitle"] ??
                                      "Subtitle Not Available",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(selectedDate == null
                        ? 'Select Date'
                        : 'Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: Text(selectedTime == null
                        ? 'Select Time'
                        : 'Time: ${selectedTime!.hour}:${selectedTime!.minute}'),
                  ),
                  // const SizedBox(height: 10),
                  // ElevatedButton(
                  //   onPressed: (){
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const location_picker_page(service_name: "maintenance")));
                  //   },
                  //   child: const Text('Select Location'),
                  // ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  )
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
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: yourlocationpackages.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPackageeIndex = i;
                              _saveCache();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _selectDatee(context);
                      _saveCache();
                    },
                    child: Text(selectedDatee == null
                        ? 'Select Date'
                        : 'Date: ${selectedDatee!.day}/${selectedDatee!.month}/${selectedDatee!.year}'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _selectTimee(context);
                      _saveCache();
                    },
                    child: Text(selectedTimee == null
                        ? 'Select Time'
                        : 'Time: ${selectedTimee!.hour}:${selectedTimee!.minute}'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => location_picker_page(
                                service_name: 'wash',
                              )));
                    },
                    child: Text(currentLocation == null
                        ? 'Select Location'
                        : currentLocation!),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitt,
                    child: Text('Submit'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
