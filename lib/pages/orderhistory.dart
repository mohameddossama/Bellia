import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/pages/orderDetails.dart';
import 'package:fluttercourse/pages/order_details.dart';
import 'package:fluttercourse/util/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';

class Orderhistory extends StatefulWidget {
  const Orderhistory({Key? key}) : super(key: key);

  @override
  State<Orderhistory> createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {
  late Stream<List<Map<String, dynamic>>> orderDataStream;

  @override
  void initState() {
    super.initState();
    orderDataStream = fetchOrderDataStream();
  }

  // String? userEmail = FirebaseAuth.instance.currentUser?.email;
  // Stream<List<Map<String, dynamic>>> fetchOrderDataStream() {
  //   try {
  //     String? userEmail = FirebaseAuth.instance.currentUser?.email;
  //     if (userEmail == null) {
  //       throw Exception("No user logged in");
  //     }
  //     String queryPrefix = '$userEmail - ';

  //     return FirebaseFirestore.instance
  //         .collection('orders')
  //         .where(FieldPath.documentId, isGreaterThanOrEqualTo: queryPrefix)
  //         .where(FieldPath.documentId, isLessThan: queryPrefix + '\uf8ff')
  //         .snapshots()
  //         .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  //   } catch (error) {
  //     print("Error fetching order data: $error");
  //     return Stream.value([]);
  //   }
  // }

  
  Future<void> _launchPhoneCall() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '0122446449',
    );

    if (!await launchUrl(phoneUri)) {
      throw 'Could not launch $phoneUri';
    }
  }


String? userEmail = FirebaseAuth.instance.currentUser?.email;

