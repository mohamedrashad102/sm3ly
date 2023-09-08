import 'package:flutter/material.dart';
import 'package:sm3ly/constant.dart';

class SettingsColumnItem extends StatelessWidget {
  const SettingsColumnItem({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(20),
        child: children[index],
      ),
      separatorBuilder: (context, index) => Container(
        height: 1,
        width: double.infinity,
        color: MyColors.textButton,
      ),
      itemCount: children.length,
    );
  }
}
