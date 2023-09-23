import 'package:flutter/material.dart';
import 'package:kasir_app/app/theme/app_theme.dart';

class InitialImage extends StatelessWidget {
  const InitialImage({
    super.key,
    required this.text,
    this.fontSize = 16,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kSmallRadius),
        color: Colors.black12,
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: fontSize,
            wordSpacing: 0,
            letterSpacing: 0,
          ),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
