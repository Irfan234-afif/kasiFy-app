import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/model/item_model.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';
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
  late TextEditingController qtyC;
  late int stockChange;
  late int stock;

  late bool isLongPressDecrease;
  late bool isLongPressIncrease;

  @override
  void initState() {
    isLongPressDecrease = false;
    isLongPressIncrease = false;
    qtyC = TextEditingController();
    stock = widget.itemModel.stock!;
    stockChange = widget.itemModel.stock!;
    qtyC.text = stockChange.toString();
    super.initState();
  }

  @override
  void dispose() {
    qtyC.dispose();
    super.dispose();
  }

  void _updateStockItem() {
    if (stockChange != stock) {
      ItemModel newData = widget.itemModel.copyWith(
        stock: stockChange,
      );
      String email = context.read<AuthRepository>().userModel.email ?? '';
      context.read<ItemBloc>().add(
            ItemUpdateStockEvent(email, itemModel: newData),
          );
    }
  }

  void _increaseStock() => setState(() {
        stockChange++;
        qtyC.text = stockChange.toString();
      });

  void _decreaseStock() {
    if (stockChange != 0) {
      setState(() {
        stockChange--;
        qtyC.text = stockChange.toString();
      });
    }
  }

  void _startDecreaseStock() {
    if (isLongPressDecrease) {
      _decreaseStock();
      Future.delayed(const Duration(milliseconds: 100), _startDecreaseStock);
    }
  }

  void _startIncreaseStock() {
    if (isLongPressIncrease) {
      _increaseStock();
      Future.delayed(const Duration(milliseconds: 100), _startIncreaseStock);
    }
  }

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
                  title: stock.toString(),
                ),
                _TextLabel(
                  label: 'Description',
                  title: itemModel.description!,
                ),
              ],
            ),
            const SizedBox(
              height: kDeffaultPadding,
            ),
            const Divider(),
            _updateStock(textTheme),
            const Divider(),
            _button(context, itemModel)
          ],
        ),
      ),
    );
  }

  Widget _updateStock(TextTheme textTheme) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          'Add stock',
          style: textTheme.titleMedium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPressStart: (details) {
                isLongPressDecrease = true;
                _startDecreaseStock();
              },
              onLongPressEnd: (details) {
                isLongPressDecrease = false;
              },
              onTap: _decreaseStock,
              child: Container(
                padding: const EdgeInsets.all(kSmallPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kSmallRadius),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: const Icon(
                  TablerIcons.minus,
                  size: 28,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(
              width: 70,
              child: TextField(
                controller: qtyC,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
                enabled: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onLongPressStart: (_) {
                isLongPressIncrease = true;
                _startIncreaseStock();
              },
              onLongPressEnd: (_) {
                isLongPressIncrease = false;
              },
              onTap: _increaseStock,
              child: Container(
                padding: const EdgeInsets.all(kSmallPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kSmallRadius),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: const Icon(
                  TablerIcons.plus,
                  size: 28,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
        if (stockChange != stock)
          IconButton(
            onPressed: () => setState(() {
              stockChange = stock;
              qtyC.text = stockChange.toString();
            }),
            icon: Icon(Icons.refresh_rounded),
          ),
        const SizedBox(
          height: kSmallPadding,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            fixedSize: const Size.fromHeight(55),
          ),
          onPressed: stockChange != stock ? _updateStockItem : null,
          child: BlocConsumer<ItemBloc, ItemState>(
            listenWhen: (previous, current) {
              if (previous is ItemLoadingState && current is ItemLoadedState) {
                return true;
              } else {
                return false;
              }
            },
            listener: (context, state) {
              setState(() {
                stock = stockChange;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Succes update stock'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            builder: (context, state) {
              if (state is ItemLoadingState) {
                return const FittedBox(
                  fit: BoxFit.contain,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    color: Colors.white,
                  ),
                );
              }
              return const Text('Save');
            },
          ),
        ),
      ],
    );
  }

  Row _button(BuildContext context, ItemModel itemModel) {
    return Row(
      children: [
        Expanded(
          child: _CustomElevated(
            onTap: () {},
            backgroundColor: Colors.red,
            icon: TablerIcons.trash_x,
            label: "Delete",
          ),
        ),
        const SizedBox(
          width: kSmallPadding,
        ),
        Expanded(
          child: _CustomElevated(
            onTap: () {
              context.goNamed(Routes.addItem, extra: itemModel);
            },
            icon: TablerIcons.edit,
            label: 'Edit',
          ),
        ),
      ],
    );
  }
}

class _CustomElevated extends StatelessWidget {
  const _CustomElevated({
    this.backgroundColor,
    this.icon,
    required this.label,
    required this.onTap,
  });

  final Color? backgroundColor;
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
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
