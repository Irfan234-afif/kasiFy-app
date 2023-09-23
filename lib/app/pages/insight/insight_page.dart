import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_app/app/bloc/scaffold_key/home_scaffold_key_cubit.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:tabler_icons/tabler_icons.dart';

class InsightPage extends StatefulWidget {
  const InsightPage({super.key});

  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<HomeScaffoldKeyCubit>().drawerOn();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: kDeffaultPadding,
          ),
          children: [
            ListTile(
              onTap: () {
                context.goNamed(Routes.traffic);
              },
              leading: const Icon(TablerIcons.device_analytics),
              title: const Text(
                'Traffic',
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(TablerIcons.home_dollar),
              title: const Text(
                'Economy',
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: DrawerButton(
        onPressed: () {
          context.read<HomeScaffoldKeyCubit>().drawerOn();
        },
      ),
      title: const Text(
        'Insight',
      ),
    );
  }
}
