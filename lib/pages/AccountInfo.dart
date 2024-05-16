import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercourse/util/dimensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

final List<String> gender = ['Male', 'Female'];
final List<String> age = [
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31',
  '32',
  '33',
  '34',
  '35',
  '36',
  '37',
  '38',
  '39',
  '40',
  '41',
  '42',
  '43',
  '44',
  '45',
  '46',
  '47',
  '48',
  '49',
  '50',
];

class _AccountInfoState extends State<AccountInfo> {
  final customerFormKey = GlobalKey<FormState>();
  final fNameController = TextEditingController(text: "Mohamed");
  final lNameController = TextEditingController(text: "Ali");
  final phoneController = TextEditingController(text: "01224622995");
  final emailController = TextEditingController(text: "mohamed@gmail.com");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final landmarkController = TextEditingController();
  String selectedAge = '21';
  String selectedGender = gender[0];
  bool isEditing = false;
  bool is_loading = true;

  Future<void> fetchUserData() async {
    try {
      //String userEmail = 'mohamedbongadoza@yahoo.com';
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      fNameController.text = userData['first_name'] ?? '';
      lNameController.text = userData['last_name'] ?? '';
      phoneController.text = userData['phone_number'] ?? '';
      emailController.text = userData['email'] ?? '';
      selectedAge = userData['age'] ?? '21';
      selectedGender = userData['gender'] ?? gender[0];
      is_loading = false;
      setState(() {});
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  Future<void> updateUser(
      String userEmail, Map<String, dynamic> newData) async {
    try {
      DocumentReference userDocRef =
          _firestore.collection('users').doc(userEmail);

      await userDocRef.update(newData);
    } catch (error) {
      print("Error updating user data: $error");
    }
  }

  void onSaveButtonPressed() {
    Map<String, dynamic> updatedData = {
      'first_name': fNameController.text,
      'last_name': lNameController.text,
      'phone_number': phoneController.text,
      'gender': selectedGender,
      'age': selectedAge,
    };
    updateUser(emailController.text, updatedData);
  }

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    // landmarkController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          if (!isEditing)
            Row(
              children: [
                const Text('Edit'),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    toggleEdit();
                  },
                ),
              ],
            ),
          if (isEditing)
            Row(
              children: [
                const Text('Save'),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    onSaveButtonPressed();
                    toggleEdit();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      content: Row(
                        children: [
                          Container(
                            color: Colors.green,
                            child: Icon(
                              Icons.check,
                              size: Dimensions.height30,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Info Updated Successfully",
                            style: TextStyle(
                                fontSize: Dimensions.height22,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ],
                      ),
                      duration: Duration(seconds: 3),
                    ));
                  },
                ),
              ],
            ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Account Info",
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
      ),
      body: is_loading
          ? CircularProgressIndicator(
              color: Colors.red,
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: customerFormKey,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
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
                                  enabled: isEditing,
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Last Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  enabled: isEditing,
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
                      const SizedBox(height: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            enabled: false,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter email";
                              } else if (!RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter your email',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Phone',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            enabled: isEditing,
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'Gender',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Radio(
                            value: gender[0],
                            groupValue: selectedGender,
                            activeColor: Colors.red,
                            onChanged: isEditing
                                ? (String? value) {
                                    setState(() {
                                      selectedGender = value.toString();
                                    });
                                  }
                                : null,
                          ),
                          Text(
                            gender[0],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Radio(
                            value: gender[1],
                            groupValue: selectedGender,
                            activeColor: Colors.red,
                            onChanged: isEditing
                                ? (String? value) {
                                    setState(() {
                                      selectedGender = value.toString();
                                    });
                                  }
                                : null,
                          ),
                          Text(
                            gender[1],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height10),
                      Row(
                        children: [
                          const SizedBox(
                            width: 115,
                            child: Text(
                              'Age',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 15),
                          DropdownButton(
                            enableFeedback: isEditing,
                            items: age
                                .map((item) => DropdownMenuItem(
                                    value: item, child: Text(item)))
                                .toList(),
                            value: selectedAge,
                            borderRadius: BorderRadius.circular(22),
                            menuMaxHeight: 150,
                            onChanged: (value) {
                              selectedAge = value!;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      // FilledButton(
                      //   onPressed: () {
                      //     if (customerFormKey.currentState!.validate()) {}
                      //   },
                      //   style: FilledButton.styleFrom(
                      //     backgroundColor: const Color.fromARGB(255, 224, 58, 58),
                      //     minimumSize: const Size(double.infinity, 50),
                      //   ),
                      //   child: const Text(
                      //     'Submit',
                      //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
