//import 'dart:js_util';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/pages/orders.dart';
import 'package:fluttercourse/util/dimensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:get/get.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(Maintenance());
// }

class CustomIcons {
  static const IconData pipe = IconData(0xe7f4, fontFamily: 'CustomIcons');
}

class Maintenance extends StatefulWidget {
  const Maintenance({super.key});

  @override
  State<Maintenance> createState() => _MaintenanceState();

  static add(param0) {}
}

class _MaintenanceState extends State<Maintenance> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  List<Map<String, dynamic>> maintenanceTasks = [
    {"task": "Tire Replacement and repairs", "image": "assets/icons/tire.png"},
    {"task": "Suspentions inspection", "image": "assets/icons/suspentions.png"},
    {"task": "Brake system maintenance", "image": "assets/icons/brake.png"},
    {"task": "Oil Change", "image": "assets/icons/oil.png"},
    {"task": "Electronics inspection", "image": "assets/icons/electronics.png"},
    // {"task": "Transmission Service", "icon": carTransmissionIcon,"image": "images/air.png"},
    // {"task": "Diagnostic Services", "icon": diagnosticServicesIcon,"image": "images/air.png"},
    {
      "task": "Air and oil Filter Replacement",
      "image": "assets/icons/filter.png"
    },
    // {"task": "Cooling System Service", "icon": coolingSystemServiceIcon,"image": "images/air.png"},
    {"task": "Steering System maintenance", "image": "assets/icons/wheel.png"},
    {
      "task": "Battery Testing and Replacement",
      "image": "assets/icons/battery.png"
    },
    // {"task": "Wheel Alignment and Balancing", "icon": wheelAlignmentIcon,"image": "images/wheel.png"},
    {"task": "Routine Maintenance", "image": "assets/icons/routine.png"},
    {
      "task": "Engin Cooling maintenance",
      "image": "assets/icons/carCooling.png"
    },
    {"task": "Air Conditior maintenance", "image": "assets/icons/air.png"},
    {
      "task": "Exhausted System maintenance ",
      "image": "assets/icons/exhaust.png"
    },
  ];

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController remarksController = TextEditingController(text: '');
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController =
      TextEditingController(text: 'Waiting confirmation');
  final TextEditingController servicePriceController =
      TextEditingController(text: '0');
  final TextEditingController arabicController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController service = TextEditingController();
  final TextEditingController plateNumber = TextEditingController();
  final List<String> divingLicenseValues = [];
  late SharedPreferences pref;

  List<bool> isSelected = List.generate(12, (index) => false);
  int selectedItemIndex = -1;

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
      if (firstNameController.text.isEmpty) {
        firstNameController.text = userData['first_name'] ?? '';
      }
      if (lastNameController.text.isEmpty) {
        lastNameController.text = userData['last_name'] ?? '';
      }
      if (mobileNumberController.text.isEmpty) {
        mobileNumberController.text = userData['phone_number'] ?? '';
      }
      setState(() {});
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

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
      //carColorController.text = selectedCarData!['car_color'] ?? '';
      plateNumber.text = selectedCarData!['plate_number'] ?? '';
    } else if (selectedCarData == null) {
      carNameController.text = "";
      carModelController.text = "";
      plateNumber.text = "";
    }
  }

  CollectionReference CarMaintenance =
      FirebaseFirestore.instance.collection('Car Maintenance');

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  bool isLoading = false;
  Future<void> addService() async {
    if (
        formState.currentState != null &&
        formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});

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
        DocumentReference userDocRef =
            CarMaintenance.doc(userEmail! + " - " + formattedDateTime+ " - " + 'Car Maintenance');

        await userDocRef.set({
          "User first name": firstNameController.text,
          "User last name": lastNameController.text,
          "Car model": carModelController.text,
          "Car brand": carNameController.text,
          "Phone number": mobileNumberController.text,
          "Description(Optional)": remarksController.text,
          'Location':'',
          "Status": statusController.text,
          'Confirmed Status':'Processing',
          "Plate number": plateNumber.text,
          'Date and Time': formattedDateTime,
          'Service': 'Car Maintenance',
          "Payment Method": '',
          'Total Service cost':'',
        });
        DocumentReference orderDocRef =
            orders.doc(userEmail + " - " + formattedDateTime+ " - " + 'Car Maintenance');

        await orderDocRef.set({
          "User first name": firstNameController.text,
          "User last name": lastNameController.text,
          "Car model": carModelController.text,
          "Car brand": carNameController.text,
          "Phone number": mobileNumberController.text,
          "Description(Optional)": remarksController.text,
          'Location':'123 Ahmed Hamdy Street',
          "Status": statusController.text,
          'Confirmed Status':'Processing',
          "Plate number": plateNumber.text,
          'Date and Time': formattedDateTime,
          'Service': 'Car Maintenance',
          "Payment Method": '',
          'Estimated time of arrival':'20 min',
          'Total Service cost':'',
        });


        List<String> selectedTasks = [];
        for (int index = 0; index < isSelected.length; index++) {
          if (isSelected[index]) {
            selectedTasks.add(maintenanceTasks[index]['task']);
          }
        }

        for (String task in selectedTasks) {
          await userDocRef.collection('services').doc(task).set({
            'task': task,
            'price': '', 
          });
          await orderDocRef.collection('services').doc(task).set({
            'task': task,
            'price': '', 
          });
        }

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const orderPage()));
      } catch (e) {
        isLoading = false;
        setState(() {});
        print("Failed to add service: $e");
      }
    } else {
      print("Form state is null or invalid");
    }
  }

  // void insertSubCollection() async {
  //   var carMaintenanceCollection =
  //       FirebaseFirestore.instance.collection('Car Maintenance');
  //   var querySnapshot = await carMaintenanceCollection.get();

  //   for (var document in querySnapshot.docs) {
  //     var servicesCollection =
  //         carMaintenanceCollection.doc(document.id).collection('Services');
  //     await servicesCollection.add({
  //       'Service': servicesCollection,
  //     });
  //   }
  // }

  // List<QueryDocumentSnapshot> data = [];

  // getData() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("Car Maintenance")
  //       .where("ID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   data.addAll(querySnapshot.docs);

  //   setState(() {});
  // }

  Future<void> saveSelectedItems(List<bool> isSelected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> selectedIndices = isSelected
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => entry.key.toString())
        .toList();
    await prefs.setStringList('selectedIndices', selectedIndices);
  }

  Future<void> loadSelectedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? selectedIndices = prefs.getStringList('selectedIndices');
    if (selectedIndices != null) {
      setState(() {
        for (int i = 0; i < isSelected.length; i++) {
          isSelected[i] = selectedIndices.contains(i.toString());
        }
      });
    }
  }

   getCache() async {
    pref = await SharedPreferences.getInstance();
    if (carNameController.text.isEmpty || carNameController.text == "") {
      carNameController.text = pref.getString('carNameMAintenance') ?? '';
    }
    if (carModelController.text.isEmpty || carModelController.text == "") {
      carModelController.text = pref.getString('carModelMAintenance') ?? '';
    }
    if (plateNumber.text.isEmpty || plateNumber.text == "") {
      plateNumber.text = pref.getString('plateNumberMAintenance') ?? '';
    }
    if (firstNameController.text.isEmpty) {
      firstNameController.text = pref.getString('firstNameMAintenance') ?? '';
    }
    if (lastNameController.text.isEmpty) {
      lastNameController.text = pref.getString('lastNameMAintenance') ?? '';
    }
    if (mobileNumberController.text.isEmpty) {
      mobileNumberController.text = pref.getString('mobileMAintenance') ?? '';
    }
    
    if (remarksController.text.isEmpty) {
      remarksController.text = pref.getString('issueMAintenance') ?? '';
    }
    print('cache get');
  }

  setCache() async {
    pref.setString('carNameMAintenance', carNameController.text);
    pref.setString('carModelMAintenance', carModelController.text);
    pref.setString('plateNumberMAintenance', plateNumber.text);
    pref.setString('firstNameMAintenance', firstNameController.text);
    pref.setString('lastNameMAintenance', lastNameController.text);
    pref.setString('mobileMAintenance', mobileNumberController.text);
    pref.setString('issueMAintenance', remarksController.text);
    print('cache set');
  }

  clearCache() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await pref.clear();
    await prefs.clear();
  }

  @override
  void initState() {
    fetchUserData();
    fetchCars();
    loadSelectedItems();
    getCache();
    //getData();
    //insertSubCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
          //centerTitle: true,
          title: const Text(
            "Car Maintenacne",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(
                  builder: (context) => const CommerceHome()));
            },
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: formState,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 3.0,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 3.0,
                        ),
                        itemCount: maintenanceTasks.length,
                        // + data.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected[index] = !isSelected[index];
                                selectedItemIndex = index;
                                saveSelectedItems(isSelected);
                              });
                            },
                            // child: Card(
                            //   // color: isSelected[index]
                            //   //     ? const Color.fromARGB(255, 252, 142, 142)
                            //   //     :
                            //  color: const Color.fromARGB(255, 209, 205, 205),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromARGB(
                                        255, 209, 205, 205),
                                    border: Border.all(
                                        color: isSelected[index]
                                            ? const Color.fromARGB(
                                                255, 247, 4, 4)
                                            : const Color.fromARGB(
                                                255, 209, 205, 205),
                                        width: 4)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      maintenanceTasks[index]['image'],
                                      height: 38,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      maintenanceTasks[index]['task'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Center(
                                    //   child: Text('Item ${index + 1}'),
                                    // ),
                                    // Text(
                                    //     "First Name: ${data[index]['first name']}"),
                                    // Text(
                                    //     "Last Name: ${data[index]['last name']}"),
                                    // Text(
                                    //     "Car Model: ${data[index]['Car Model']}"),
                                    // Text(
                                    //     "Car Brand: ${data[index]['Car Brand']}"),
                                    // Text(
                                    //     "Phone Number: ${data[index]['Phone Number']}"),
                                    // Text(
                                    //     "Description: ${data[index]['Description']}"),
                                    // Text("Status: ${data[index]['Status']}"),
                                    // Text(
                                    //     "Service Price: ${data[index]['Service price']}"),
                                  ],
                                ),
                              ),
                            ),
                            // ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                               onChanged: (_){setCache();},
                              controller: firstNameController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                               onChanged: (_){setCache();},
                              controller: lastNameController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                         onChanged: (_){setCache();},
                        controller: mobileNumberController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Choose a car or register a new car",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 224, 58, 58)),
                        child: Center(
                          child: DropdownButton<Map<String, dynamic>>(
                            focusColor: Colors.black,
                            value: selectedCarData,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCarData = newValue;
                                updateTextFields();
                              });
                            },
                            items: [
                              DropdownMenuItem<Map<String, dynamic>>(
                                value: null,
                                child:  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.car_repair,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  size: 25,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Add a new car",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ],
                            ),
                              ),
                              ...carsList
                                  .map<DropdownMenuItem<Map<String, dynamic>>>(
                                      (Map<String, dynamic> value) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: value,
                                  child: Text(
                                    value['plate_number'] ?? "Unknown Plate",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
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
                              onChanged: (_){setCache();},
                              controller: carNameController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: 'Car Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              onChanged: (_){setCache();},
                              controller: carModelController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: 'Car Model',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        onChanged: (_){setCache();},
                        controller: plateNumber,
                        textAlign: TextAlign.center,
                        //keyboardType: TextInputType.te,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //       RegExp(r'[A-Za-z0-9 ]')),
                        //   LengthLimitingTextInputFormatter(10),
                        // ],
                        decoration: InputDecoration(
                          labelText: 'Plate Number',
                          hintText: 'e.g., ABC-1234',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the plate number';
                          }
                          RegExp plateExp = RegExp(r'^[A-Za-z]{1,3}-?\d{1,4}$');
                          if (!plateExp.hasMatch(value)) {
                            return 'Enter a valid plate format (e.g., ABC-1234)';
                          }
                          return null;
                        },
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       flex: 2,
                      //       child: TextFormField(
                      //         controller: arabicController,
                      //         textAlign: TextAlign.center,
                      //         inputFormatters: [
                      //           LengthLimitingTextInputFormatter(5),
                      //         ],
                      //         decoration: InputDecoration(
                      //           labelText: 'س ب ت',
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(15.0),
                      //           ),
                      //           labelStyle:
                      //               const TextStyle(fontWeight: FontWeight.bold),
                      //         ),
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'Please enter an Arabic value';
                      //           }
                      //           return null;
                      //         },
                      //       ),
                      //     ),
                      //     const SizedBox(width: 16),
                      //     Expanded(
                      //       flex: 2,
                      //       child: TextFormField(
                      //         keyboardType: TextInputType.number,
                      //         controller: numberController,
                      //         textAlign: TextAlign.center,
                      //         inputFormatters: [
                      //           FilteringTextInputFormatter.allow(
                      //               RegExp(r'[0-9]')),
                      //           LengthLimitingTextInputFormatter(4),
                      //         ],
                      //         decoration: InputDecoration(
                      //           labelText: '5 6 3',
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(15.0),
                      //           ),
                      //           labelStyle:
                      //               const TextStyle(fontWeight: FontWeight.bold),
                      //         ),
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'Please enter a number';
                      //           }
                      //           return null;
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // )
                      const SizedBox(height: 10),
                      TextField(
                        onChanged: (_){setCache();},
                        keyboardType: TextInputType.text,
                        controller: remarksController,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Remarks (optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 40.0),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 10.0,
                          ),
                          alignLabelWithHint: true,
                          prefixIcon: const SizedBox(width: 10),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          addService();
                          // Navigator.of(context).pushReplacement(MaterialPageRoute(
                          //     builder: (context) => const orderPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 224, 58, 58),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
