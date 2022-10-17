import 'package:flutter/material.dart';
import 'package:fresh_moment/controller/bluetooth_controller.dart';
import 'package:fresh_moment/controller/cart_controller.dart';
import 'package:fresh_moment/controller/dish_controller.dart';
import 'package:fresh_moment/screen/home_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'configs/app_theme.dart';

void main() async {
  await GetStorage.init();
  Get.lazyPut(() => DishController());
  Get.lazyPut(() => CartController());
  Get.lazyPut(() => BluetoothxController(), fenix: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fresh Moment',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const HomeScreen(),
    );
  }
}
