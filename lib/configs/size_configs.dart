//abhishek360

import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  static double? safeAreaTop;
  static double? safeAreaBottom;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;

    double? topPadding = _mediaQueryData?.padding.top;
    double? bottomPadding = _mediaQueryData?.padding.bottom;

    safeAreaTop = topPadding;
    safeAreaBottom = bottomPadding;
  }

  static const bluetoothDeviceDetails = "bluetooth_device_details";
  static const slNo = "serial_number";
  static const totalEarnings = "total_earnings";
}
