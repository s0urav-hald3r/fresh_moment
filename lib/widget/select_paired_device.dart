import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../configs/size_configs.dart';
import '../controller/cart_controller.dart';

class SelectPairedDevice extends StatefulWidget {
  const SelectPairedDevice({Key? key}) : super(key: key);

  @override
  _SelectPairedDeviceState createState() => _SelectPairedDeviceState();
}

class _SelectPairedDeviceState extends State<SelectPairedDevice> {
  final List<BluetoothDevice> _devices = [];
  PrinterBluetooth? _selectedDevice;
  final FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();

  bool _isLoading = false;
  CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _bluetooth.devices.listen((device) {
      setState(() {
        _devices.add(device);
      });
    });
  }

  searchDevices() async {
    setState(() {
      _isLoading = true;
    });
    await _bluetooth.startScan(pairedDevices: false);
    Future.delayed(const Duration(seconds: 2), (() {
      setState(() {
        _isLoading = false;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Select paired device',
            style: TextStyle(
                fontSize: SizeConfig.screenWidth! * 0.05,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              onPressed: () => searchDevices(), icon: const Icon(Icons.refresh))
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
            : _devices.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children:
                          List<Widget>.generate(_devices.length, (int index) {
                        return GestureDetector(
                          onTap: () => _onSelectDevice(index),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _devices[index].name,
                                  style: TextStyle(
                                    color: _selectedDevice?.address ==
                                            _devices[index].address
                                        ? Colors.blue
                                        : Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _devices[index].address,
                                  style: TextStyle(
                                    color: _selectedDevice?.address ==
                                            _devices[index].address
                                        ? Colors.blueGrey
                                        : Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Scan new bluetooth device and pair',
                          style: TextStyle(fontSize: 24, color: Colors.blue),
                        ),
                        MaterialButton(
                          onPressed: () => searchDevices(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.bluetooth_rounded,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Scan device',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.redAccent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  void _onSelectDevice(int index) async {
    setState(() {
      _isLoading = true;
    });
    BluetoothDevice blueDevice = _devices[index];
    debugPrint('B D ' + blueDevice.toString());
    List deviceDetails = [
      blueDevice.name,
      blueDevice.address,
      blueDevice.paired,
    ];
    cartController.deviceConnected.value = true;
    await GetStorage()
        .write(SizeConfig.bluetoothDeviceDetails, deviceDetails)
        .whenComplete(() => Get.back());
  }
}
