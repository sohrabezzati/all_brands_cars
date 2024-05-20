import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final Widget title;
  final Color? backGroundColor;
  final bool centerTittle;
  final TextStyle? textStyle;
  final Widget iconButton;

  const AppBarWidget({
    Key? key,
    required this.title,
    required this.backGroundColor,
    required this.centerTittle,
    required this.textStyle,
    required this.iconButton,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: title,
      centerTitle: centerTittle,
      backgroundColor: backGroundColor,
      titleTextStyle: textStyle,
      leading: iconButton,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width) *
          30);
}
