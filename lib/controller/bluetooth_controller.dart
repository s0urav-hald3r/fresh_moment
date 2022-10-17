import 'package:fresh_moment/widget/select_paired_device.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../configs/size_configs.dart';

class BluetoothxController extends GetxController {
  RxBool isDeviceOn = false.obs;
  RxBool isDevicePresent = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkDevice();
    }

  checkDevice() {
    List<dynamic>? blueDevice =
        GetStorage().read(SizeConfig.bluetoothDeviceDetails);
    if (blueDevice == null) {
      isDevicePresent.value = false;
    } else {
      isDevicePresent.value = true;
    }
  }

  connectDevice() {
    Get.to(const SelectPairedDevice());
  }

  disConnectDevice() async {
    await GetStorage().remove(SizeConfig.bluetoothDeviceDetails);
    isDevicePresent.value = false;
  }
}
