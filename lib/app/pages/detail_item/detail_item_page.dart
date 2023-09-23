import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/model/item_model.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/util/util.dart';
import 'package:kasir_app/app/widget/initial_image.dart';
import 'package:tabler_icons/tabler_icons.dart';

class DetailItemPage extends StatefulWidget {
  const DetailItemPage({super.key, required this.itemModel});

  final ItemModel itemModel;

  @override
  State<DetailItemPage> createState() => _DetailItemPageState();
}

class _DetailItemPageState extends State<DetailItemPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final itemModel = widget.itemModel;
    String identityItem = takeLetterIdentity(itemModel.name!);
    String basicPrice = currencyFormat(itemModel.basicPrice!);
    String sellingPrice = currencyFormat(itemModel.sellingPrice!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDeffaultPadding,
          vertical: kDeffaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: InitialImage(
                text: identityItem,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: kSmallPadding,
            ),
            Text(
              widget.itemModel.name!,
              style: textTheme.titleLarge,
            ),
            const SizedBox(
              height: kDeffaultPadding,
            ),
            Text(
              "Basic Price : $basicPrice",
              style: textTheme.titleSmall,
            ),
            Text(
              "Selling Price : $sellingPrice",
              style: textTheme.titleSmall,
            ),
            const SizedBox(
              height: kDeffaultPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TextLabel(
                  label: 'Code Product',
                  title: itemModel.codeProduct.toString(),
                ),
                _TextLabel(
                  label: 'Category',
                  title: itemModel.category!.categoryName!,
                ),
              ],
            ),
            const SizedBox(
              height: kDeffaultPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TextLabel(
                  label: 'Stock',
                  title: itemModel.stock.toString(),
                ),
                const _TextLabel(
                  label: 'Order Count',
                  title: '12',
                ),
              ],
            ),
            const SizedBox(
              height: kDeffaultPadding,
            ),
            Row(
              children: [
                _CustomElevated(
                  onTap: () {},
                  backgroundColor: Colors.red,
                  icon: TablerIcons.trash_x,
                  label: "Delete",
                ),
                const SizedBox(
                  width: kSmallPadding,
                ),
                _CustomElevated(
                  onTap: () {
                    context.goNamed(Routes.addItem, extra: itemModel);
                  },
                  icon: TablerIcons.edit,
                  label: 'Edit',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _CustomElevated extends StatelessWidget {
  const _CustomElevated({
    this.backgroundColor,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Color? backgroundColor;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              label,
            ),
          ],
        ),
      ),
    );
  }
}

class _TextLabel extends StatelessWidget {
  const _TextLabel({
    required this.label,
    required this.title,
  });

  final String label, title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.titleMedium!.copyWith(color: Colors.black45),
          ),
          Text(
            title,
          ),
        ],
      ),
    );
  }
}
