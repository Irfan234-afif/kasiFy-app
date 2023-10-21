import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kasir_app/app/widget/initial_image.dart';

import '../theme/app_theme.dart';

class TileItem extends StatelessWidget {
  const TileItem({
    super.key,
    required this.sizeImage,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.leadingText = '',
    required this.isLeadingImage,
    this.onTap,
    this.enabled = true,
  });

  final double sizeImage;
  final String title, subtitle, trailing, leadingText;
  final bool isLeadingImage, enabled;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      onLongPress: () {},
      onTap: onTap,
      minVerticalPadding: 15,
      contentPadding: EdgeInsets.symmetric(horizontal: kSmallPadding),
      leading: isLeadingImage
          ? SizedBox(
              height: sizeImage,
              width: sizeImage,
              child: CircleAvatar(
                backgroundColor: kCircleAvatarBackground,
                child: Image.asset(
                  'assets/images/drink-${Random().nextInt(4) + 1}.png',
                  fit: BoxFit.contain,
                ),
              ),
            )
          : SizedBox(
              width: 50,
              height: 50,
              child: InitialImage(
                text: leadingText,
              ),
            ),
      title: Text(
        title,
      ),
      subtitle: Text(
        subtitle,
      ),
      trailing: Text(
        trailing,
      ),
    );
  }
}
