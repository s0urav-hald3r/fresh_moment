import 'package:flutter/material.dart';
import 'package:fresh_moment/controller/cart_controller.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../configs/size_configs.dart';
import '../controller/dish_controller.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Get.put(DishController());
    Get.put(CartController());
    Future.delayed(
        const Duration(seconds: 3),
        (() => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/animations/splash.json',
            height: SizeConfig.screenHeight! * 0.5),
      ),
    );
  }
}
