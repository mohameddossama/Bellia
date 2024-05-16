import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Orderdetails extends StatefulWidget {
 final String documentName ;
  const Orderdetails({super.key, required this.documentName});

  @override
  State<Orderdetails> createState() => _OrderdetailsState();
}

class _OrderdetailsState extends State<Orderdetails> {

Future<DocumentSnapshot> fetchOrderDocument(String documentName) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(documentName)
        .get();

    return snapshot;
  } catch (error) {
    print("Error fetching order document: $error");
    throw error;
  }
}

  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: fetchOrderDocument(widget.documentName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching order data'));
        } else {
          Map<String, dynamic>? orderData = snapshot.data?.data() as Map<String, dynamic>?;
          if (orderData == null) {
            return Center(child: Text('No data found for this order'));
          }
          // Use orderData to populate your UI
          return buildOrderDetailsUI(orderData);
        }
      },
    );
  }

  Widget buildOrderDetailsUI(Map<String, dynamic> orderData) {
    // Build your UI using the orderData
    // Example:
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text('Service: ${orderData['Service']}'),
          Text('Date and Time: ${orderData['Date and Time']}'),
          Text('Date and Time: ${orderData['Price']}'),
          Text('Date and Time: ${orderData['Plate number']}'),
         
          // Add more Text widgets to display other order details
        ],
      ),
    );
  }
}