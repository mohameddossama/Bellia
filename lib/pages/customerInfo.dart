import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttercourse/pages/locationPicker.dart';
import 'package:fluttercourse/pages/orders.dart';
import 'package:fluttercourse/util/dimensions.dart';

class CustomerInfo extends StatefulWidget {
  // final String subAdministrativeArea;
  // final String street;
  // final List<Map<String, dynamic>> itemDetailsList;
  const CustomerInfo({
    super.key,
    // required this.subAdministrativeArea,
    // required this.street,
    // required this.itemDetailsList,
  });

  @override
  State<CustomerInfo> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  final customerFormKey = GlobalKey<FormState>();
  final fNameController = TextEditingController(text: "Mohamed");
  final lNameController = TextEditingController(text: "Ali");
    final carModelController = TextEditingController(text: "Sandero");
  final carTypeController = TextEditingController(text: "Renault");
    final letterController = TextEditingController(text: "س ي ب");
  final numberController = TextEditingController(text: "5689");
  final phoneController = TextEditingController(text: "01125564479");
  final TextEditingController currentLocation = TextEditingController();
  final addressController =
      TextEditingController(text: "Alexandria, 45 Street");
  final landmarkController = TextEditingController();
  Color getLocationButtonColor = Colors.grey;

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    phoneController.dispose();
    carModelController.dispose();
    carTypeController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // currentLocation.text = '${widget.subAdministrativeArea} ${widget.street}';
  }

  String? payment;
GlobalKey<ScaffoldState> ScaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Customer Info',
          style: TextStyle(
            fontSize: Dimensions.height25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(10),
        child: Form(
          key: customerFormKey,
          child: 
          ListView(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'First Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: fNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter first name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter first name',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(
                                    r'^[a-zA-Z\u0600-\u06FF]+$',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Dimensions.height10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              'Last Name',
                              style: TextStyle(
                                fontSize:Dimensions.height15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                             SizedBox(height: Dimensions.height5),
                            TextFormField(
                              controller: lNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter last name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter last name',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z\u0600-\u06FF]+$')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:Dimensions.height20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'Phone',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter phone";
                          } else if (!RegExp(r'^(010|011|012|015)\d{8}$')
                              .hasMatch(value)) {
                            return "Enter a valid phone";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter your phone',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                      ),
                    ],
                  ),
                  // const SizedBox(height: 15),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     // const Text(
                  //     //   'Address',
                  //     //   style: TextStyle(
                  //     //     fontSize: 16,
                  //     //     fontWeight: FontWeight.w500,
                  //     //   ),
                  //     // ),
                  //     // const SizedBox(height: 5),
                  //     TextFormField(
                  //       controller: addressController,
                  //       maxLength: 50,
                  //       validator: (value) {
                  //         if (value == null || value.isEmpty) {
                  //           return "Please enter address";
                  //         }
                  //         return null;
                  //       },
                  //       decoration: const InputDecoration(
                  //         hintText: 'Enter your address',
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: Dimensions.height20,),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Car Type',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: carTypeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the car type";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter car type',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(
                                    r'^[a-zA-Z\u0600-\u06FF]+$',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Dimensions.height10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              'Car model',
                              style: TextStyle(
                                fontSize:Dimensions.height15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                             SizedBox(height: Dimensions.height5),
                            TextFormField(
                              controller: carModelController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter last name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter car model',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z\u0600-\u06FF]+$')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20,),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Plate Number',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: letterController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the car type";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter car type',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(
                                    r'^[a-zA-Z\u0600-\u06FF]+$',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Dimensions.height10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //  Text(
                            //   'Car model',
                            //   style: TextStyle(
                            //     fontSize:Dimensions.height15,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                             SizedBox(height: Dimensions.height25),
                            TextFormField(
                              controller: numberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter last name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter car model',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z\u0600-\u06FF]+$')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: Dimensions.height20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => location_picker_page(
                                service_name: 'mart',
                              )));
                      setState(() {
                        getLocationButtonColor = Color.fromARGB(255, 238, 243, 239);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 224, 58, 58),
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Location",
                          style: TextStyle(color: Colors.white, fontSize: Dimensions.height20),
                        ),
                      ],
                    ),
                  ),
              
                  SizedBox(height: Dimensions.height20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address',
                        style: TextStyle(
                          fontSize: Dimensions.height15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: Dimensions.height10),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: currentLocation,
                        // textAlign: TextAlign.center,
                        //maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // initialValue:
                        //     "${widget.subAdministrativeArea} ${widget.street}",
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'Landmark (optional)',
                        style: TextStyle(
                          fontSize: Dimensions.height15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                       SizedBox(height: Dimensions.height5),
                      TextFormField(
                        controller: landmarkController,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          hintText: 'Surrounding Landmarks',
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      Text(
                        "Payment method",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.height15),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Radio(
                                  fillColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 224, 58, 58)),
                                  value: "cash",
                                  groupValue: payment,
                                  onChanged: (Val) {
                                    setState(() {
                                      payment = Val;
                                    });
                                  }),
                              Text(
                                "cash",
                                style: TextStyle(
                                    fontSize: Dimensions.height15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  fillColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 224, 58, 58)),
                                  value: "E-payment",
                                  groupValue: payment,
                                  onChanged: (Val) {
                                    setState(() {
                                      payment = Val;
                                    });
                                  }),
                              Text(
                                "E-payment",
                                style: TextStyle(
                                    fontSize: Dimensions.height15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  // SizedBox(height: Dimensions.height5),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text("Cart Items",style: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.height17),),
                  //   ],
                  // ),
                
                  
                ],
              
              ),
                SizedBox(height: Dimensions.height20,),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  if (customerFormKey.currentState!.validate()) {}
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>orderPage()), (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 3),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Your order was recorded , please wait for confirmation",
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 250, 249, 249),
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.height12),
                                ),
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.green,
                                  size: Dimensions.height25,
                                )
                              ],
                            )));
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 224, 58, 58),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child:  Text(
                  'Submit',
                  style: TextStyle(fontSize: Dimensions.height22, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
