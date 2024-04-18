import 'package:flutter/material.dart';
//import 'package:fluttercourse/dawer.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
//import 'package:fluttercourse/pages/maintenance.dart';
import 'package:fluttercourse/pages/order_details.dart';

class orderPage extends StatefulWidget {
  final data;
  const orderPage({super.key,this.data});


  @override
  State<orderPage> createState() => _orderPageState();
}

class _orderPageState extends State<orderPage> {
//  int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       Navigator.pop(context);
//     });
//   }

  List cardItems = [
    {
      "icon": Icons.car_repair_outlined,
      "service": " Car Maintenance",
      "status": "Waiting",
      "date": "29/2/2024"
    },
    {
      "icon": Icons.engineering_rounded,
      "service": "RoadSide Assistance",
      "status": "Waiting",
      "date": "29/2/2024"
    },
    {
      "icon": Icons.home,
      "service": "Garage",
      "status": "Confirmed",
      "date": "29/2/2024"
    },
    {
      "icon": Icons.water_drop,
      "service": "Car Wash",
      "status": "Canceled",
      "date": "29/2/2024"
    },
    {
      "icon": Icons.store,
      "service": "Bellia Mart",
      "status": "Confirmed",
      "date": "29/2/2024"
    },
    {
      "icon": Icons.car_crash_outlined,
      "service": "Car Tow",
      "status": "Canceled",
      "date": "29/2/2024"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
          //centerTitle: true,
          title: 
            const Text(
            'Orders',
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
      //endDrawer: DrawerNig(),
      body: Center(
        child: ListView.builder(
          itemCount: cardItems.length,
            itemBuilder:(context, i) {
              return Card(
              child: ListTile(
                leading:  Icon(cardItems[i]["icon"]),
                title:  Text(cardItems[i]["service"]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(cardItems[i]["status"]),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>order_details_page(service_name: "maintenance")));
                          },
                          child: const Text(
                            'More',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                        const SizedBox(
                            width: 40), // Add some space between the buttons
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {},
                trailing:  Text(cardItems[i]["date"]),
              ),
            );
            },
            
        ),
      ),
    );
  }
}
