import 'package:flutter/material.dart';
import 'package:kasir_app/app/theme/app_theme.dart';

class IRCardItemHome extends StatelessWidget {
  const IRCardItemHome({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
    this.labelStyle,
    this.width = double.maxFinite,
    this.height = 80,
  });

  final String label;
  final TextStyle? labelStyle;
  final Widget icon;
  final VoidCallback? onTap;
  final Color? color;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        // fit: StackFit.expand,
        children: [
          Container(
            height: height,
            width: width,
            padding: const EdgeInsets.symmetric(
                horizontal: kSmallPadding, vertical: kDeffaultPadding),
            // constraints: BoxConstraints(
            //   minWidth: double.maxFinite,
            //   minHeight: 70,
            //   maxHeight: 80,
            // ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(kRadiusDeffault),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.shopping_bag_rounded,
                //   color: Colors.blue[300],
                // ),
                icon,
                Text(
                  label,
                  style: labelStyle,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(kRadiusDeffault),
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
