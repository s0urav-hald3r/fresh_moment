import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fresh_moment/widget/snack_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../configs/size_configs.dart';
import '../controller/dish_controller.dart';
import '../widget/loader.dart';

class AddDish extends StatefulWidget {
  const AddDish({Key? key}) : super(key: key);

  @override
  State<AddDish> createState() => _AddDishState();
}

class _AddDishState extends State<AddDish> {
  String? _image;
  TextEditingController _dishNameController = TextEditingController();
  TextEditingController _dishPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var uuid = const Uuid();

  DishController dishController = Get.find<DishController>();

  void _imgFromGallery() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = pickedFile!.path;
    });
  }

  @override
  void initState() {
    _dishNameController = TextEditingController();
    _dishPriceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _dishNameController.dispose();
    _dishPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Dish',
            style: TextStyle(
                fontSize: SizeConfig.screenWidth! * 0.05,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _imgFromGallery();
                    },
                    child: _image != null
                        ? Container(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenWidth! * 0.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(_image!)))))
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius: BorderRadius.circular(20)),
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenWidth! * 0.5,
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: SizeConfig.screenWidth! * 0.25,
                              color: Colors.purple,
                            ),
                          ),
                  ),
                  const Gap(20),
                  TextFormField(
                      controller: _dishNameController,
                      validator: (String? val) {
                        if (val == null || val.isEmpty) {
                          return '*madnatory';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(
                          Icons.title_outlined,
                        ),
                        label: Text("Dish Name",
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * 0.05,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold)),
                      )),
                  const Gap(20),
                  TextFormField(
                    controller: _dishPriceController,
                    validator: (String? val) {
                      if (val == null || val.isEmpty) {
                        return '*madnatory';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(
                        Icons.currency_rupee_rounded,
                      ),
                      label: Text("Dish Price",
                          style: TextStyle(
                              fontSize: SizeConfig.screenWidth! * 0.05,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Gap(20),
                  MaterialButton(
                    color: Colors.purple,
                    minWidth: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight! * 0.075,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_image == null) {
                          CustomSnackBar.showSnack(
                              'Error', 'Please Add Dish Image');
                        } else {
                          dishController
                              .addDish(
                                  uuid.v4(),
                                  _image!,
                                  _dishNameController.text.trim(),
                                  double.tryParse(
                                      _dishPriceController.text.trim())!)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        }
                      }
                    },
                    child: dishController.loading.value
                        ? const Loader()
                        : Text(
                            "ADD",
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.screenWidth! * 0.05,
                            ),
                          ),
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
