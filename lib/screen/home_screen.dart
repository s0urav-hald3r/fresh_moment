import 'package:flutter/material.dart';
import 'package:fresh_moment/configs/size_configs.dart';
import 'package:fresh_moment/controller/dish_controller.dart';
import 'package:fresh_moment/screen/add_dish.dart';
import 'package:fresh_moment/screen/bluetooth_settings.dart';
import 'package:fresh_moment/widget/loader.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controller/cart_controller.dart';
import '../widget/dish_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DishController dishController = Get.find<DishController>();
  CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    dishController.restoreDish();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Fresh Moment',
              style: TextStyle(
                  fontSize: SizeConfig.screenWidth! * 0.05,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
              onPressed: () {
                Get.to(const BluetoothSettings());
              },
              icon: Icon(
                Icons.bluetooth,
                color: Colors.red,
                size: SizeConfig.screenWidth! * 0.06,
              )),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddDish()));
              },
              icon: Icon(
                Icons.add,
                size: SizeConfig.screenWidth! * 0.06,
              ),
            )
          ],
        ),
        body: dishController.loading.value
            ? const Center(child: Loader())
            : dishController.dishList.isEmpty
                ? Center(
                    child: Text('No Dish Found !',
                        style: TextStyle(
                            fontSize: SizeConfig.screenWidth! * 0.05,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold)),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 10,
                          bottom: cartController.cartLength > 0
                              ? SizeConfig.screenWidth! * 0.4
                              : 10),
                      child: Wrap(
                        spacing: SizeConfig.screenWidth! * 0.0245,
                        runSpacing: SizeConfig.screenWidth! * 0.03,
                        children: dishController.dishList
                            .map(
                              (e) => DishCard(
                                dish: e,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
        floatingActionButton: cartController.cartLength > 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                      heroTag: 'cancelTag',
                      onPressed: () {
                        cartController.resetCart();
                      },
                      label: Row(
                        children: [
                          Icon(
                            Icons.restore,
                            size: SizeConfig.screenWidth! * 0.06,
                          ),
                          const Gap(10),
                          Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  const Gap(20),
                  FloatingActionButton.extended(
                      heroTag: 'cartTag',
                      onPressed: (() => cartController.generateBill()),
                      label: Row(
                        children: [
                          Text(
                            'Items : ',
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                          const Gap(5),
                          Text(
                            cartController.cartLength.toString(),
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                          const Gap(10),
                          Text(
                            '||',
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                          const Gap(10),
                          Text(
                            'Price : ₹ ',
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                          const Gap(5),
                          Text(
                            cartController.totalCartPrice.toString(),
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ))
                ],
              )
            : const SizedBox(),
      );
    });
  }
}
