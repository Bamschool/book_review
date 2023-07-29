import 'package:flutter/material.dart';

import 'package:review_book/src/common/components/app_font.dart';

class Btn extends StatelessWidget {
  final Function() onTap;
  final String text;
  final Color? backgroundColor;

  const Btn({
    Key? key,
    required this.onTap,
    required this.text,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xffF4aa2b),
          borderRadius: BorderRadius.circular(7),
        ),
        child: AppFonts(
          text: text,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
