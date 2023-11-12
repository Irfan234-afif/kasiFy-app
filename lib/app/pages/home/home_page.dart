import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/bloc/auth/auth_bloc.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/bloc/order/order_bloc.dart';
import 'package:kasir_app/app/bloc/theme/theme_cubit.dart';
import 'package:kasir_app/app/model/user_model.dart';
import 'package:kasir_app/app/pages/home/screen/home_screen.dart';
import 'package:kasir_app/app/pages/home/screen/insight_screen.dart';
import 'package:kasir_app/app/pages/home/screen/management_screen.dart';
import 'package:kasir_app/app/pages/home/screen/selling_screen.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../bloc/category/category_bloc.dart';
import '../../bloc/index/index_bloc.dart';
import '../../theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserModel userModel;

  final List<Widget> _listScreen = [
    const HomeScreen(),
    const SellingScreen(),
    const ManagementScreen(),
    const InsightScreen(),
  ];
  late int _index;

  @override
  void initState() {
    _index = 0;
    userModel = context.read<AuthRepository>().userModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: _buildAppbar(),
      drawer: _buildDrawer(),
      body: _listScreen[_index],
      bottomNavigationBar: _buildBottomNavbar(),
    );
  }

  ClipRRect _buildBottomNavbar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(kRadiusDeffault),
        topRight: Radius.circular(kRadiusDeffault),
      ),
      child: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        backgroundColor: Colors.transparent,
        currentIndex: _index,
        onTap: (value) => setState(() {
          _index = value;
        }),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(TablerIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(TablerIcons.building_store),
            label: 'Selling',
          ),
          BottomNavigationBarItem(
            icon: Icon(TablerIcons.category_2),
            label: 'Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(TablerIcons.report_analytics),
            label: 'Insight',
          ),
        ],
      ),
    );
  }

  // RefreshIndicator _buildBody(
  //     BuildContext context, Size size, TextTheme textTheme) {
  //   final themeState = context.watch<ThemeCubit>().state;
  //   final textHeaderStyle = textTheme.titleMedium!.copyWith(
  //     color: themeState is ThemeLightState ? kTextColor3 : Colors.white,
  //   );
  //   return RefreshIndicator(
  //     onRefresh: () async {
  //       GlobalFunction.refresh(context);
  //     },
  //     child: ListView(
  //       physics: Platform.isIOS
  //           ? const ClampingScrollPhysics()
  //           : const RangeMaintainingScrollPhysics(),
  //       children: [
  //         BlocBuilder<SalesBloc, SalesState>(
  //           builder: (context, state) {
  //             switch (state.runtimeType) {
  //               case SalesLoadingState:
  //                 return _headerBoxShimmer(size);
  //               case SalesLoadedState:
  //                 state as SalesLoadedState;
  //                 final salesModel = state.salesModel;
  //                 // declarate variable
  //                 double revenue = 0;
  //                 String parseRevenue = '0';
  //                 int orderCount = 0;
  //                 if (salesModel?.isNotEmpty ?? false) {
  //                   final dataToday = state.salesModel!
  //                       .where((element) =>
  //                           ymdFormat(element.createdAt!) ==
  //                           ymdFormat(DateTime.now()))
  //                       .toList();
  //                   // di looping agar mendapatkan sales yang hari ini
  //                   for (var element in dataToday) {
  //                     revenue += double.parse(element.revenue!);
  //                   }
  //                   orderCount = dataToday.length;
  //                   //
  //                   parseRevenue = currencyFormat(revenue.toString());
  //                 }
  //                 return _headerBox(
  //                   size,
  //                   children: [
  //                     Center(
  //                       child: Text(
  //                         userModel.shopName ?? 'Shop name not found',
  //                         style: textTheme.titleLarge!
  //                             .copyWith(color: Colors.white),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Row(
  //                         children: [
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             mainAxisAlignment: MainAxisAlignment.end,
  //                             children: [
  //                               Text(
  //                                 'Order count today : $orderCount',
  //                                 style: textTheme.titleSmall!.copyWith(
  //                                     color: Colors.white, fontSize: 12),
  //                               ),
  //                               Text(
  //                                 'Revenue today : $parseRevenue',
  //                                 style: textTheme.titleSmall!.copyWith(
  //                                     color: Colors.white, fontSize: 12),
  //                               ),
  //                             ],
  //                           ),
  //                           // SizedBox(
  //                           //   width: 8,
  //                           // ),
  //                           // Expanded(
  //                           //   child: Container(
  //                           //     color: Colors.amber,
  //                           //   ),
  //                           // ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 );
  //               case SalesErrorState:
  //                 state as SalesErrorState;
  //                 return Center(
  //                   child: Text(state.msg),
  //                 );
  //               default:
  //                 return const SizedBox();
  //             }
  //           },
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: kDeffaultPadding,
  //             vertical: kDeffaultPadding,
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _sellingBody(textHeaderStyle),
  //               const SizedBox(
  //                 height: kDeffaultPadding,
  //               ),
  //               _managementBody(textHeaderStyle, context),
  //               const SizedBox(
  //                 height: kDeffaultPadding,
  //               ),
  //               _insightBody(textHeaderStyle),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  AppBar _buildAppbar() {
    final themeState = context.watch<ThemeCubit>().state;
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: themeState is ThemeLightState ? Colors.black : Colors.white,
      surfaceTintColor: kPrimaryColor,
      centerTitle: true,
      title: const Text(
        'KasiFy',
      ),
    );
  }

  // Column _sellingBody(TextStyle textHeaderStyle) {
  //   return Column(
  //     children: [
  //       Text(
  //         'Selling',
  //         style: textHeaderStyle,
  //       ),
  //       const Divider(),
  //       SizedBox(
  //         width: double.infinity,
  //         child: Wrap(
  //           alignment: WrapAlignment.center,
  //           spacing: 8,
  //           children: [
  //             _CardItemHome(
  //               onTap: () {
  //                 context.goNamed(Routes.selling);
  //               },
  //               assetImage: 'assets/icons/sell_icon.png',
  //               title: 'Selling',
  //             ),
  //             _CardItemHome(
  //               onTap: () {
  //                 Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => const HistoryScreen(),
  //                 ));
  //               },
  //               assetImage: 'assets/icons/history_icon.png',
  //               title: 'History',
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Column _managementBody(TextStyle textHeaderStyle, BuildContext context) {
  //   return Column(
  //     children: [
  //       Text(
  //         'Management',
  //         style: textHeaderStyle,
  //       ),
  //       const Divider(),
  //       ListTile(
  //         onTap: () => context.goNamed(Routes.stock),
  //         leading: const Icon(
  //           Icons.shopping_bag_outlined,
  //         ),
  //         title: const Text(
  //           'Stock',
  //         ),
  //       ),
  //       ListTile(
  //         onTap: () => context.goNamed(Routes.category),
  //         leading: const Icon(
  //           TablerIcons.category,
  //         ),
  //         title: const Text(
  //           'Category',
  //         ),
  //       ),
  //       ListTile(
  //         onTap: () {},
  //         leading: const Icon(
  //           TablerIcons.user_check,
  //         ),
  //         title: const Text(
  //           'Customer',
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Column _insightBody(TextStyle textHeaderStyle) {
  //   return Column(
  //     children: [
  //       Text(
  //         'Insight',
  //         style: textHeaderStyle,
  //       ),
  //       const Divider(),
  //       SizedBox(
  //         width: double.infinity,
  //         child: Wrap(
  //           alignment: WrapAlignment.center,
  //           spacing: 8,
  //           children: [
  //             _CardItemHome(
  //               onTap: () {
  //                 context.goNamed(Routes.traffic);
  //               },
  //               assetImage: 'assets/icons/traffic_icon.png',
  //               title: 'Traffic',
  //             ),
  //             _CardItemHome(
  //               onTap: () {
  //                 context.goNamed(Routes.economy);
  //               },
  //               assetImage: 'assets/icons/economy_icon.png',
  //               title: 'Economy',
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Container _headerBox(
  //   Size size, {
  //   List<Widget>? children,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: kDeffaultPadding,
  //       vertical: kDeffaultPadding,
  //     ),
  //     margin: EdgeInsets.symmetric(
  //       horizontal: kSmallPadding,
  //       vertical: kSmallPadding,
  //     ),
  //     // constraints: BoxConstraints.tight(Size.fromHeight(size.height * 0.15)),
  //     constraints: BoxConstraints(
  //       minHeight: 150,
  //       maxHeight: 150,
  //     ),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(kRadiusDeffault),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black87,
  //           blurRadius: 5,
  //           spreadRadius: 0.5,
  //         ),
  //       ],
  //       color: kPrimaryColor,
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: children ?? [],
  //     ),
  //   );
  // }

  // Container _headerBoxShimmer(Size size) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: kDeffaultPadding,
  //       vertical: kDeffaultPadding,
  //     ),
  //     constraints: BoxConstraints.tight(Size.fromHeight(size.height * 0.15)),
  //     decoration: const BoxDecoration(
  //       color: kPrimaryColor,
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Shimmer.fromColors(
  //           baseColor: Colors.grey.shade300,
  //           highlightColor: Colors.grey.shade100,
  //           child: Center(
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(kSmallRadius),
  //               child: Container(
  //                 width: 200,
  //                 height: 27,
  //                 color: Colors.white38,
  //               ),
  //             ),
  //           ),
  //         ),
  //         const Spacer(),
  //         Shimmer.fromColors(
  //           baseColor: Colors.grey.shade300,
  //           highlightColor: Colors.grey.shade100,
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(kSmallRadius),
  //             child: Container(
  //               width: 180,
  //               height: 16,
  //               color: Colors.white38,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 6,
  //         ),
  //         Shimmer.fromColors(
  //           baseColor: Colors.grey.shade300,
  //           highlightColor: Colors.grey.shade100,
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(kSmallRadius),
  //             child: Container(
  //               width: 150,
  //               height: 16,
  //               color: Colors.white38,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Drawer _buildDrawer() {
    final textTheme = Theme.of(context).textTheme;
    final themeState = context.watch<ThemeCubit>().state;
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: kDeffaultPadding,
        ),
        children: [
          DrawerHeader(
            child: Column(
              children: [
                const Expanded(
                  child: SizedBox.expand(
                    child: CircleAvatar(
                      child: Icon(
                        TablerIcons.building_store,
                        size: 45,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  userModel.shopName ?? '',
                  style: textTheme.titleMedium!.copyWith(
                    color: themeState is ThemeLightState ? kTextColor3 : Colors.white,
                  ),
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
                        context.read<AuthBloc>().add(AuthSignOutEvent());
                        context.read<ItemBloc>().add(ItemEmptyEvent());
                        context.read<OrderBloc>().add(OrderEmptyEvent());
                        context.read<CategoryBloc>().add(CategoryEmptyEvent());
                      };
                      break;
                    case 3:
                      title = 'LogOut';
                      onTap = () {
                        context.read<AuthBloc>().add(AuthSignOutEvent());
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

// class _CardItemHome extends StatelessWidget {
//   const _CardItemHome({
//     required this.assetImage,
//     required this.title,
//     this.onTap,
//   });

//   final String assetImage, title;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     return Card(
//       child: InkWell(
//         borderRadius: BorderRadius.circular(kRadiusDeffault),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 30,
//             vertical: 18,
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 60,
//                 width: 60,
//                 child: Image.asset(assetImage),
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//               BlocBuilder<ThemeCubit, ThemeState>(
//                 builder: (context, themeState) {
//                   return Text(
//                     title,
//                     // style: textTheme.titleSmall,
//                     style: textTheme.titleSmall!.copyWith(
//                         color: themeState is ThemeLightState
//                             ? kTextColor3
//                             : Colors.white),
//                     // style: textTheme.titleMedium!.copyWith(
//                     //   fontSize: 16,
//                     //   // fontWeight: FontWeight.w400,
//                     // ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
