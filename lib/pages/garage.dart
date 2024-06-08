import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/pages/orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> garageTasks = [
  {
    'title': 'Gold',
    'price': 1000,
    'color':
        Color.fromARGB(255, 211, 172, 57).withOpacity(0.6), // Adjusted color
    'imagePath': 'assets/icons/gold.png',
    'additionalText': [
      ' Washed once every week (interior + exterior)',
      ' Covered with a Special Inflatable Capsule Car Bubble Cover',
      ' Special Routine Check before parking the car',
      ' Rodent prevention',
      ' Car cover by a standard cover',
      ' Car picture sent on Request',
      ' Car maintenance (fluid checks, battery maintenance, tire pressure, fuel stabilizer)'
    ],
    'starImagePath': 'assets/icons/star.png',
  },
  {
    'title': 'Silver',
    'price': 750,
    'color': const Color.fromARGB(255, 97, 95, 95)
        .withOpacity(0.6), // Adjusted color
    'imagePath': 'assets/icons/silverm.png',
    'additionalText': [
      ' Washed once every Two weeks (exterior only)',
      ' Fluid checks',
      ' Rodent prevention',
      ' Car coverd with a standard cover',
      ' Car picture sent on Request',
      ' Car maintenance (fluid checks, battery maintenance, tire pressure, fuel stabilizer)'
    ],
    'starImagePath': 'assets/icons/silver.png',
  },
  {
    'title': 'Bronze',
    'price': 500,
    'color':
        Color.fromARGB(255, 114, 47, 25).withOpacity(0.6), 
    'imagePath': 'assets/icons/bronzem.png',
    'additionalText': [
      ' Car cover with a standard cover',
      ' Car picture sent on Request',
      ' Car maintenance (fluid checks, battery maintenance, tire pressure, fuel, stabilizer)'
    ],
    'starImagePath': 'assets/icons/bronze.png',
  },
];

class UserData {
  String firstName;
  String lastName;
  String carName;
  String carModel;
  String mobileNumber;
  List<String> divingLicense;
  String numberOfWeeks;
  String selectedService;
  int price;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.carName,
    required this.carModel,
    required this.mobileNumber,
    required this.divingLicense,
    required this.numberOfWeeks,
    required this.selectedService,
    required this.price,
  });
}

class Garage extends StatefulWidget {
  const Garage({super.key});

  @override
  State<Garage> createState() => _GarageState();
}

class _GarageState extends State<Garage> {
  // Controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController arabicController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController plateNumber = TextEditingController();

  bool isLoading = false;
  late SharedPreferences pref;
  final _formKey = GlobalKey<FormState>();

  getCache() async {
    pref = await SharedPreferences.getInstance();
    if (carNameController.text.isEmpty || carNameController.text == "") {
      carNameController.text = pref.getString('carNameGarage') ?? '';
    }
    if (carModelController.text.isEmpty || carModelController.text == "") {
      carModelController.text = pref.getString('carModelGarage') ?? '';
    }
    if (plateNumber.text.isEmpty || plateNumber.text == "") {
      plateNumber.text = pref.getString('plateNumberGarage') ?? '';
    }
    if (firstNameController.text.isEmpty) {
      firstNameController.text = pref.getString('firstNameGarage') ?? '';
    }
    if (lastNameController.text.isEmpty) {
      lastNameController.text = pref.getString('lastNameGarage') ?? '';
    }
    if (mobileNumberController.text.isEmpty) {
      mobileNumberController.text = pref.getString('mobileGarage') ?? '';
    }
    selectedCardIndex = pref.getInt('selectedCardIndex') ?? -1;
    selectedWeek = pref.getString('selectedWeek') ?? '1';
    setState(() {});
    print('cache get');
  }

  setCache() async {
    pref.setString('carNameGarage', carNameController.text);
    pref.setString('carModelGarage', carModelController.text);
    pref.setString('plateNumberGarage', plateNumber.text);
    pref.setString('firstNameGarage', firstNameController.text);
    pref.setString('lastNameGarage', lastNameController.text);
    pref.setString('mobileGarage', mobileNumberController.text);
    print('cache set');
  }

  clearCache() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  List<String> divingLicenseValues = ["", ""];

  final List<String> weeks =
      List.generate(50, (index) => (index + 1).toString());

