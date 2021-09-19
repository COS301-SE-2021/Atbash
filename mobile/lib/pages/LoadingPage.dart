import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SvgPicture.asset(
            "assets/atbash.svg",
            width: 256,
          ),
        ),
      ),
    );
  }
}
