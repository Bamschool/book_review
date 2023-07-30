import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLine;
  final TextOverflow? overflow;
  const AppFonts({
    Key? key,
    required this.text,
    this.size = 15,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.white,
    this.textAlign = TextAlign.left,
    this.maxLine,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: overflow,
      style: GoogleFonts.notoSans(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
