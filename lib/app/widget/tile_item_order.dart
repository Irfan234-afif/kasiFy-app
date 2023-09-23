import 'package:flutter/material.dart';

import '../model/order_model.dart';
import '../theme/app_theme.dart';
import '../util/util.dart';

class TileItemOrder extends StatelessWidget {
  const TileItemOrder({
    super.key,
    required this.data,
    this.onTap,
  });

  final VoidCallback? onTap;
  final ItemOrder data;
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final priceItem = currencyFormat(data.sellingPrice ?? '');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leadingAndTrailingTextStyle: themeData.textTheme.titleMedium!.copyWith(
        color: Colors.green,
        fontSize: 14,
      ),
      titleTextStyle: themeData.textTheme.titleMedium!.copyWith(
        color: Colors.black87,
      ),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(kSmallPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSmallRadius),
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: Text(
          '${data.quantity}x',
          style: themeData.textTheme.titleMedium!.copyWith(
            color: Colors.green,
            fontSize: 14,
          ),
        ),
      ),
      title: Text(
        data.name ?? '',
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.detail ?? '',
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
            child: Text(
              'Edit',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      trailing: Text(
        priceItem,
      ),
    );
  }
}
