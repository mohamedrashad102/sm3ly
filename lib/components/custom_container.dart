import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            const Color(0xff1E2E3D), //0xffC5BAC4
            const Color(0Xff152534),
            const Color(0xff0C1C2C).withOpacity(0.8) //0xffC5BAC4
          ],
        ),
      ),
      child: child,
    );
  }
}
