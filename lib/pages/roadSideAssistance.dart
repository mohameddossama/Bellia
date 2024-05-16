import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/pages/locationPicker.dart';
import 'package:fluttercourse/pages/orders.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class RoadSideAssistance extends StatefulWidget {
  final String subAdministrativeArea;
  final String street;
  RoadSideAssistance({
    Key? key,
    required this.subAdministrativeArea,
    required this.street,
  }) : super(key: key);

  @override
  State<RoadSideAssistance> createState() => _RoadSideAssistanceState();
}

class _RoadSideAssistanceState extends State<RoadSideAssistance> {
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController issueController = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController currentLocation = TextEditingController();
  final TextEditingController additionalLocation = TextEditingController();
  final TextEditingController arabicController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController plateNumber = TextEditingController();
  late SharedPreferences pref;

  File? _image;
  final _formKey = GlobalKey<FormState>();
  Color getLocationButtonColor = Colors.grey;
  Color uploadButtonColor = Colors.grey;
  bool isLoading = false;
  String urlDownload = ' ';

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
    } else if (selectedCarData == null) {
      carNameController.text = "";
      carModelController.text = "";
      plateNumber.text = "";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCars();
    getCache();
    currentLocation.text = '${widget.subAdministrativeArea}${widget.street}';
  }

  getCache() async {
    pref = await SharedPreferences.getInstance();
    if (carNameController.text.isEmpty || carNameController.text == "") {
      carNameController.text = pref.getString('carName') ?? '';
    }
    if (carModelController.text.isEmpty || carModelController.text == "") {
      carModelController.text = pref.getString('carModel') ?? '';
    }
    if (plateNumber.text.isEmpty || plateNumber.text == "") {
      plateNumber.text = pref.getString('plateNumber') ?? '';
    }
    if (fNameController.text.isEmpty) {
      fNameController.text = pref.getString('firstName') ?? '';
    }
    if (lNameController.text.isEmpty) {
      lNameController.text = pref.getString('lastName') ?? '';
    }
    if (mobileNumberController.text.isEmpty) {
      mobileNumberController.text = pref.getString('mobile') ?? '';
    }
    if (currentLocation.text.isEmpty) {
      currentLocation.text = pref.getString('currentLocation2') ?? '';
    }
    if (additionalLocation.text.isEmpty) {
      additionalLocation.text = pref.getString('surroundingLandmarks2') ?? '';
    }
    if (issueController.text.isEmpty) {
      issueController.text = pref.getString('issue2') ?? '';
    }
    print('cache get');
  }

  setCache() async {
    pref.setString('carName', carNameController.text);
    pref.setString('carModel', carModelController.text);
    pref.setString('plateNumber', plateNumber.text);
    pref.setString('firstName', fNameController.text);
    pref.setString('lastName', lNameController.text);
    pref.setString('mobile', mobileNumberController.text);
    pref.setString('currentLocation2', currentLocation.text);
    pref.setString('surroundingLandmarks2', additionalLocation.text);
    pref.setString('issue2', issueController.text);
    print('cache set');
  }

  clearCache() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // if (_image == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Please upload a photo.'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text("Submitted Information"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Car Name: ${carNameController.text}"),
                  Text("Car Model: ${carModelController.text}"),
                  Text("Mobile Number: ${mobileNumberController.text}"),
                  Text("Plate Number: ${plateNumber.text}"),
                  // Text("Arabic: ${arabicController.text}"),
                  // Text("Number: ${numberController.text}"),
                  Text("Landmarks: ${additionalLocation.text}"),
                  Text("Issue: ${issueController.text}"),
                  Text("Image Path: ${_image?.path}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    //upload image to firebase
                    if (_image != null) {
                      final path =
                          'Roadside Assistance/${FirebaseAuth.instance.currentUser!.email}.jpg';
                      final reference =
                          FirebaseStorage.instance.ref().child(path);
                      UploadTask uploadTask = reference.putFile(_image!);
                      final snapshot = await uploadTask.whenComplete(() {});
                      urlDownload = await snapshot.ref.getDownloadURL();
                    }
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

                    CollectionReference reference = FirebaseFirestore.instance
                        .collection('Roadside Assistance');
                    await reference
                        .doc(FirebaseAuth.instance.currentUser!.email! +
                            " - " +
                            formattedDateTime + " - " + 'Roadside Assistance' )
                        .set({
                      'Service': 'Roadside Assistance',
                      'Car model': carModelController.text.trim(),
                      'Car brand': carNameController.text.trim(),
                      'Phone number': mobileNumberController.text.trim(),
                      'Location': currentLocation.text.trim(),
                      'Land mark': additionalLocation.text.isNotEmpty
                          ? additionalLocation.text.trim()
                          : " ",
                      'Issue': issueController.text.isNotEmpty
                          ? issueController.text.trim()
                          : " ",
                      'Image link': urlDownload,
                      'Plate number': plateNumber.text,
                      'User first name': fNameController.text.trim(),
                      'User last name': lNameController.text.trim(),
                      'Status': 'Waiting confirmation',
                      'Confirmed Status':'Processing',
                      'Date and Time': formattedDateTime,
                      "Payment Method": ''
                    });
                    if (_image != null) {
                      final path =
                          'orders/${FirebaseAuth.instance.currentUser!.email}.jpg';
                      final reference2 =
                          FirebaseStorage.instance.ref().child(path);
                      UploadTask uploadTask = reference2.putFile(_image!);
                      final snapshot = await uploadTask.whenComplete(() {});
                      urlDownload = await snapshot.ref.getDownloadURL();
                    }

                    CollectionReference reference2 =
                        FirebaseFirestore.instance.collection('orders');
                    await reference2
                        .doc(FirebaseAuth.instance.currentUser!.email! +
                            " - " +
                            formattedDateTime + " - " + 'Roadside Assistance')
                        .set({
                      'Service': 'Roadside Assistance',
                      'Date and Time': formattedDateTime,
                      'Car model': carModelController.text.trim(),
                      'Car brand': carNameController.text.trim(),
                      'Phone number': mobileNumberController.text.trim(),
                      'Location': currentLocation.text.trim(),
                      'Land mark': additionalLocation.text.isNotEmpty
                          ? additionalLocation.text.trim()
                          : " ",
                      'Issue': issueController.text.isNotEmpty
                          ? issueController.text.trim()
                          : " ",
                      'Image link': urlDownload,
                      'Plate number': plateNumber.text,
                      'User first name': fNameController.text.trim(),
                      'User last name': lNameController.text.trim(),
                      'Status': 'Waiting confirmation',
                      'Confirmed Status':'Processing',
                      "Payment Method": ''
                    });
                    //isLoading = false;
                    setState(() {
                      isLoading = false;
                    });
                    clearCache();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => orderPage()),
                        (route) => false);
                  },
                  child: isLoading
                      ? CircularProgressIndicator()
                      : const Text("OK"),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
        title: const Text(
          "RoadSide Assistance",
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
                (route) => false);
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        // physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: fNameController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setCache();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: lNameController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setCache();
                          },
                        ),
                      ),
                    ],
                  ),
                  // IconButton(onPressed: (){}, icon: Icon(Icons.abc,size: 15,)),
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
                            child: Row(
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
                                    color: const Color.fromARGB(255, 0, 0, 0)),
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
                            labelText: 'Car Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a car name';
                            }
                            return null;
                          },
                          onChanged: (_) {
                            setCache();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: carModelController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Car Model',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a car model';
                            }
                            return null;
                          },
                          onChanged: (_) {
                            setCache();
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
                    onChanged: (_) {
                      setCache();
                    },
                  ),
                  // const SizedBox(height: 16),
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
                  //             borderRadius: BorderRadius.circular(10.0),
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
                  //           labelText: '5 6 3 8',
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10.0),
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const location_picker_page(
                                service_name: 'road',
                              )));
                      setState(() {
                        getLocationButtonColor =
                            Color.fromARGB(255, 238, 243, 239);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 224, 58, 58),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Location",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      labelText: 'Current Location',
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
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: additionalLocation,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    onChanged: (_) {
                      setCache();
                    },
                    decoration: InputDecoration(
                      //contentPadding:EdgeInsets.only(top: 5),
                      labelText: 'Surrounding Landmarks',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: issueController,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    onChanged: (_) {
                      setCache();
                    },
                    decoration: InputDecoration(
                      labelText: 'Issue (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        uploadButtonColor = Color.fromARGB(255, 238, 243, 239);
                      });
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Choose an option"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _getImage(ImageSource.gallery);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Gallery"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _getImage(ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Camera"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 224, 58, 58),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text("Upload Photo",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _image != null
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.file(
                            _image!,
                            height: 200,
                            width: 200,
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 224, 58, 58))),
                    onPressed: () {
                      _submit();
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
