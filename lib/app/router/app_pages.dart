import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/app/bloc/category/category_bloc.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/bloc/order/order_bloc.dart';
import 'package:kasir_app/app/bloc/sales/sales_bloc.dart';
import 'package:kasir_app/app/model/item_model.dart';
import 'package:kasir_app/app/model/order_model.dart';
import 'package:kasir_app/app/pages/add_item/add_item.dart';
import 'package:kasir_app/app/pages/additional/error_page.dart';
import 'package:kasir_app/app/pages/additional/loading_page.dart';
import 'package:kasir_app/app/pages/category/category_page.dart';
import 'package:kasir_app/app/pages/detail_item/detail_item_page.dart';
import 'package:kasir_app/app/pages/insight/economy_page.dart';
import 'package:kasir_app/app/pages/insight/traffic.dart';
import 'package:kasir_app/app/pages/login/login_page.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/pages/order_succes/order_succes_page.dart';
import 'package:kasir_app/app/pages/selling/selling_page.dart';
import 'package:kasir_app/app/pages/stock/stock_page.dart';
import 'package:kasir_app/app/pages/setting/setting_page.dart';

import '../pages/home/home_page.dart';
import '../repository/auth_repository.dart';

part 'app_route.dart';
// import 'app_route.dart';

final routerConfig = GoRouter(
  redirect: (context, state) {
    final credential = context.read<AuthRepository>().firebaseAuth.currentUser;
    if (credential == null) {
      return '/login';
    } else {
      final String email = credential.email!;
      // print(email);
      context.read<ItemBloc>().add(ItemGetEvent(email));
      context.read<CategoryBloc>().add(CategoryGetEvent(email));
      context.read<OrderBloc>().add(OrderGetEvent(email: email));
      context.read<SalesBloc>().add(SalesGetEvent(email));
      return null;
    }
  },
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (_, __) => const HomePage(),
      routes: [
        GoRoute(
            path: 'selling',
            name: Routes.selling,
            builder: (context, state) => const SellingPage(),
            routes: [
              GoRoute(
                path: 'order-succes',
                name: Routes.orderSucces,
                builder: (_, state) => OrderSuccesPage(
                  data: state.extra as OrderModel,
                ),
              ),
            ]),
        GoRoute(
          path: 'stock',
          name: Routes.stock,
          builder: (_, __) => const StockPage(),
          routes: [
            GoRoute(
              path: 'add-item',
              name: Routes.addItem,
              builder: (context, state) => AddItemPage(
                arg: state.extra as ItemModel?,
              ),
            ),
            GoRoute(
              path: 'detail-item',
              name: Routes.detailItem,
              builder: (context, state) => DetailItemPage(
                itemModel: state.extra as ItemModel,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'category',
          name: Routes.category,
          builder: (_, __) => const CategoryPage(),
        ),
        GoRoute(
          path: 'traffic',
          name: Routes.traffic,
          builder: (_, __) => const TrafficPage(),
        ),
        GoRoute(
          path: 'economy',
          name: Routes.economy,
          builder: (_, __) => const EconomyPage(),
        ),
        GoRoute(
          path: 'setting',
          name: Routes.setting,
          builder: (context, state) => SettingPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/loading',
      name: Routes.loading,
      builder: (_, __) => const LoadingPage(),
    ),
    GoRoute(
      path: '/error',
      name: Routes.error,
      builder: (_, __) => const ErrorPage(),
    ),
  ],
);
