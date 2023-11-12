import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/bloc/category/category_bloc.dart';
import 'package:kasir_app/app/bloc/search/search_cubit.dart';
import 'package:kasir_app/app/model/item_model.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/util/global_function.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../bloc/item/item_bloc.dart';
import '../../model/category_model.dart';
import '../../util/util.dart';
import '../../widget/tile_item.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late TextEditingController searchC;
  // late SearchCubit searchCubit;

  late String token;
  late List<CategoryModel> categoryModel;
  late int groupValue;

  @override
  void initState() {
    groupValue = 0;
    searchC = TextEditingController();
    token = '';
    super.initState();
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  void dialogFilter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Category Filter',
          ),
          content: StatefulBuilder(builder: (context, set) {
            return SizedBox(
              width: double.maxFinite,
              // height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryModel.length + 1,
                itemBuilder: (context, index) {
                  late String title;
                  late Function(int? value) onChanged;
                  switch (index) {
                    case 0:
                      title = 'All Category';
                      onChanged = (value) {
                        context.read<SearchCubit>().searchOff();
                        set(() {
                          groupValue = value ?? 0;
                        });
                        context.pop();
                      };
                      break;
                    default:
                      title = categoryModel[index - 1].name ?? '';
                      onChanged = (value) {
                        context.read<SearchCubit>().filter<List<ItemModel>>(title);
                        set(
                          () {
                            groupValue = value ?? 0;
                          },
                        );
                        context.pop();
                      };
                  }
                  return RadioListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    selected: groupValue == index,
                    value: index,
                    groupValue: groupValue,
                    title: Text(title),
                    onChanged: onChanged,
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    categoryModel = context.watch<CategoryBloc>().state.categoryModel ?? [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Stock',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDeffaultPadding),
        child: Column(
          children: [
            _header(context),
            _buildItemBloc(),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Row _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBar(
            onChanged: (value) {
              context.read<SearchCubit>().performSearch<List<ItemModel>>(
                    value,
                  );
            },
            trailing: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kSmallPadding),
                child: Icon(TablerIcons.search),
              ),
            ],
            hintText: 'Search...',
          ),
        ),
        IconButton(
          onPressed: () {
            dialogFilter(context);
          },
          icon: const Icon(
            TablerIcons.filter,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      onPressed: () {
        context.goNamed(Routes.addItem);
      },
      child: const Icon(TablerIcons.plus),
    );
  }

  Expanded _buildItemBloc() {
    final size = MediaQuery.sizeOf(context);
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          GlobalFunction.refresh(context);
        },
        child: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, stateItem) {
            final itemModel = stateItem.itemModel;

            switch (stateItem.runtimeType) {
              case ItemLoadingState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ItemErrorState:
                return ListView(
                  children: const [
                    Center(
                      child: Text(
                        'Terjadi kesalahan',
                      ),
                    ),
                  ],
                );
              case ItemLoadedState:
                if (itemModel?.isEmpty ?? true) {
                  return Center(
                    child: Text(
                      'Item not yet',
                    ),
                  );
                }
                context.read<SearchCubit>().fetchItem<List<ItemModel>>(itemModel);
                return _buildSearchBloc(size, itemModel);

              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  BlocBuilder<SearchCubit, SearchState<dynamic>> _buildSearchBloc(
      Size size, List<ItemModel>? itemModel) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, stateSearch) {
        switch (stateSearch.runtimeType) {
          case SearchEmpty:
            return const Center(
              child: Text('Item not found'),
            );
          case const (SearchComplete<List<ItemModel>>):
            stateSearch as SearchComplete<List<ItemModel>>;
            return _buildListItem(size, stateSearch.result);
          default:
            return _buildListItem(size, itemModel ?? []);
        }
      },
    );
  }

  ListView _buildListItem(Size size, List<ItemModel> itemModel) {
    itemModel.sort(
      (a, b) => a.name!.compareTo(b.name!),
    );
    const double sizeImageItem = 50;
    return ListView.builder(
      padding: EdgeInsets.only(top: kDeffaultPadding, bottom: size.height * .1),
      itemCount: itemModel.length,
      itemBuilder: (context, index) {
        final item = itemModel[index];
        late String leadingText;
        leadingText = takeLetterIdentity(item.name!);
        return TileItem(
          onTap: () {
            context.goNamed(Routes.detailItem, extra: item);
          },
          isLeadingImage: false,
          leadingText: leadingText,
          sizeImage: sizeImageItem,
          title: item.name!,
          subtitle: 'Stock : ${item.stock}',
          trailing: currencyFormat(item.sellingPrice!),
        );
      },
    );
  }
}
