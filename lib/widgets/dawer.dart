import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:fluttercourse/pages/aboutUs.dart';
import 'package:fluttercourse/pages/aboutUs.dart';
import 'package:fluttercourse/pages/contactUs.dart';
import 'package:fluttercourse/pages/login.dart';
import 'package:fluttercourse/pages/my_cars.dart';
import 'package:fluttercourse/pages/orderhistory.dart';
//import 'package:fluttercourse/commerceHome.dart';
import 'package:fluttercourse/pages/orders.dart';
import 'package:fluttercourse/pages/accountPage.dart';
import 'package:fluttercourse/pages/subscriptionPage.dart';
import 'package:fluttercourse/util/imageUrlProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DrawerNig extends StatefulWidget {
  DrawerNig({super.key});

  @override
  State<DrawerNig> createState() => DrawerNigState();
}

class DrawerNigState extends State<DrawerNig> {
  List drawItems = [
    {"icon": Icons.account_box_outlined, "name": "Account", "nav": AccountPage()},
    {"icon": Icons.local_shipping_outlined, "name": "orders", "nav": const orderPage()},
    {"icon": Icons.history, "name": "Order History", "nav": const Orderhistory()},
    {
      "icon": Icons.subscriptions_outlined,
      "name": "Subscriptions",
      "nav": SubscriptionPage()
    },
    {"icon": Icons.car_repair_outlined, "name": "My Cars", "nav": const MyCars()},
    {"icon": Icons.info_outline, "name": "About Us", "nav": const AboutUs()},
    {"icon": Icons.phone_outlined, "name": "Contact Us", "nav": const ContactUs()},
  ];
  String? firstName;
  String? lastName;
  String? email;
  //File? _image;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          firstName = userData['first_name'] ?? '';
          lastName = userData['last_name'] ?? '';
          email = userData['email'] ?? '';
        });
      } else {
        print(
            'User data not found for email: ${FirebaseAuth.instance.currentUser!.email}');
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  // Future<void> _getImage(ImageSource source) async {
  //   final pickedFile = await ImagePicker().pickImage(source: source);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }
  //String? _imageUrl;

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

  @override
  Widget build(BuildContext context) {
    String? imageUrl = context.watch<ImageUrlProvider>().imageUrl;
    return Drawer(
      //backgroundColor:const Color.fromARGB(255, 224, 58, 58) ,
      child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 224, 58, 58)),
              currentAccountPicture: 
              Container(
                height: 40,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white),
                child: GestureDetector(
                  onTap: () => getImage(context),
                  child: CircleAvatar(
                    backgroundImage: imageUrl != null
                        ? NetworkImage(imageUrl)
                        : AssetImage("assets/icons/person.png")
                            as ImageProvider<Object>?,
                  ),
                ),
              ),
              accountName: Text('${firstName ?? ''} ${lastName ?? ''}'),
              accountEmail: Text(email ?? ''),
            ),
            // ListTile(
            //     title: const Text("Home Page"),
            //     leading: const Icon(Icons.home),
            //     onTap: () {
            //       Navigator.of(context).pushReplacement(MaterialPageRoute(
            //           builder: (context) => const CommerceHome()));
            //     }),
            // const SizedBox(height: 1),
            ...List.generate(drawItems.length, (i) {
              return ListTile(
                title: Text(drawItems[i]["name"],style: TextStyle(fontWeight: FontWeight.w500),),
                leading: Icon(drawItems[i]["icon"],color: const Color.fromARGB(255, 179, 47, 38),),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => drawItems[i]["nav"],
                  ));
                },
              );
            }),

            // Container(
            //   padding: EdgeInsets.zero,
            //   height: 353,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     physics:
            //         const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            //     itemCount: drawItems.length,
            //     itemBuilder: (context, i) {
            //       return ListTile(
            //         title: Text(drawItems[i]["name"]),
            //         leading: Icon(drawItems[i]["icon"]),
            //         onTap: () {
            //           Navigator.of(context).push(MaterialPageRoute(
            //               builder: (context) => drawItems[i]["nav"]));
            //         },
            //       );
            //     },
            //   ),
            // ),
            ListTile(
              title: const Text("Log Out",style: TextStyle(fontWeight: FontWeight.w500),),
              leading: const Icon(Icons.exit_to_app,color: const Color.fromARGB(255, 179, 47, 38),),
              onTap: () {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.rightSlide,
                  dialogType: DialogType.warning,
                  body: Center(
                    child: Text(
                      'You are about to Logout , are you sure you want to proceed with this action ?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: 'This is Ignored',
                  desc: 'This is also Ignored',
                  btnOkOnPress: () async {
                    await FirebaseAuth.instance.signOut();
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    googleSignIn.disconnect();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => login_page()),
                        (route) => false);
                  },
                  btnCancelOnPress: () {
                    Navigator.of(context).pop();
                  },
                )..show();
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return AlertDialog(
                //         title: const Text("Warning"),
                //         content: const Text(
                //             "You are about to Logout , are you sure you want to proceed with this action ?"),
                //         actions: [
                //           TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).pushReplacement(
                //                     MaterialPageRoute(
                //                         builder: (context) =>
                //                             const login_page()));
                //               },
                //               child: const Text("Logout")),
                //           TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).pop();
                //               },
                //               child: const Text("Cancel")),
                //         ],
                //       );
                //     });
              },
            ),
          ]),
    );
  }
}
