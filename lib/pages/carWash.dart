import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/customerInfo.dart';
import 'package:fluttercourse/pages/locationPicker.dart';

class CarWash extends StatefulWidget {
  const CarWash({Key? key}) : super(key: key);

  @override
  State<CarWash> createState() => _CarWashState();
}

class _CarWashState extends State<CarWash> {
  int selectedPackageIndex = -1; // Initially no package is selected
  int selectedPackageeIndex = -1; // Initially no package is selected
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTime? selectedDatee;
  TimeOfDay? selectedTimee;

  List OurCenterpackages = [
    {
      "title": "Quick Shine",
      "subtitle":
          "Thorough exterior wash,\nWheel cleaning included,\nHand drying for spot-free finish",
      "price": "30 EGP"
    },
    {
      "title": "Shine & Detail",
      "subtitle":
          "Comprehensive exterior wash,\nHand-applied wax treatment for enhanced shine and protection,\nMeticulous interior detailing  including vacuuming, upholstery shampooing, and leather conditioning",
      "price": "60 EGP"
    },
    {
      "title": "Ultimate Cleanse",
      "subtitle":
          "Complete interior and exterior rejuvenation Exterior wash with ,\nHigh-quality products,\nThorough undercarriage wash",
      "price": "100 EGP"
    }
  ];

  List yourlocationpackages = [
    {
      "title": "On-the-Go Refresh",
      "subtitle":
          "Professional exterior wash at your doorstep ,\n Hand washing and drying ",
      "price": "50 EGP"
    },
    {
      "title": "VIP Mobile Spa",
      "subtitle":
          "Comprehensive exterior and interior cleaning ,\n Includes interior vacuuming, window cleaning, and tire dressing",
      "price": "80 EGP"
    },
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _submit() {
    if (selectedPackageIndex != -1 &&
        selectedDate != null &&
        selectedTime != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Selected Choices"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Package: ${OurCenterpackages[selectedPackageIndex]["title"]}"),
                Text(
                    "Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                Text("Time: ${selectedTime!.hour}:${selectedTime!.minute}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a package, date, and time.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDatee(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null && picked != selectedDatee) {
      setState(() {
        selectedDatee = picked;
      });
    }
  }

  void _submitt() {
    if (selectedPackageeIndex != -1 &&
        selectedDatee != null &&
        selectedTimee != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Selected Choices"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Package: ${yourlocationpackages[selectedPackageeIndex]["title"]}"),
                Text(
                    "Date: ${selectedDatee!.day}/${selectedDatee!.month}/${selectedDatee!.year}"),
                Text("Time: ${selectedTimee!.hour}:${selectedTimee!.minute}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a package, date, and time.',style: TextStyle(color: Color.fromARGB(255, 255, 20, 3)),),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  Future<void> _selectTimee(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTimee) {
      setState(() {
        selectedTimee = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 224, 58, 58),
          bottom: const TabBar(
            indicatorColor: Color.fromARGB(255, 197, 181, 181),
            indicatorWeight: 5,
            unselectedLabelStyle: TextStyle(fontSize: 9),
            labelColor: Color.fromARGB(255, 255, 246, 246),
            tabs: [
              Tab(
                icon: Icon(Icons.build_circle_outlined),
                text: "Our Center",
              ),
              Tab(
                icon: Icon(Icons.add_location_alt_outlined),
                text: "Your Place",
              ),
            ],
          ),
          title: const Text(
            "Car Wash Service",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: TabBarView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Packages",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: OurCenterpackages.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPackageIndex = i;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: selectedPackageIndex == i
                                  ? Colors.green[200]
                                  : Colors.grey[200],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  OurCenterpackages[i]["title"],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  OurCenterpackages[i]["subtitle"],
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  OurCenterpackages[i]["price"],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(selectedDate == null
                        ? 'Select Date'
                        : 'Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text(selectedTime == null
                        ? 'Select Time'
                        : 'Time: ${selectedTime!.hour}:${selectedTime!.minute}'),
                  ),
                  // const SizedBox(height: 10),
                  // ElevatedButton(
                  //   onPressed: (){
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const location_picker_page(service_name: "maintenance")));
                  //   },
                  //   child: const Text('Select Location'),
                  // ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CustomerInfo()));
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Packages",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: yourlocationpackages.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPackageeIndex = i;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: selectedPackageeIndex == i
                                  ? Colors.green[200]
                                  : Colors.grey[200],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  yourlocationpackages[i]["title"],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  yourlocationpackages[i]["subtitle"],
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  yourlocationpackages[i]["price"],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectDatee(context),
                    child: Text(selectedDatee == null
                        ? 'Select Date'
                        : 'Date: ${selectedDatee!.day}/${selectedDatee!.month}/${selectedDatee!.year}'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _selectTimee(context),
                    child: Text(selectedTimee == null
                        ? 'Select Time'
                        : 'Time: ${selectedTimee!.hour}:${selectedTimee!.minute}'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const location_picker_page(service_name: "maintenance")));
                    },
                    child: const Text('Select Location'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CustomerInfo()));
                    },
                    // _submitt,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
