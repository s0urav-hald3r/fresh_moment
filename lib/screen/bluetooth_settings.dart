import 'package:flutter/material.dart';
import 'package:fresh_moment/controller/cart_controller.dart';
import 'package:fresh_moment/widget/loader.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../configs/size_configs.dart';
import '../controller/bluetooth_controller.dart';

class BluetoothSettings extends StatefulWidget {
  const BluetoothSettings({Key? key}) : super(key: key);

  @override
  State<BluetoothSettings> createState() => _BluetoothSettingsState();
}

class _BluetoothSettingsState extends State<BluetoothSettings> {
  BluetoothxController bluetoothController = Get.find<BluetoothxController>();
  CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Bluetooth Settings',
                style: TextStyle(
                    fontSize: SizeConfig.screenWidth! * 0.05,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold)),
          ),
          body: Center(
              child: cartController.loading.value
                  ? const Loader()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          color: bluetoothController.isDevicePresent.value
                              ? Colors.red
                              : Colors.green,
                          textColor: Colors.white,
                          minWidth: SizeConfig.screenWidth! * 0.7,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          height: SizeConfig.screenWidth! * 0.125,
                          onPressed: () {
                            bluetoothController.isDevicePresent.value
                                ? bluetoothController.disConnectDevice()
                                : bluetoothController.connectDevice();
                          },
                          child: Text(
                              bluetoothController.isDevicePresent.value
                                  ? 'Delete Device'
                                  : 'Add Device',
                              style: TextStyle(
                                  fontSize: SizeConfig.screenWidth! * 0.05,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const Gap(40),
                        Text(
                            'Today\'s Earning : ${cartController.totalEarning}',
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth! * 0.05,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold)),
                        const Gap(40),
                        MaterialButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          minWidth: SizeConfig.screenWidth! * 0.7,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          height: SizeConfig.screenWidth! * 0.125,
                          onPressed: () {
                            cartController.resetTotalEaringsAndSerialNumer();
                          },
                          child: Text('Reset Today\'s Statistics',
                              style: TextStyle(
                                  fontSize: SizeConfig.screenWidth! * 0.05,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    )),
        ));
  }
}
