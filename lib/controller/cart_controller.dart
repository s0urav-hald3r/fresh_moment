import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:fresh_moment/configs/size_configs.dart';
import 'package:fresh_moment/controller/dish_controller.dart';
import 'package:fresh_moment/widget/select_paired_device.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../model/dish.dart';

class CartController extends GetxController {
  RxList cartList = [].obs;
  Map itemCount = {}.obs;
  double totalPrice = 0.0;
  RxDouble totalEarning = 0.0.obs;
  int slNo = 0;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    slNo = GetStorage().read(SizeConfig.slNo) ?? 1;
    totalEarning.value = GetStorage().read(SizeConfig.totalEarnings) ?? 0.0;
  }

  DishController dishController = Get.find<DishController>();

  addDish(String dishId) {
    cartList.add(dishId);
    if (itemCount.containsKey(dishId)) {
      itemCount.update(dishId, (value) => value + 1);
    } else {
      itemCount.addAll({dishId: 1});
    }
    totalPrice += dishController.dishList
        .firstWhere((element) => element.id == dishId)
        .dishPrice;
  }

  removeDish(String dishId) {
    if (cartList.contains(dishId)) {
      cartList.remove(dishId);
      itemCount.update(dishId, (value) => value - 1);
    }
    totalPrice -= dishController.dishList
        .firstWhere((element) => element.id == dishId)
        .dishPrice;
  }

  resetCart() {
    cartList.clear();
    itemCount.clear();
    totalPrice = 0.0;
  }

  Future incrementSlNo() async {
    slNo = GetStorage().read(SizeConfig.slNo) ?? 1;
    totalEarning.value = GetStorage().read(SizeConfig.totalEarnings) ?? 0.0;
    slNo += 1;
    totalEarning.value += totalPrice;
    await GetStorage().write(SizeConfig.slNo, slNo);
    await GetStorage().write(SizeConfig.totalEarnings, totalEarning.value);
  }

  resetTotalEaringsAndSerialNumer() async {
    loading.value = true;
    await GetStorage().remove(SizeConfig.slNo);
    await GetStorage().remove(SizeConfig.totalEarnings);
    slNo = 1;
    totalEarning.value = 0.0;
    loading.value = false;
  }

  get cartLength => cartList.length;
  get totalCartPrice => totalPrice;
  get slNumber => slNo;

  generateBill() async {
    List<dynamic>? blueDevice =
        GetStorage().read(SizeConfig.bluetoothDeviceDetails);
    if (blueDevice == null) {
      Get.to(const SelectPairedDevice());
      //this means no device configuration has been saved, so redirect to selection screen of bluetooth screen
    } else {
      debugPrint('Bluetooth Device ' + blueDevice.toString());
      BluetoothDevice device = BluetoothDevice.fromJson({
        "name": blueDevice[0],
        "address": blueDevice[1],
        "type": 0,
        "connected": true
      });

      PrinterBluetooth printer = PrinterBluetooth(device);
      PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
      _printerManager.selectPrinter(printer);
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();

      final PosPrintResult res =
          await _printerManager.printTicket((await printBill(paper, profile)));

      if (res.msg != 'Success') {
        Get.snackbar(
          "Error",
          "Printer Connection Lost",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(const SelectPairedDevice());
      } else {
        incrementSlNo().then((value) => resetCart());
      }
    }
  }

  Future<List<int>> printBill(
      PaperSize paper, CapabilityProfile profile) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];

    bytes += ticket.row([
      PosColumn(
        text: 'Sl No. : $slNo ',
        width: 4,
        styles: const PosStyles(
          align: PosAlign.left,
          bold: true,
        ),
      ),
      PosColumn(
        width: 8,
        text: 'Date :' + DateFormat('d/M/y').add_jm().format(DateTime.now()),
        styles: const PosStyles(
          align: PosAlign.right,
          bold: true,
        ),
      ),
    ]);

    bytes += ticket.hr();

    bytes += ticket.text('Fresh Moment',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          width: PosTextSize.size2,
        ));

    bytes += ticket.emptyLines(1);

    bytes += ticket.text(
      'Jail Maidan, Lalgola - (M) : 7797094088',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        width: PosTextSize.size1,
      ),
    );

    bytes += ticket.hr();

    List cart = cartList.toSet().toList();
    for (var cartItemId in cart) {
      Dish dish = dishController.dishList
          .firstWhere((element) => element.id == cartItemId);

      bytes += ticket.row([
        PosColumn(
          text: dish.dishName + ' ',
          width: 10,
          styles: const PosStyles(
              align: PosAlign.left, bold: true, width: PosTextSize.size1),
        ),
        PosColumn(
          width: 2,
          text: 'x ' + itemCount[cartItemId].toString(),
          styles: const PosStyles(
              align: PosAlign.right, bold: true, width: PosTextSize.size1),
        ),
      ]);
    }

    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(
        width: 8,
        text: 'Total Amount : ',
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        width: 4,
        text: 'Rs. ' + totalPrice.toStringAsFixed(2),
        styles: const PosStyles(
          align: PosAlign.right,
          bold: true,
          width: PosTextSize.size1,
        ),
      )
    ]);

    bytes += ticket.feed(1);

    bytes += ticket.hr();

    bytes += ticket.text('Thank you! Visit Again',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += ticket.text('- Choton Da',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += ticket.hr();
    bytes += ticket.cut();
    return bytes;
  }
}
