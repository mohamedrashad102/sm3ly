import 'package:flutter/material.dart';

import 'custom_text.dart';

class SettingsRowItem extends StatelessWidget {
  const SettingsRowItem({
    super.key,
    required this.trailing,
    required this.title,
    this.onPressed,
  });

  final String title;
  final Widget trailing;
  final  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Row(
        children: [
          CustomText(
            text: title,
            color: Colors.black,
            fontSize: 20,
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}