Stream<List<Map<String, dynamic>>> fetchOrderDataStream() {
  try {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      throw Exception("No user logged in");
    }
    String queryPrefix = '$userEmail - ';
    List<String> options = ['Roadside Assistance', 'car wash our center', 'car wash your place', 'Car Towing', 'Bellia Mart', 'Garage',"Maintenance"];

    return FirebaseFirestore.instance
        .collection('orders')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: queryPrefix)
        .where(FieldPath.documentId, isLessThan: queryPrefix + '\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((doc) =>
                doc.id.startsWith(queryPrefix) &&
                options.any((option) => doc.id.contains(option)))
            .map((doc) => doc.data())
            .toList());
  } catch (error) {
    print("Error fetching order data: $error");
    return Stream.value([]);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
        title: const Text(
          'Orders History',
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
              (route) => false,
            );
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: 
      Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 241, 241),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: orderDataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Error fetching order data'));
            } else {
              List<Map<String, dynamic>> orders = snapshot.data!;
              return 
              snapshot.data!.isEmpty
              ?Center(child: Text("No Orders Made",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
              :ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> order = orders[index];
                  return 
                  order['Status'] == 'Completed'||order['Status'] =='Canceled'
                  ? Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(top: 15, left: 8, right: 8),
                    height: Dimensions.height130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1.5,
                        color: const Color.fromARGB(255, 153, 12, 12),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order['Service'] ?? '',
                              style:  TextStyle(
                                fontSize: Dimensions.height20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 211, 57, 46),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: order['Status'] == 'Canceled'
                                    ? const Color.fromARGB(255, 216, 12, 12)
                                    : const Color.fromARGB(255, 49, 179, 9),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Text(
                                order['Status'] ?? '',
                                style:  TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.height12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(order["User first name"],
                                        style:  TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimensions.height15)),
                                     SizedBox(width: Dimensions.widht10),
                                    Text(order["User last name"],
                                        style:  TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimensions.height15)),
                                  ],
                                ),
                                 SizedBox(height: Dimensions.height10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         order_details_page(
                                        //       service_name: order['Service'], documentName: '${FirebaseAuth.instance.currentUser?.email} - ${order['Date and Time']} - ${order['Service']}',
                                        //     ),
                                        //   ),
                                        // );
                                        Scaffold.of(context).showBottomSheet((BuildContext context){
                                                      return Container(
                                                        height:Dimensions.height375,
                                                        width: Dimensions.widht500,
                                                        padding: EdgeInsets.all(Dimensions.height20),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                              width: Dimensions.widht130,
                                                               decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                  border: Border.all(color: Colors.red,width: 1.5),),
                                                              child: Container(
                                                                height: Dimensions.height100,
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(image: AssetImage('assets/images/Map.png'))),
                                                              ),
                                                            ),
                                                            SizedBox(width: Dimensions.widht10,),
                                                            Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(height: Dimensions.height10,),
                                                                  Row(
                                                                    children: [
                                                                      Icon(Icons.location_on,color: const Color.fromARGB(255, 224, 58, 58),),
                                                                      SizedBox(width: 2,),
                                                                      SizedBox(
                                                                        width:Dimensions.widht200,
                                                                        child: 
                                                                        Text(
                                                                          order['Location']??'123 Hamed Ahmed Street',
                                                                          overflow: TextOverflow.ellipsis
                                                                          ,)
                                                                          ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: Dimensions.height10,),
                                                                  Row(
                                                                    children: [
                                                                      Icon(Icons.star_rate,color: const Color.fromARGB(255, 224, 58, 58),),
                                                                      SizedBox(width: 2,),
                                                                      SizedBox(
                                                                        width: Dimensions.widht200,
                                                                        child: 
                                                                        Text(
                                                                          order['Land mark']??'',
                                                                          overflow: TextOverflow.ellipsis
                                                                          ,)
                                                                          ),
                                                                    ],
                                                                  ),
                                                                   SizedBox(height: Dimensions.height10,),
                                                                  Row(
                                                              children: [
                                                                Text('Ordered : ',style: TextStyle(
                                                                  fontSize: Dimensions.height15,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: const Color.fromARGB(255, 224, 58, 58)),),
                                                                SizedBox(
                                                                  width: Dimensions.widht160,
                                                                  child: Text(order['Date and Time']??'',
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(),),
                                                                ),
                                                              ],
                                                            ),
                                                                ],
                                                              ),
                                                              ],
                                                            ),
                                                            SizedBox(height: Dimensions.height20,),
                                                            Row(
                                                              children: [
                                                                Text('Customer : ',style: TextStyle(
                                                                  fontSize: Dimensions.height15,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: const Color.fromARGB(255, 224, 58, 58)),),
                                                                Text(order['User first name']??'',style: TextStyle(fontWeight: FontWeight.bold),),
                                                                SizedBox(width: 4,),
                                                                Text(order['User last name']??'',style: TextStyle(fontWeight: FontWeight.bold),)
                                                              ],
                                                            ),
                                                            SizedBox(height: Dimensions.height10,),
                                                            Row(
                                                              children: [
                                                                Text('Customer Notes :  ',style: TextStyle(
                                                                  fontSize: Dimensions.height15,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: const Color.fromARGB(255, 224, 58, 58)),),
                                                                SizedBox(
                                                                  width: Dimensions.widht200,
                                                                  child: Text(order['Issue']??order['Description(Optional)'],
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                                                )
                                                              
                                                              ],
                                                            ),
                                                            SizedBox(height: Dimensions.height10,),
                                                            Row(
                                                              children: [
                                                                 Row(
                                                              children: [
                                                                Text('Car : ',style: TextStyle(
                                                                  fontSize: Dimensions.height15,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: const Color.fromARGB(255, 224, 58, 58)),),
                                                                Text(order['Car brand']??'',style: TextStyle(fontWeight: FontWeight.bold),),
                                                                SizedBox(width: Dimensions.widht10,
                                                                  child: Text('-',style: TextStyle(fontWeight: FontWeight.bold),),
                                                                ),
                                                                Text(order['Car model']??'',style: TextStyle(fontWeight: FontWeight.bold),)
                                                              ],
                                                            ),
                                                            SizedBox(width: Dimensions.widht46,),
                                                                Text('Plate Number : ',style: TextStyle(
                                                                  fontSize: Dimensions.height15,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: const Color.fromARGB(255, 224, 58, 58)),),
                                                                Text(order['Plate number']??'',style: TextStyle(fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                             SizedBox(height: Dimensions.height15,),
                                                            Row(
                                                              children: [
                                                                Text('Order Status: ',style: TextStyle(
                                                                  fontSize: Dimensions.height15,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: const Color.fromARGB(255, 224, 58, 58)),),
                                                                Text(order['Confirmed Status']??'',style: TextStyle(fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                            SizedBox(height: Dimensions.height35,),
                                                            order['Status'] == 'Completed'
                                                            ?Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Center(
                                                                  child: Container(
                                                                    height: Dimensions.height35,
                                                                    decoration: BoxDecoration(
                                                                      color:const Color.fromARGB(255, 0, 0, 0) ,
                                                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                                                    ),
                                                                    child: TextButton(
                                                                      onPressed: () {
                                                                        Navigator.of(context).push(
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Orderdetails(
                                                                             documentName: '${FirebaseAuth.instance.currentUser?.email} - ${order['Date and Time']} - ${order['Service']}',
                                                                          ),
                                                                        ),
                                                                      );
                                                                      },
                                                                      child:  Text(
                                                                        'View Receipt',
                                                                        style: TextStyle(
                                                                          fontSize: Dimensions.height15,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: const Color.fromARGB(255, 255, 255, 255),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                            :Container()
                                                           
                                                          
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                    );
                                      },
                                      child:  Text(
                                        'More',
                                        style: TextStyle(
                                          fontSize:  Dimensions.height15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                     SizedBox(width: Dimensions.widht10),
                                    TextButton(
                                      onPressed: () {
                                        _launchPhoneCall();
                                      },
                                      child:  Text(
                                        'Contact us',
                                        style: TextStyle(
                                          fontSize: Dimensions.height15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date of order",
                                  style: TextStyle(
                                    fontSize:  Dimensions.height15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  order['Date and Time'] ?? '',
                                  style:  TextStyle(
                                    fontSize:  Dimensions.height15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  :Container();
                }
                
              );
            }
          },
        ),
      ),
    );
  }
}