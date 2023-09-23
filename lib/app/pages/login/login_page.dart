// import 'package:caff_shop/app/bloc/auth/auth_bloc.dart';
// import 'package:caff_shop/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/pages/login/screen/login_screen.dart';
import 'package:kasir_app/app/pages/login/screen/sign_up_screen.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/index/index_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late int indexBody;

  List<Widget> listBody = [
    const LoginScreen(),
    const SignUpScreen(),
  ];

  @override
  void initState() {
    // Set systemUiOverlayStyle
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light, // IOS
        statusBarIconBrightness: Brightness.dark, // Android
        systemNavigationBarColor: Colors.white, // Android
      ),
    );
    indexBody = 0;
    context.read<IndexBloc>().add(IndexChangeEvent(0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeData = Theme.of(context);
    final size = mediaQuery.size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: listBody[indexBody],
        bottomNavigationBar: _buildBottomNavbar(size, mediaQuery, themeData),
      ),
    );
  }

  Container _buildBottomNavbar(Size size, MediaQueryData mediaQuery, ThemeData themeData) {
    return Container(
      height: size.height * 0.1,
      width: size.width,
      padding: EdgeInsets.only(
        bottom: mediaQuery.padding.bottom + mediaQuery.viewInsets.bottom,
      ),
      alignment: Alignment.center,
      color: kScaffolColor,
      child: RichText(
        text: TextSpan(
          text: indexBody == 0 ? 'Belum punya akun? ' : 'Sudah punya akun?',
          style: themeData.textTheme.labelLarge!.copyWith(
            fontSize: 14,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: indexBody == 0 ? 'Daftar' : 'Masuk',
              style: themeData.textTheme.labelLarge!.copyWith(
                fontSize: 14,
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()..onTap = _changeBody,
            ),
          ],
        ),
      ),
    );
  }

  void _changeBody() {
    if (indexBody == 0) {
      setState(() {
        indexBody = 1;
      });
    } else if (indexBody == 1) {
      setState(() {
        indexBody = 0;
      });
    }
  }

  Future<bool> _onWillPop() {
    if (indexBody != 0) {
      setState(() {
        indexBody = 0;
      });
      return Future.value(false);
    }
    return Future.value(true);
  }
}
