import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Transform.scale(
            scale: 0.75,
            child: const CircularProgressIndicator(
              strokeWidth: 4,
              color: Colors.purple,
            )),
      ),
    );
  }
}
