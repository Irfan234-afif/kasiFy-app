import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class IRContainerShadow extends StatelessWidget {
  const IRContainerShadow({
    super.key,
    this.borderRadius,
    this.padding,
    this.color,
    this.child,
    this.height,
    this.width,
    this.constraints,
  });

  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Widget? child;
  final double? height, width;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: DefaultTextStyle(
        style: textTheme.titleMedium!.copyWith(fontSize: 18),
        child: Container(
          height: height,
          width: width,
          padding: padding ?? EdgeInsets.all(kDeffaultPadding),
          constraints:
              constraints ?? BoxConstraints(minWidth: double.maxFinite),
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius:
                borderRadius ?? BorderRadius.circular(kRadiusDeffault),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
