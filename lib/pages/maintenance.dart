import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:fluttercourse/pages/orders.dart';

class CustomIcons {
  static const IconData pipe = IconData(0xe7f4, fontFamily: 'CustomIcons');
}

class Maintenance extends StatefulWidget {
  const Maintenance({super.key});

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  List<Map<String, dynamic>> maintenanceTasks = [
    {"task": "Tire Replacement and repairs", "image": "assets/icons/tire.png"},
    {"task": "Suspentions inspection", "image": "assets/icons/suspentions.png"},
    {"task": "Brake system maintenance", "image": "assets/icons/brake.png"},
    {"task": "Oil Change", "image": "assets/icons/oil.png"},
    {"task": "Electronics inspection", "image": "assets/icons/electronics.png"},
    // {"task": "Transmission Service", "icon": carTransmissionIcon,"image": "images/air.png"},
    // {"task": "Diagnostic Services", "icon": diagnosticServicesIcon,"image": "images/air.png"},
    {
      "task": "Air and oil Filter Replacement",
      "image": "assets/icons/filter.png"
    },
    // {"task": "Cooling System Service", "icon": coolingSystemServiceIcon,"image": "images/air.png"},
    {"task": "Steering System maintenance", "image": "assets/icons/wheel.png"},
    {
      "task": "Battery Testing and Replacement",
      "image": "assets/icons/battery.png"
    },
    // {"task": "Wheel Alignment and Balancing", "icon": wheelAlignmentIcon,"image": "images/wheel.png"},
    {"task": "Routine Maintenance", "image": "assets/icons/routine.png"},
    {
      "task": "Engin Cooling maintenance",
      "image": "assets/icons/carCooling.png"
    },
    {"task": "Air Conditior maintenance", "image": "assets/icons/air.png"},
    {
      "task": "Exhausted System maintenance ",
      "image": "assets/icons/exhaust.png"
    },
  ];

  final TextEditingController firstNameController =
      TextEditingController(text: 'Mohamed');
  final TextEditingController lastNameController =
      TextEditingController(text: 'Ali');
  final TextEditingController mobileNumberController =
      TextEditingController(text: '01125564479');
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController carNameController =
      TextEditingController(text: 'BMW');
  final TextEditingController carModelController =
      TextEditingController(text: '6X');
  final TextEditingController arabicController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  final List<String> divingLicenseValues = ["2", "5", "9", "4", "ط", "ج", "س"];

  List<bool> isSelected = List.generate(12, (index) => false);
  int selectedItemIndex = -1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
          //centerTitle: true,
          title: const Text(
            "Car Maintenacne",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(
                  builder: (context) => const CommerceHome()));
            },
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 3.0,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 3.0,
                ),
                itemCount: maintenanceTasks.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected[index] = !isSelected[index];
                        selectedItemIndex = index;
                      });
                    },
                    // child: Card(
                    //   // color: isSelected[index]
                    //   //     ? const Color.fromARGB(255, 252, 142, 142)
                    //   //     :
                    //  color: const Color.fromARGB(255, 209, 205, 205),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 209, 205, 205),
                            border: Border.all(
                                color: isSelected[index]
                                    ? const Color.fromARGB(255, 247, 4, 4)
                                    : const Color.fromARGB(255, 209, 205, 205),
                                width: 4)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              maintenanceTasks[index]['image'],
                              height: 38,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              maintenanceTasks[index]['task'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            // Center(
                            //   child: Text('Item ${index + 1}'),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: firstNameController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: lastNameController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
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
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mobileNumberController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
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
                          borderRadius: BorderRadius.circular(15.0),
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
                        labelText: '5 6 3',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
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
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.text,
                controller: remarksController,
                textAlign: TextAlign.center,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Remarks (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 40.0),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 10.0,
                  ),
                  alignLabelWithHint: true,
                  prefixIcon: const SizedBox(width: 10),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const orderPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 224, 58, 58),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