  String selectedWeek = '1';
  int selectedCardIndex = -1;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    arabicController.dispose();
    numberController.dispose();
    carNameController.dispose();
    carModelController.dispose();
    super.dispose();
  }

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
      // carColorController.text = selectedCarData!['car_color'] ?? '';
      plateNumber.text = selectedCarData!['plate_number'] ?? '';
    } else {
      carNameController.text = "";
      carModelController.text = "";
      plateNumber.text = "";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    getCache();
    fetchCars();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(
                  builder: (context) => const CommerceHome()));
            },
          ),
          title: const Row(
            children: [
              SizedBox(width: 16), // Adjust as needed
              Expanded(
                child: Text(
                  'Garage ',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: garageTasks.length,
                  itemBuilder: (context, index) {
                    return ServiceCard(
                      title: garageTasks[index]['title'],
                      price: garageTasks[index]['price'].toString(),
                      color: garageTasks[index]['color'],
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 200,
                      isSelected: selectedCardIndex == index,
                      onSelect: (isSelected) {
                        setState(() {
                          selectedCardIndex = isSelected ? index : -1;
                          pref.setInt('selectedCardIndex', selectedCardIndex);
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: TextFormField(
                          controller: firstNameController,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setCache();
                          },
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Center(
                        child: TextFormField(
                          controller: lastNameController,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setCache();
                          },
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: mobileNumberController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a mobile number';
                    } else if (value.length < 11) {
                      return 'Please enter 11 digits';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setCache();
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  "Choose a car or register a new car",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                          child: Text(
                            "Add a new car",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                        ...carsList.map<DropdownMenuItem<Map<String, dynamic>>>(
                            (Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Text(
                              value['plate_number'] ?? "Unknown Plate",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: TextFormField(
                          controller: carNameController,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a car name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setCache();
                          },
                          decoration: InputDecoration(
                            labelText: 'Car Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Center(
                        child: TextFormField(
                          controller: carModelController,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a car model';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setCache();
                          },
                          decoration: InputDecoration(
                            labelText: 'Car Model',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 10),
                // const Text(
                //   'Plate Number',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
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
                  onChanged: (value) {
                    setCache();
                  },
                ),
                // const SizedBox(height: 15),
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
                //           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                // ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Number of weeks',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton(
                      items: weeks
                          .map((item) =>
                              DropdownMenuItem(value: item, child: Text(item)))
                          .toList(),
                      value: selectedWeek,
                      borderRadius: BorderRadius.circular(22),
                      menuMaxHeight: 150,
                      onChanged: (value) {
                        setState(() {
                          selectedWeek = value.toString();
                          pref.setInt('selectedCardIndex', selectedCardIndex);
                          pref.setString('selectedWeek', selectedWeek);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        selectedCardIndex != -1) {
                      UserData userData = UserData(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        carName: carNameController.text,
                        carModel: carModelController.text,
                        mobileNumber: mobileNumberController.text,
                        divingLicense: divingLicenseValues,
                        numberOfWeeks: selectedWeek,
                        selectedService: selectedCardIndex != -1
                            ? garageTasks[selectedCardIndex]['title']
                            : ' ',
                        price: selectedCardIndex != -1
                            ? garageTasks[selectedCardIndex]['price'] *
                                int.parse(selectedWeek)
                            : ' ',
                      );
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
                      isLoading = true;
                      setState(() {});
                      CollectionReference reference =
                          FirebaseFirestore.instance.collection('Garage');
                      await reference
                          .doc(FirebaseAuth.instance.currentUser!.email! +
                              " - " +
                              formattedDateTime+ " - " + 'Garage')
                          .set({
                        'Service': 'Garage',
                        'Car model': userData.carModel,
                        'Car brand': userData.carName,
                        'Phone number': userData.mobileNumber,
                        'Package name': userData.selectedService,
                        'Number of weeks': userData.numberOfWeeks,
                        'Single Week Price': garageTasks[selectedCardIndex]['price'],
                        'Plate number': plateNumber.text,
                        'User first name': userData.firstName,
                        'User last name': userData.lastName,
                        'Status': 'Waiting confirmation',
                        'Confirmed Status':'Processing',
                        'Date and Time': formattedDateTime,
                        'Location':'123 Ahmed Hamdy Street',
                        "Payment Method": '',
                        'Total Service cost':userData.price,
                        'Description(Optional)':userData.selectedService,
                      });
                      CollectionReference reference2 =
                          FirebaseFirestore.instance.collection('orders');
                      await reference2
                          .doc(FirebaseAuth.instance.currentUser!.email! +
                              " - " +
                              formattedDateTime+ " - " + 'Garage')
                          .set({
                        'Service': 'Garage',
                        'Date and Time': formattedDateTime,
                        'Car model': carModelController.text.trim(),
                        'Car brand': carNameController.text.trim(),
                        'Phone number': mobileNumberController.text.trim(),
                        'Plate number': plateNumber.text,
                        'User first name': firstNameController.text.trim(),
                        'User last name': lastNameController.text.trim(),
                        'Package name': userData.selectedService,
                        'Number of weeks': userData.numberOfWeeks,
                        'Single Week Price': "${garageTasks[selectedCardIndex]['price'].toString()} LE",
                        'Location':'123 Ahmed Hamdy Street',
                        'Status': 'Waiting confirmation',
                        'Confirmed Status':'Processing',
                        "Payment Method": 'Cash',
                        'Estimated time of arrival':'',
                        'Total Service cost':"${userData.price}",
                        'Description(Optional)':userData.selectedService,
                      });
                      isLoading = false;
                      setState(() {});
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => orderPage()),
                        (route) => false);
                    }
                  },
                  child: isLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(color: Colors.white),
                          width: 20,
                          height: 20,
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    //padding: EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final String title;
  final String price;
  final Color color;
  final double width;
  final double height;
  final bool isSelected;
  final Function(bool isSelected) onSelect;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.price,
    required this.color,
    required this.width,
    required this.height,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isPressed = false; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelect(!widget.isSelected);
      },
      onTapDown: (_) {
        setState(() {
          isPressed = true; 
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false; 
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false; 
        });
      },
      child: Container(
        width: widget.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.green[200] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: isPressed
          //       ? Colors.red
          //       : (widget.isSelected ? Colors.red : Colors.transparent),
          //   width: 2.0,
          // ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    garageTasks.firstWhere((element) =>
                        element['title'] == widget.title)['imagePath'],
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.color, 
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: garageTasks
                  .firstWhere((element) => element['title'] == widget.title)[
                      'additionalText']
                  .map<Widget>((text) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      garageTasks.firstWhere((element) =>
                          element['title'] == widget.title)['starImagePath'],
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        text.substring(1),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: widget.title == 'Gold'
                              ? FontWeight.bold
                              : FontWeight.bold, 
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                '${widget.price} EGP',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
