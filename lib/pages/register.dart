import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercourse/pages/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
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
final List<String> carColor = [
  'Black',
  'White',
  'Grey',
  'Red',
  'Blue',
  'Green'
];

class _RegisterState extends State<Register> {
  final registerFromKey = GlobalKey<FormState>();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final plateLettersController = TextEditingController();
  final plateNumberController = TextEditingController();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final mileageController = TextEditingController();
  String selectedGender = gender[0];
  String selectedColor = 'Black', selectedAge = '16';
  bool showPass = true,
      showPass2 = true,
      hasCar = false; //showpass = show hide password

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    plateLettersController.dispose();
    plateNumberController.dispose();
    brandController.dispose();
    modelController.dispose();
    mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: registerFromKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  //first, last name
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
                                FilteringTextInputFormatter.allow(RegExp(
                                  r'^[a-zA-Z\u0600-\u06FF]+$',
                                )),
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
                  const SizedBox(height: 15),
                  //email
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
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
                  const SizedBox(height: 15),
                  //phone
                  const Text(
                    'Phone',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 15),
                  //password
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    obscureText: showPass,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          icon: Icon(
                            showPass
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 20,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  const SizedBox(height: 15),
                  //confirm password
                  const Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    obscureText: showPass2,
                    controller: confirmPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm password';
                      } else if (passwordController.value !=
                          confirmPasswordController.value) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter same password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPass2 = !showPass2;
                            });
                          },
                          icon: Icon(
                            showPass2
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 20,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  const SizedBox(height: 15),
                  //gender
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
                        onChanged: (value) {
                          selectedGender = value!;
                          setState(() {});
                        },
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
                        onChanged: (value) {
                          selectedGender = value.toString();
                          setState(() {});
                        },
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
                  //age
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
                  //have car
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Own a car?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Radio(
                        value: true,
                        groupValue: hasCar,
                        activeColor: Colors.red,
                        onChanged: (value) {
                          hasCar = value!;
                          setState(() {});
                        },
                      ),
                      const Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Radio(
                        value: false,
                        groupValue: hasCar,
                        activeColor: Colors.red,
                        onChanged: (value) {
                          hasCar = value!;
                          setState(() {});
                        },
                      ),
                      const Text(
                        'No',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  hasCar
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            //plates
                            const Text(
                              'Plate Number',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: plateLettersController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (hasCar &&
                                          (value == null || value.isEmpty)) {
                                        return "Please enter plate number";
                                      } else if (hasCar &&
                                          !RegExp(r'^([A-Z]{1,3}|[\u0621-\u064A](?: [\u0621-\u064A]){0,2})$')
                                              .hasMatch(value!)) {
                                        return "Not valid";
                                      }
                                      return null;
                                    },
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: 'ABC',
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(5),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: '-',
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: plateNumberController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (hasCar &&
                                          (value == null || value.isEmpty)) {
                                        return "Please enter plate number";
                                      }
                                      return null;
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: '123',
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            //brand,model
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Brand Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      TextFormField(
                                        controller: brandController,
                                        validator: (value) {
                                          if (hasCar &&
                                              (value == null ||
                                                  value.isEmpty)) {
                                            return "Please enter brand name";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Toyota',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Model Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      TextFormField(
                                        controller: modelController,
                                        validator: (value) {
                                          if (hasCar &&
                                              (value == null ||
                                                  value.isEmpty)) {
                                            return "Please enter model name";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Yaris',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            //mileage, color
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Car Mileage',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      TextFormField(
                                        controller: mileageController,
                                        keyboardType: TextInputType.number,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (hasCar &&
                                              (value == null ||
                                                  value.isEmpty)) {
                                            return "Please enter car mileage";
                                          } else if (hasCar &&
                                              !RegExp(r'^\d{1,10}(?:\.\d{1,2})?$')
                                                  .hasMatch(value!)) {
                                            return "Enter a valid value";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: '0.0',
                                            suffixText: 'km',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 15)),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(6),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Car Color',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      DropdownButton(
                                        value: selectedColor,
                                        hint: const Text('Select color'),
                                        borderRadius: BorderRadius.circular(22),
                                        items: carColor
                                            .map((e) => DropdownMenuItem(
                                                value: e, child: Text(e)))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedColor = value!;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  //register button
                  FilledButton(
                    onPressed: () async {
                      if (registerFromKey.currentState!.validate()) {}
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        print("User created: ${credential.user!.uid}");
                        FirebaseAuth.instance.currentUser!.sendEmailVerification();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => login_page(),
                        ));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.rightSlide,
                            dialogType: DialogType.warning,
                            body: Center(
                              child: Text(
                                'The password provided is too weak.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: 'This is Ignored',
                            desc: 'This is also Ignored',
                            btnOkOnPress: () {
                            },
                          )..show();
                        } else if (e.code == 'email-already-in-use') {
                          print('This email account already exists.');
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.rightSlide,
                            dialogType: DialogType.error,
                            body: Center(
                              child: Text(
                                'This email account already exists.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: 'This is Ignored',
                            desc: 'This is also Ignored',
                            btnOkOnPress: () {
                            },
                          )..show();
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 224, 58, 58),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Register',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //login button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Have an account?',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const login_page(),
                          ));
                        },
                        child: const Text(
                          'Login here',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
