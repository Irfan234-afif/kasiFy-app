import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/app/bloc/scaffold_key/home_scaffold_key_cubit.dart';
import 'package:kasir_app/app/theme/app_theme.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: _buildAppbar(context),
      body: Padding(
        padding: const EdgeInsets.all(kDeffaultPadding),
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 8,
            spacing: 8,
            children: [
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(kRadiusDeffault),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 70,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Stock',
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(kRadiusDeffault),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 70,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Stock',
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(kRadiusDeffault),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 70,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Stock',
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // body: ListView(
      //   padding: EdgeInsets.symmetric(horizontal: kDeffaultPadding, vertical: kSmallPadding),
      //   children: [
      //     ListTile(
      //       onTap: () => context.goNamed(Routes.stock),
      //       leading: Icon(
      //         Icons.shopping_bag_outlined,
      //       ),
      //       title: Text(
      //         'Stock',
      //       ),
      //     ),
      //     ListTile(
      //       onTap: () => context.goNamed(Routes.category),
      //       leading: Icon(
      //         TablerIcons.category,
      //       ),
      //       title: Text(
      //         'Category',
      //       ),
      //     ),
      //     ListTile(
      //       onTap: () {},
      //       leading: Icon(
      //         TablerIcons.user_check,
      //       ),
      //       title: Text(
      //         'Customer',
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      foregroundColor: Colors.white,
      backgroundColor: Colors.deepOrange.shade600,
      leading: DrawerButton(
        onPressed: () => context.read<HomeScaffoldKeyCubit>().drawerOn(),
      ),
      title: const Text(
        'Management',
      ),
    );
  }
}
