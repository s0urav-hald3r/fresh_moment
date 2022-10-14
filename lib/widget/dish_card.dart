import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../configs/size_configs.dart';
import '../controller/dish_controller.dart';
import '../model/dish.dart';

class DishCard extends StatelessWidget {
  final Dish dish;
  DishCard({Key? key, required this.dish}) : super(key: key);

  final DishController dishController = Get.find<DishController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
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
              },
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Delete Dish',
            ),
          ],
        ),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
                width: SizeConfig.screenWidth! * 0.25,
                height: SizeConfig.screenWidth! * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(dish.imageUrl))))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dish.dishName,
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth! * 0.05,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold)),
              Text(dish.dishPrice.toString(),
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth! * 0.04,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold)),
            ],
          )
        ]),
      ),
    );
  }
}
