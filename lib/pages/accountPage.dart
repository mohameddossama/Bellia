import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/AccountInfo.dart';
import 'package:fluttercourse/pages/changePass.dart';
//import 'package:fluttercourse/pages/changePhone.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/pages/login.dart';
import 'package:fluttercourse/util/imageUrlProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AccountPage extends StatefulWidget {
  AccountPage({super.key});

  @override
  State<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  List iconName = [
    {"name": "Account info", "nav": const AccountInfo()},
    {"name": "Change Password", "nav": const ChangePassword()},
    // {"name":"Change Phone Number","nav": const ChangePhone()},
    {"name": "Log Out", "nav": const login_page()},
  ];

  // String? _imageUrl;
  // File? _image;

  Future<void> getImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.camera);

    if (imageCamera != null) {
      final File image = File(imageCamera.path);
      final path =
          'profile_image/${FirebaseAuth.instance.currentUser!.email}.jpg';
      var refStorage = FirebaseStorage.instance.ref().child(path);

      try {
        await refStorage.putFile(image);
        final String url = await refStorage.getDownloadURL();
        Provider.of<ImageUrlProvider>(context, listen: false).setImageUrl(url);
      } catch (error) {
        print('Error uploading image: $error');
      }
    }
  }

// @override
// //   void initState() {
// //     super.initState();
// //     fetchUserData();
// //   }

// //   String? firstName;
// //   String? lastName;
// //   String? email;
// //   String? mobile;

// //   Future<void> fetchUserData() async {
// //     try {
// //       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(FirebaseAuth.instance.currentUser!.email)
// //           .get();

// //       if (userSnapshot.exists) {
// //         Map<String, dynamic> userData =
// //             userSnapshot.data() as Map<String, dynamic>;
// //         setState(() {
// //           firstName = userData['first_name'] ?? '';
// //           lastName = userData['last_name'] ?? '';
// //           email = userData['email'] ?? '';
// //           mobile = userData['phone_number'] ?? '';
// //         });
// //       } else {
// //         print(
// //             'User data not found for email: ${FirebaseAuth.instance.currentUser!.email}');
// //       }
// //     } catch (error) {
// //       print("Error fetching user data: $error");
// //     }
// //   }

  @override
  Widget build(BuildContext context) {
    String? imageUrl = context.watch<ImageUrlProvider>().imageUrl;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Account',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => getImage(context),
                      child: CircleAvatar(
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl)
                            : AssetImage("assets/icons/person.png")
                                as ImageProvider<Object>?,
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      right: -18,
                      child: IconButton(
                        onPressed: () {
                          getImage(context);
                        },
                        icon: Icon(Icons.camera_alt),
                        color: Colors.white,
                        iconSize: 15,
                        // Adjust size and other properties as needed
                      ),
                    ),
                  ],
                ),
              )
            ],
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
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              // padding: EdgeInsets.only(top: 60),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              itemCount: iconName.length,
              itemBuilder: (context, i) {
                return Container(
                    margin: const EdgeInsets.symmetric(vertical: 9),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        if (i != 2) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => iconName[i]["nav"]));
                        } else {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.rightSlide,
                            dialogType: DialogType.warning,
                            body: Center(
                              child: Text(
                                'You are about to Logout , are you sure you want to proceed with this action ?',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: 'This is Ignored',
                            desc: 'This is also Ignored',
                            btnOkOnPress: () async {
                              await FirebaseAuth.instance.signOut();
                              GoogleSignIn googleSignIn = GoogleSignIn();
                              googleSignIn.disconnect();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => login_page()),
                                  (route) => false);
                            },
                            btnCancelOnPress: () {
                              Navigator.of(context).pop();
                            },
                          )..show();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(iconName[i]["name"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ));
              },
            ),
          ),
        ));
  }
}







// import 'dart:io';

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttercourse/pages/AccountInfo.dart';
// import 'package:fluttercourse/pages/changePass.dart';
// //import 'package:fluttercourse/pages/changePhone.dart';
// import 'package:fluttercourse/pages/commerceHome.dart';
// import 'package:fluttercourse/pages/login.dart';
// import 'package:fluttercourse/util/imageUrlProvider.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// // ignore: must_be_immutable
// class AccountPage extends StatefulWidget {
//   AccountPage({super.key});

//   @override
//   State<AccountPage> createState() => AccountPageState();
// }

// class AccountPageState extends State<AccountPage> {
//   List iconName = [
//     {"name": "Account info", "nav": const AccountInfo()},
//     {"name": "Change Password", "nav": const ChangePassword()},
//     // {"name":"Change Phone Number","nav": const ChangePhone()},
//     {"name": "Log Out", "nav": const login_page()},
//   ];

//   // String? _imageUrl;
//   // File? _image;

