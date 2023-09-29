import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/bloc/category/category_bloc.dart';
import 'package:kasir_app/app/bloc/index/index_bloc.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/bloc/order/order_bloc.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../bloc/auth/auth_bloc.dart';

class DrawerIR extends StatelessWidget {
  DrawerIR({super.key});

  late String token;

  @override
  Widget build(BuildContext context) {
    token = context.watch<AuthRepository>().userModel.token ?? '';
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: kDeffaultPadding,
        ),
        children: [
          const DrawerHeader(
            child: Column(
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: CircleAvatar(
                      child: Icon(
                        TablerIcons.user,
                        size: 45,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '',
                ),
              ],
            ),
          ),
          BlocBuilder<IndexBloc, IndexState>(
            builder: (context, state) {
              final indexPage = state.index;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  late String title;
                  late VoidCallback? onTap;

                  onTap = () {
                    context.read<IndexBloc>().add(IndexChangeEvent(index));
                    // context.read<HomeScaffoldKeyCubit>().drawerOff();
                  };

                  switch (index) {
                    case 0:
                      title = 'Home';
                      onTap = () => context.goNamed(Routes.home);
                      break;
                    case 1:
                      title = 'Setting';
                      onTap = () {
                        context.goNamed(Routes.setting);
                      };
                      break;
                    case 2:
                      title = 'LogOut';
                      onTap = () {
                        context.read<AuthBloc>().add(AuthSignOutEvent(token: token));
                        context.read<ItemBloc>().add(ItemEmptyEvent());
                        context.read<OrderBloc>().add(OrderEmptyEvent());
                        context.read<CategoryBloc>().add(CategoryEmptyEvent());
                      };
                      break;
                    case 3:
                      title = 'LogOut';
                      onTap = () {
                        context.read<AuthBloc>().add(AuthSignOutEvent(token: token));
                        context.read<ItemBloc>().add(ItemEmptyEvent());
                        context.read<OrderBloc>().add(OrderEmptyEvent());
                        context.read<CategoryBloc>().add(CategoryEmptyEvent());
                      };
                      break;
                    default:
                      title = '';
                      onTap = () {};
                  }
                  return ListTile(
                    onTap: onTap,
                    selected: indexPage == index,
                    title: Text(
                      title,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
