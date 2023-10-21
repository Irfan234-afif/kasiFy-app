import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/app/bloc/auth/auth_bloc.dart';
import 'package:kasir_app/app/bloc/theme/theme_cubit.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/util/dialog_collection.dart';

import 'package:tabler_icons/tabler_icons.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Setting'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kDeffaultPadding,
          vertical: kDeffaultPadding,
        ),
        child: Column(
          children: [
            ListTile(
              onTap: () {},
              leading: Icon(TablerIcons.user),
              title: Text('Profile'),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
              ),
            ),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                final bool isLightMode =
                    state is ThemeInitial || state is ThemeLightState;
                return SwitchListTile(
                  onChanged: (value) {
                    if (isLightMode) {
                      context.read<ThemeCubit>().themeDark();
                    } else {
                      context.read<ThemeCubit>().themeLight();
                    }
                  },
                  value: isLightMode,
                  title: Row(
                    children: [
                      Icon(TablerIcons.sun),
                      SizedBox(
                        width: 16,
                      ),
                      Text('Light Mode'),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'KasiFy',
                  applicationVersion: '0.5',
                );
              },
              leading: Icon(TablerIcons.info_circle),
              title: Text('About'),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
              ),
            ),
            ListTile(
              onTap: () async {
                final bool flag = await DialogCollection.confirmLogout(context);
                if (flag) {
                  // context not changed anything
                  // ignore: use_build_context_synchronously
                  context.read<AuthBloc>().add(AuthSignOutEvent());
                }
              },
              leading: Icon(TablerIcons.logout),
              title: Text('Log Out'),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
