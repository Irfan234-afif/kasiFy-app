import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_app/app/bloc/category/category_bloc.dart';
import 'package:kasir_app/app/bloc/search/search_cubit.dart';
import 'package:kasir_app/app/model/category_model.dart';
import 'package:kasir_app/app/model/item_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../../theme/app_theme.dart';

class ListChipFilter extends StatefulWidget {
  const ListChipFilter({
    super.key,
  });

  @override
  State<ListChipFilter> createState() => _ListChipFilterState();
}

class _ListChipFilterState extends State<ListChipFilter> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 46,
      ),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                final categoryModel = state.categoryModel ?? [];
                switch (state.runtimeType) {
                  // on Loading
                  case CategoryLoadingState:
                    return _buildShimmer();
                  // on Error
                  case CategoryErrorState:
                    return const Text('Error');
                  // on Loaded
                  case CategoryLoadedState:
                    // state as CategoryLoadedState;
                    return BlocListener<SearchCubit, SearchState>(
                      listener: (context, state) {
                        if (state is SearchOff) {
                          setState(() {
                            selectedIndex = null;
                          });
                        }
                      },
                      child: _buildListChip(categoryModel),
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
          SizedBox(
            height: 38,
            child: const VerticalDivider(
              color: kPrimaryColor,
              thickness: 0.5,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              right: 0,
            ),
            child: Row(
              children: [
                Icon(
                  TablerIcons.filter,
                ),
                Text(
                  'Filter',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildListChip(List<CategoryModel> categoryModel) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categoryModel.length,
      separatorBuilder: (context, index) {
        if (index != categoryModel.length - 1) {
          return const SizedBox(
            width: 8,
          );
        }
        return const SizedBox();
      },
      itemBuilder: (context, index) {
        return _chipFilter(
          selected: selectedIndex == index,
          label: categoryModel[index].name!,
          onSelected: (value) {
            if (selectedIndex == index) {
              context.read<SearchCubit>().searchOff();
              setState(() {
                selectedIndex = null;
              });
            } else {
              context.read<SearchCubit>().filter<List<ItemModel>>(categoryModel[index].name!);
              setState(() {
                selectedIndex = index;
              });
            }
          },
        );
      },
    );
  }

  Shimmer _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 8,
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return const ChoiceChip(
            label: Text('halo'),
            selected: false,
          );
        },
      ),
    );
  }

  // List<Widget> _buildListChip() {
  //   List<Widget> chips = [];
  //   for (int i = 0; i < listFilter.length; i++) {
  //     Widget item = Padding(
  //       padding: const EdgeInsets.only(left: 10, right: 5),
  //       child: _chipFilter(
  //         label: listFilter[i]['label'],
  //         // icon: listFilter[i]['icon'],
  //         selected: selectedIndex == i,
  //         onSelected: (value) {
  //           if (selectedIndex == i) {
  //             setState(() {
  //               selectedIndex = null;
  //             });
  //           } else {
  //             setState(() {
  //               selectedIndex = i;
  //               print(selectedIndex);
  //             });
  //           }
  //         },
  //       ),
  //     );
  //     chips.add(item);
  //   }
  //   return chips;
  // }

  ChoiceChip _chipFilter(
      {required String label,
      Widget? icon,
      bool selected = false,
      Function(bool value)? onSelected}) {
    return ChoiceChip(
      selectedColor: kTextColor,
      onSelected: onSelected,
      padding: const EdgeInsets.symmetric(vertical: kSmallPadding, horizontal: kSmallPadding),
      selected: selected,
      labelStyle: GoogleFonts.poppins(
        // fontSize: 16,
        fontWeight: FontWeight.w500,
        color: selected ? Colors.white : kTextColor,
      ),
      iconTheme: IconThemeData(
        size: 22,
        color: selected ? Colors.white : kTextColor,
      ),
      avatar: icon,
      label: Text(
        label,
      ),
    );
  }
}
