import 'package:flutter/material.dart';
import 'dart:async';

class AvatarSlider extends StatefulWidget {
  const AvatarSlider({Key? key}) : super(key: key);

  @override
  _AvatarSliderState createState() => _AvatarSliderState();
}

class _AvatarSliderState extends State<AvatarSlider> {
  int currentIndex = 0;
  List<String> imagePaths = [
    'images/logo.PNG',
    'images/logo3.PNG',
    'images/logo.PNG',
  ];
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: CircleAvatar(
        radius: 90,
        key: ValueKey<int>(currentIndex),
        backgroundImage: AssetImage(imagePaths[currentIndex]),
      ),
    );
  }
}
