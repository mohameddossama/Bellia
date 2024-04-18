import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercourse/pages/car.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() => _AddCarState();
}

final List<String> carColor = [
  'Black',
  'White',
  'Grey',
  'Red',
  'Blue',
  'Green'
];

class _AddCarState extends State<AddCar> {
  final addFormKey = GlobalKey<FormState>();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final plateLettersController = TextEditingController();
  final plateNumberController = TextEditingController();
  final mileageController = TextEditingController();
  String selectedColor = 'Black';

  @override
  void dispose() {
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
      resizeToAvoidBottomInset: false,
      appBar:  AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Car",
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 224, 58, 58),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: addFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter plate number";
                        } else if (!RegExp(
                                r'^([A-Z]{1,3}|[\u0621-\u064A](?: [\u0621-\u064A]){0,2})$')
                            .hasMatch(value)) {
                          return "Not valid";
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.characters,
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
                        if (value == null || value.isEmpty) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            if (value == null || value.isEmpty) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            if (value == null || value.isEmpty) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter car mileage";
                            } else if (!RegExp(r'^\d{1,4}(?:\.\d{1,2})?$')
                                .hasMatch(value)) {
                              return "Enter a valid value";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: '0.0',
                              suffixText: 'km',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15)),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedColor = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  if (addFormKey.currentState!.validate()) {
                   
                    Car newCar = Car(
                        brandController.text,
                        modelController.text,
                        selectedColor,
                        '${plateLettersController.text} - ${plateNumberController.text}');
                    
                    ownedCars.add(newCar);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Car Added'),
                            Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade800,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
