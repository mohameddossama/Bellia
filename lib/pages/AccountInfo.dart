import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercourse/util/dimensions.dart';

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
  // final landmarkController = TextEditingController();
  String selectedAge = '21';
  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    // landmarkController.dispose();
    super.dispose();
  }
  

  String selectedGender = gender[0];
  bool isEditing = false;

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
                        toggleEdit();
                      
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
      body: Padding(
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          .map((item) =>
                              DropdownMenuItem(value: item, child: Text(item)))
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
