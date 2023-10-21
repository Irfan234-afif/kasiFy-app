import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import 'package:kasir_app/app/bloc/category/category_bloc.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/model/item_model.dart';

import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/theme/app_theme.dart';

import 'package:kasir_app/app/util/util.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../model/category_model.dart';
import '../../widget/support/currency_input_formatter.dart';
import '../../widget/support/dashed_border_painter.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key, this.arg});

  final ItemModel? arg;

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  late TextEditingController nameC;
  late TextEditingController stockC;
  late TextEditingController codeProductC;
  late TextEditingController basicPriceC;
  late TextEditingController sellingPriceC;
  late SearchController categoryC;
  late TextEditingController descC;
  late GlobalKey<FormState> formKey;
  late List<CategoryModel> categoryModel;

  late bool autoGenerateCode;
  late String email;

  @override
  void initState() {
    nameC = TextEditingController();
    stockC = TextEditingController();
    codeProductC = TextEditingController();
    basicPriceC = TextEditingController();
    sellingPriceC = TextEditingController();
    categoryC = SearchController();
    descC = TextEditingController();
    formKey = GlobalKey<FormState>();

    email = FirebaseAuth.instance.currentUser?.email ?? '';
    if (widget.arg != null) {
      initialize(widget.arg!);
      autoGenerateCode = false;
    } else {
      codeProductC.text = generateCodeProduct();
      autoGenerateCode = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    stockC.dispose();
    codeProductC.dispose();
    sellingPriceC.dispose();
    basicPriceC.dispose();
    categoryC.dispose();
    descC.dispose();
    super.dispose();
  }

  void initialize(ItemModel data) {
    nameC.text = data.name!;
    stockC.text = data.stock.toString();
    codeProductC.text = data.codeProduct.toString();
    sellingPriceC.text = data.sellingPrice!;
    basicPriceC.text = data.sellingPrice!;
    categoryC.text = data.category!.categoryName!;
    descC.text = data.description!;
  }

  void _onSave() {
    EasyLoading.show(maskType: EasyLoadingMaskType.clear);
    final basicPrice = basicPriceC.text.replaceAll('.', '');
    final sellingPrice = sellingPriceC.text.replaceAll('.', '');
    final category =
        categoryModel.firstWhere((element) => element.name == categoryC.text);
    final itemModel = ItemModel(
      name: nameC.text,
      description: descC.text,
      basicPrice: basicPrice,
      sellingPrice: sellingPrice,
      stock: int.parse(stockC.text),
      codeProduct: int.parse(codeProductC.text),
      category: CategoryItem(
        categoryName: category.name,
      ),
    );
    context.read<ItemBloc>().add(ItemAddEvent(email, itemModel: itemModel));
  }

  @override
  Widget build(BuildContext context) {
    categoryModel = context.watch<CategoryBloc>().state.categoryModel ?? [];
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (widget.arg != null) {
              // jika argument ada maka kembali ke page detail item
              context.goNamed(Routes.detailItem, extra: widget.arg);
            } else {
              context.pop();
            }
          },
        ),
        centerTitle: true,
        title: Text(widget.arg == null ? 'Add Item' : 'Edit Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: kSmallPadding,
          horizontal: kDeffaultPadding,
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BoxImage(),
              const SizedBox(
                height: kDeffaultPadding,
              ),
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(
                  hintText: "Name Product",
                ),
              ),
              const SizedBox(
                height: kSmallPadding,
              ),
              // Stock and code product
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: stockC,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        hintText: "Stock",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: kSmallPadding,
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: codeProductC,
                      enabled: !autoGenerateCode,
                      decoration: const InputDecoration(
                        hintText: "Code product",
                        suffixIcon: Icon(TablerIcons.scan),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: kSmallPadding,
              ),
              // Auto generate code product
              CheckboxListTile(
                value: autoGenerateCode,
                splashRadius: 0,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Auto generate code product'),
                onChanged: (value) {
                  setState(() {
                    autoGenerateCode = value ?? false;
                    if (value == true) {
                      codeProductC.text = generateCodeProduct();
                    } else {
                      codeProductC.clear();
                    }
                  });
                },
              ),
              const SizedBox(
                height: kSmallPadding,
              ),
              // Price
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Basic Price*',
                          style: themeData.textTheme.titleSmall,
                        ),
                        TextFormField(
                          controller: basicPriceC,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 30, minHeight: 0),
                            prefixIcon: Text(
                              'Rp',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selling Price*',
                          style: themeData.textTheme.titleSmall,
                        ),
                        TextFormField(
                          controller: sellingPriceC,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 30, minHeight: 0),
                            prefixIcon: Text(
                              'Rp',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: kDeffaultPadding,
              ),
              Text(
                'Category*',
                style: themeData.textTheme.titleSmall,
              ),
              // Category
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, stateCategory) {
                        return SearchAnchor.bar(
                          barPadding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(
                                vertical: 4, horizontal: kDeffaultPadding),
                          ),
                          constraints: const BoxConstraints(minHeight: 0),
                          searchController: categoryC,
                          isFullScreen: false,
                          barLeading: const Icon(TablerIcons.category_2),
                          viewTrailing: [
                            IconButton(
                              onPressed: () =>
                                  context.pushNamed(Routes.category),
                              icon: const Icon(TablerIcons.plus),
                            ),
                          ],
                          suggestionsBuilder: (BuildContext context,
                              SearchController controller) {
                            List<CategoryModel>? category =
                                stateCategory.categoryModel ?? [];
                            return List<Widget>.generate(
                              category.length,
                              (int index) {
                                final data = category[index];
                                final String categoryName = data.name!;
                                return ListTile(
                                  titleAlignment: ListTileTitleAlignment.center,
                                  title: Text(categoryName),
                                  onTap: () {
                                    controller.closeView(data.name);
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pushNamed(Routes.category),
                    icon: const Icon(TablerIcons.plus),
                  ),
                ],
              ),
              const SizedBox(
                height: kDeffaultPadding,
              ),
              // Description
              TextFormField(
                controller: descC,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(
                height: kDeffaultPadding,
              ),
              // Button Save
              ElevatedButton(
                onPressed: _onSave,
                child: BlocConsumer<ItemBloc, ItemState>(
                  listenWhen: (previous, current) =>
                      previous is ItemLoadingState,
                  listener: (context, state) {
                    if (state is ItemLoadedState) {
                      nameC.clear();
                      stockC.clear();
                      codeProductC.clear();
                      sellingPriceC.clear();
                      basicPriceC.clear();
                      categoryC.clear();
                      descC.clear();
                      EasyLoading.dismiss();
                      // context.pop();
                      // DialogCollection.snakBarSuccesAddItem(context);
                    }
                  },
                  builder: (context, state) {
                    return state is ItemLoadingState
                        ? SizedBox(
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Save',
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoxImage extends StatelessWidget {
  const _BoxImage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: Colors.black26,
            strokeWidth: 2,
            dashWidth: 8,
            dashSpace: 4,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  TablerIcons.photo,
                  color: Colors.black45,
                  size: 30,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Tambahkan gambar",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
