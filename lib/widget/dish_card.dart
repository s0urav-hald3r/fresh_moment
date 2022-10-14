import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../configs/size_configs.dart';
import '../controller/cart_controller.dart';
import '../controller/dish_controller.dart';
import '../model/dish.dart';

class DishCard extends StatelessWidget {
  final Dish dish;
  DishCard({Key? key, required this.dish}) : super(key: key);

  final DishController dishController = Get.find<DishController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black12),
      child: Column(children: [
        InkWell(
          onTap: (() => cartController.addDish(dish.id)),
          onLongPress: (() {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.purple,
                    title: const Text('Do you really want to delete?'),
                    titleTextStyle: TextStyle(
                        fontSize: SizeConfig.screenWidth! * 0.05,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No',
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * 0.05,
                                letterSpacing: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () {
                          dishController.deleteDish(dish.id);
                          Navigator.pop(context);
                        },
                        child: Text('Yes',
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * 0.05,
                                letterSpacing: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                });
          }),
          child: Container(
              width: SizeConfig.screenWidth! * 0.3,
              height: SizeConfig.screenWidth! * 0.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(dish.imageUrl))))),
        ),
        const Gap(5),
        SizedBox(
          width: SizeConfig.screenWidth! * 0.3,
          child: Text(dish.dishName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: SizeConfig.screenWidth! * 0.04,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold)),
        ),
        const Gap(5),
        Text(dish.dishPrice.toString(),
            style: TextStyle(
                fontSize: SizeConfig.screenWidth! * 0.03,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold)),
        const Gap(5),
        SizedBox(
          width: SizeConfig.screenWidth! * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: SizeConfig.screenWidth! * 0.04,
                  backgroundColor: Colors.redAccent,
                  child: IconButton(
                    onPressed: (() => cartController.removeDish(dish.id)),
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
                Obx(() => CircleAvatar(
                      radius: SizeConfig.screenWidth! * 0.04,
                      backgroundColor: Colors.white,
                      child: Text(
                          (cartController.itemCount[dish.id] ?? 0).toString(),
                          style: TextStyle(
                              fontSize: SizeConfig.screenWidth! * 0.04,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold)),
                    )),
                CircleAvatar(
                  radius: SizeConfig.screenWidth! * 0.04,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    onPressed: (() => cartController.addDish(dish.id)),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