//   Future<void> getImage(BuildContext context) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? imageCamera =
//         await picker.pickImage(source: ImageSource.camera);

//     if (imageCamera != null) {
//       final File image = File(imageCamera.path);
//       final path =
//           'profile_image/${FirebaseAuth.instance.currentUser!.email}.jpg';
//       var refStorage = FirebaseStorage.instance.ref().child(path);

//       try {
//         await refStorage.putFile(image);
//         final String url = await refStorage.getDownloadURL();
//         Provider.of<ImageUrlProvider>(context, listen: false).setImageUrl(url);
//       } catch (error) {
//         print('Error uploading image: $error');
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   String? firstName;
//   String? lastName;
//   String? email;
//   String? mobile;

//   Future<void> fetchUserData() async {
//     try {
//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.email)
//           .get();

//       if (userSnapshot.exists) {
//         Map<String, dynamic> userData =
//             userSnapshot.data() as Map<String, dynamic>;
//         setState(() {
//           firstName = userData['first_name'] ?? '';
//           lastName = userData['last_name'] ?? '';
//           email = userData['email'] ?? '';
//           mobile = userData['phone_number'] ?? '';
//         });
//       } else {
//         print(
//             'User data not found for email: ${FirebaseAuth.instance.currentUser!.email}');
//       }
//     } catch (error) {
//       print("Error fetching user data: $error");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String? imageUrl = context.watch<ImageUrlProvider>().imageUrl;
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color.fromARGB(255, 224, 58, 58),
//           centerTitle: true,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Account',
//                 style: TextStyle(
//                   fontSize: 22.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Container(
//                 height: 40,
//                 padding: EdgeInsets.all(2),
//                 decoration:
//                     BoxDecoration(shape: BoxShape.circle, color: Colors.white),
//                 child: Stack(
//                   children: [
//                     GestureDetector(
//                       onTap: () => getImage(context),
//                       child: CircleAvatar(
//                         backgroundImage: imageUrl != null
//                             ? NetworkImage(imageUrl)
//                             : AssetImage("assets/icons/person.png")
//                                 as ImageProvider<Object>?,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: -20,
//                       right: -18,
//                       child: IconButton(
//                         onPressed: () {
//                           getImage(context);
//                         },
//                         icon: Icon(Icons.camera_alt),
//                         color: Colors.white,
//                         iconSize: 15,
//                         // Adjust size and other properties as needed
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             color: Colors.white,
//             onPressed: () {
//               Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (context) => CommerceHome()),
//                   (route) => false);
//             },
//           ),
//           iconTheme: const IconThemeData(
//             color: Colors.white,
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             height: 800,
//             color: const Color.fromARGB(255, 255, 255, 255),
//             child: Column(children: [
//               Container(
//                 height: 200,
//                 width: 200,
//                 padding: EdgeInsets.all(2),
//                 decoration:
//                     BoxDecoration(shape: BoxShape.circle, color: Colors.white),
//                 child: Stack(
//                   children: [
//                     Container(
//                       height: 200,
//                       width: 200,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         //border: Border.all(color: const Color.fromARGB(255, 187, 35, 35),width: 2 ),
//                         boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 1,
//                               blurRadius: 3,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                       ),
//                       child: GestureDetector(
//                         onTap: () => getImage(context),
//                         child: CircleAvatar(
//                           backgroundImage: imageUrl != null
//                               ? NetworkImage(imageUrl)
//                               : AssetImage("assets/icons/person.png")
//                                   as ImageProvider<Object>?,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: -20,
//                       right: -12,
//                       child: IconButton(
//                         onPressed: () {
//                           getImage(context);
//                         },
//                         icon: Icon(Icons.camera_alt),
//                         color: const Color.fromARGB(255, 10, 7, 7),
//                         iconSize: 50,
//                         // Adjust size and other properties as needed
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 15, bottom: 20),
//                 padding: EdgeInsets.symmetric(horizontal: 30),
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 160,
//                       padding: EdgeInsets.only(left: 20, right: 20, top: 10),
//                       decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 1,
//                               blurRadius: 3,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                           border: Border.all(
//                               color: const Color.fromARGB(255, 187, 35, 35),
//                               width: 2),
//                           color: const Color.fromARGB(255, 255, 255, 255),
//                           borderRadius: BorderRadius.circular(30)),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "$firstName $lastName",
//                                 style: TextStyle(
//                                     fontSize: 21, fontWeight: FontWeight.bold),
//                               ),
//                               MaterialButton(
//                                 onPressed: () {},
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Icon(
//                                       Icons.arrow_circle_left_outlined,
//                                       color: const Color.fromARGB(
//                                           255, 207, 56, 45),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text(
//                                       "Logout",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 15,
//                                           color:
//                                               Color.fromARGB(255, 207, 56, 45)),
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             height: 15,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 15.0),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.mail_outline_rounded),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 Text("$email")
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 15.0),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.phone_outlined),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 Text("$mobile")
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),

