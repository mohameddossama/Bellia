import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/pages/locationPicker.dart';
import 'package:fluttercourse/pages/orders.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CarTow extends StatefulWidget {
  final String subAdministrativeArea;
  final String street;
  CarTow({
    Key? key,
  required this.subAdministrativeArea, required this.street,
  }) : super(key: key);

  @override
  State<CarTow> createState() => _CarTowState();
}

class _CarTowState extends State<CarTow> {
  final TextEditingController mobileNumberController = TextEditingController(text: "01224622995");
  final TextEditingController issueController = TextEditingController();
  final TextEditingController carNameController = TextEditingController(text: "Renault");
  final TextEditingController carModelController = TextEditingController(text: "Sandero");
  final TextEditingController currentLocation = TextEditingController();
  final TextEditingController additionalLocation = TextEditingController();
  final TextEditingController arabicController = TextEditingController(text: "س ق ف");
  final TextEditingController numberController = TextEditingController(text: "5589");

  File? _image;
  final _formKey = GlobalKey<FormState>();
  Color getLocationButtonColor = Colors.grey;
  Color uploadButtonColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    currentLocation.text = '${widget.subAdministrativeArea} ${widget.street}';
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
            return AlertDialog(
              title: const Text("Submitted Information"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Car Name: ${carNameController.text}"),
                  Text("Car Model: ${carModelController.text}"),
                  Text("Mobile Number: ${mobileNumberController.text}"),
                  Text("Arabic: ${arabicController.text}"),
                  Text("Number: ${numberController.text}"),
                  Text("Landmarks: ${additionalLocation.text}"),
                  Text("Issue: ${issueController.text}"),
                  Text("Image Path: ${_image!.path}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>orderPage()));
                  },
                  child: const Text("OK"),
                ),
              ],
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
          "Car Towing",
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
             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>CommerceHome()), (route) => false);
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: arabicController,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(5),
                          ],
                          decoration: InputDecoration(
                            labelText: 'س ب ت',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an Arabic value';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: numberController,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: InputDecoration(
                            labelText: '5 6 3 8',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a number';
                            }
                            return null;
                          },
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
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const location_picker_page(
                                service_name: '',
                                
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
                    //textAlign: TextAlign.center,
                    maxLines: 2,
                    decoration: InputDecoration(
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
                    textAlign: TextAlign.center,
                    maxLines: 2,
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
                        backgroundColor: MaterialStatePropertyAll(
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
