import 'package:kasir_app/app/bloc/scaffold_key/home_scaffold_key_cubit.dart';
import 'package:kasir_app/app/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/app_theme.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.size,
    required this.mediaQuery,
  });

  final Size size;
  final MediaQueryData mediaQuery;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => isTablet
      ? Size.fromHeight(
          isLandscape ? size.height * .155 : size.height * .155,
        )
      : Size.fromHeight(
          mediaQuery.orientation == Orientation.portrait ? size.height * .155 : size.height * .29,
        );
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: widget.mediaQuery.padding.top,
        left: kDeffaultPadding,
        right: kDeffaultPadding,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Expanded(
        child: Row(
          children: [
            Builder(builder: (context) {
              return DrawerButton(
                onPressed: () {
                  // Scaffold.of(context).openDrawer();
                  context.read<HomeScaffoldKeyCubit>().drawerOn();
                },
              );
            }),
            Expanded(
              child: SearchBar(
                hintText: 'Search..',
                trailing: [
                  const Icon(
                    Icons.search,
                    color: Colors.black38,
                  ),
                  SizedBox(
                    width: widget.size.width * .02,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