//                     // Container(
//                     //   height: 170,
//                     //   padding: EdgeInsets.only(left: 0, right: 0, top: 10),
//                     //   decoration: BoxDecoration(
//                     //     border: Border.all(
//                     //           color: const Color.fromARGB(255, 187, 35, 35),
//                     //           width: 2),
//                     //       color: const Color.fromARGB(255, 255, 255, 255),
//                     //       borderRadius: BorderRadius.circular(30)),
//                     //   child: Column(
//                     //     children: [
//                     //       MaterialButton(
//                     //         onPressed: () {},
//                     //         child: Row(
//                     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //           children: [
//                     //             Row(
//                     //               children: [
//                     //                 Icon(Icons.person_2_outlined),
//                     //                 SizedBox(
//                     //                   width: 20,
//                     //                 ),
//                     //                 Text(
//                     //                   "Edit Info",
//                     //                   style: TextStyle(
//                     //                       fontWeight: FontWeight.bold,
//                     //                       fontSize: 15),
//                     //                 )
//                     //               ],
//                     //             ),
//                     //             Icon(
//                     //               Icons.arrow_forward_ios_rounded,
//                     //               color: const Color.fromARGB(255, 95, 91, 91),
//                     //             )
//                     //           ],
//                     //         ),
//                     //       ),
//                     //       MaterialButton(
//                     //         onPressed: () {},
//                     //         child: Row(
//                     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //           children: [
//                     //             Row(
//                     //               children: [
//                     //                 Icon(Icons.password_outlined),
//                     //                 SizedBox(
//                     //                   width: 20,
//                     //                 ),
//                     //                 Text(
//                     //                   "Change Password",
//                     //                   style: TextStyle(
//                     //                       fontWeight: FontWeight.bold,
//                     //                       fontSize: 15),
//                     //                 )
//                     //               ],
//                     //             ),
//                     //             Icon(
//                     //               Icons.arrow_forward_ios_rounded,
//                     //               color: const Color.fromARGB(255, 95, 91, 91),
//                     //             )
//                     //           ],
//                     //         ),
//                     //       ),
//                     //       MaterialButton(
//                     //         onPressed: () {},
//                     //         child: Row(
//                     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //           children: [
//                     //             Row(
//                     //               children: [
//                     //                 Icon(Icons.pets_outlined),
//                     //                 SizedBox(
//                     //                   width: 20,
//                     //                 ),
//                     //                 Text(
//                     //                   "My Pet/s",
//                     //                   style: TextStyle(
//                     //                       fontWeight: FontWeight.bold,
//                     //                       fontSize: 15),
//                     //                 )
//                     //               ],
//                     //             ),
//                     //             Icon(
//                     //               Icons.arrow_forward_ios_rounded,
//                     //               color: const Color.fromARGB(255, 95, 91, 91),
//                     //             )
//                     //           ],
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     Center(
//                       child: Container(
//                         height: 300,
//                         margin: const EdgeInsets.only(top: 30),
//                         child: ListView.builder(
//                           physics: const NeverScrollableScrollPhysics(),
//                           // padding: EdgeInsets.only(top: 60),
//                           padding: const EdgeInsets.symmetric(horizontal: 0),
//                           itemCount: iconName.length,
//                           itemBuilder: (context, i) {
//                             return Container(
//                                 margin: const EdgeInsets.symmetric(vertical: 9),
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       spreadRadius: 1,
//                                       blurRadius: 3,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: MaterialButton(
//                                   onPressed: () {
//                                     if (i != 2) {
//                                       Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   iconName[i]["nav"]));
//                                     } else {
//                                       AwesomeDialog(
//                                         context: context,
//                                         animType: AnimType.rightSlide,
//                                         dialogType: DialogType.warning,
//                                         body: Center(
//                                           child: Text(
//                                             'You are about to Logout , are you sure you want to proceed with this action ?',
//                                             style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         title: 'This is Ignored',
//                                         desc: 'This is also Ignored',
//                                         btnOkOnPress: () async {
//                                           await FirebaseAuth.instance.signOut();
//                                           GoogleSignIn googleSignIn =
//                                               GoogleSignIn();
//                                           googleSignIn.disconnect();
//                                           Navigator.of(context)
//                                               .pushAndRemoveUntil(
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           login_page()),
//                                                   (route) => false);
//                                         },
//                                         btnCancelOnPress: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                       )..show();
//                                     }
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(iconName[i]["name"],
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold)),
//                                       const Icon(Icons.arrow_forward),
//                                     ],
//                                   ),
//                                 ));
//                           },
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ]),
//           ),
//         ));
//   }
// }
