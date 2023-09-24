import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/bloc/auth/auth_bloc.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/bloc/order/order_bloc.dart';
import 'package:kasir_app/app/bloc/scaffold_key/home_scaffold_key_cubit.dart';
import 'package:kasir_app/app/model/user_model.dart';
import 'package:kasir_app/app/pages/selling/screen/history/history_screen.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/util/global_function.dart';
import 'package:kasir_app/app/util/util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../bloc/category/category_bloc.dart';
import '../../bloc/index/index_bloc.dart';
import '../../bloc/sales/sales_bloc.dart';
import '../../theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserModel userModel;
  late String token;

  @override
  void initState() {
    userModel = context.read<AuthRepository>().userModel;
    token = userModel.token ?? '';
    context.read<SalesBloc>().add(SalesGetEvent(token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: _buildAppbar(),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          GlobalFunction.refresh(context);
        },
        child: ListView(
          // physics: kPhysicsDeffault,
          children: [
            BlocBuilder<SalesBloc, SalesState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case SalesLoadingState:
                    return _headerBoxShimmer(size);
                  case SalesLoadedState:
                    state as SalesLoadedState;
                    final salesModel = state.salesModel;
                    // declarate variable
                    int revenue = 0;
                    String parseRevenue = '0';
                    int orderCount = 0;
                    if (salesModel!.isNotEmpty) {
                      final dataToday = state.salesModel!
                          .where((element) =>
                              ymdFormat(element.createdAt!) == ymdFormat(DateTime.now()))
                          .toList();
                      // di looping agar mendapatkan sales yang hari ini
                      for (var element in dataToday) {
                        revenue += int.parse(element.revenue!);
                      }
                      orderCount = dataToday.length;
                      //
                      parseRevenue = currencyFormat(revenue.toString());
                    }
                    return _headerBox(
                      size,
                      children: [
                        Center(
                          child: Text(
                            userModel.meta?.shopName ?? 'Shop name not found',
                            style: textTheme.titleLarge!.copyWith(color: Colors.white),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Order count today : $orderCount',
                          style: textTheme.titleSmall!.copyWith(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          'Revenue today : $parseRevenue',
                          style: textTheme.titleSmall!.copyWith(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    );
                  case SalesErrorState:
                    state as SalesErrorState;
                    return Center(
                      child: Text(state.msg),
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kDeffaultPadding,
                vertical: kDeffaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sellingBody(textTheme),
                  const SizedBox(
                    height: kDeffaultPadding,
                  ),
                  _managementBody(textTheme, context),
                  const SizedBox(
                    height: kDeffaultPadding,
                  ),
                  _insightBody(textTheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      surfaceTintColor: kPrimaryColor,
      centerTitle: true,
      title: const Text(
        'KasiFy',
      ),
    );
  }

  Column _sellingBody(TextTheme textTheme) {
    return Column(
      children: [
        Text(
          'Selling',
          style: textTheme.titleLarge,
        ),
        const Divider(),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              _CardItemHome(
                onTap: () {
                  context.goNamed(Routes.selling);
                },
                assetImage: 'assets/icons/sell_icon.png',
                title: 'Selling',
              ),
              _CardItemHome(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ));
                },
                assetImage: 'assets/icons/history_icon.png',
                title: 'History',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _managementBody(TextTheme textTheme, BuildContext context) {
    return Column(
      children: [
        Text(
          'Management',
          style: textTheme.titleLarge,
        ),
        const Divider(),
        ListTile(
          onTap: () => context.goNamed(Routes.stock),
          leading: const Icon(
            Icons.shopping_bag_outlined,
          ),
          title: const Text(
            'Stock',
          ),
        ),
        ListTile(
          onTap: () => context.goNamed(Routes.category),
          leading: const Icon(
            TablerIcons.category,
          ),
          title: const Text(
            'Category',
          ),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(
            TablerIcons.user_check,
          ),
          title: const Text(
            'Customer',
          ),
        ),
      ],
    );
  }

  Column _insightBody(TextTheme textTheme) {
    return Column(
      children: [
        Text(
          'Insight',
          style: textTheme.titleLarge,
        ),
        const Divider(),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              _CardItemHome(
                onTap: () {
                  context.goNamed(Routes.traffic);
                },
                assetImage: 'assets/icons/traffic_icon.png',
                title: 'Traffic',
              ),
              _CardItemHome(
                onTap: () {
                  context.goNamed(Routes.economy);
                },
                assetImage: 'assets/icons/economy_icon.png',
                title: 'Economy',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _headerBox(
    Size size, {
    List<Widget>? children,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDeffaultPadding,
        vertical: kDeffaultPadding,
      ),
      constraints: BoxConstraints.tight(Size.fromHeight(size.height * 0.15)),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children ?? [],
      ),
    );
  }

  Container _headerBoxShimmer(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDeffaultPadding,
        vertical: kDeffaultPadding,
      ),
      constraints: BoxConstraints.tight(Size.fromHeight(size.height * 0.15)),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kSmallRadius),
                child: Container(
                  width: 200,
                  height: 27,
                  color: Colors.white38,
                ),
              ),
            ),
          ),
          const Spacer(),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kSmallRadius),
              child: Container(
                width: 180,
                height: 16,
                color: Colors.white38,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kSmallRadius),
              child: Container(
                width: 150,
                height: 16,
                color: Colors.white38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: kDeffaultPadding,
        ),
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: CircleAvatar(
                      child: Icon(
                        TablerIcons.building_store,
                        size: 45,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  userModel.meta?.shopName ?? '',
                  style: textTheme.titleLarge,
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

class _CardItemHome extends StatelessWidget {
  const _CardItemHome({
    required this.assetImage,
    required this.title,
    this.onTap,
  });

  final String assetImage, title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(kRadiusDeffault),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 18,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: Image.asset(assetImage),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                title,
                style: textTheme.titleSmall!,
                // style: textTheme.titleMedium!.copyWith(
                //   fontSize: 16,
                //   // fontWeight: FontWeight.w400,
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
