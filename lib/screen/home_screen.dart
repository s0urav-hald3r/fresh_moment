import 'package:flutter/material.dart';
import 'package:fresh_moment/configs/size_configs.dart';
import 'package:fresh_moment/controller/dish_controller.dart';
import 'package:fresh_moment/screen/add_dish.dart';
import 'package:fresh_moment/widget/loader.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../widget/dish_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DishController dishController = Get.find<DishController>();
  

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
                : Padding(
                    padding: const EdgeInsets.all(10.0),
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
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AddDish()));
            },
            label: Row(
              children: [
                Icon(
                  Icons.add,
                  size: SizeConfig.screenWidth! * 0.06,
                ),
                const Gap(10),
                Text(
                  'Add Dish',
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth! * 0.04,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
      );
    });
  }
}
