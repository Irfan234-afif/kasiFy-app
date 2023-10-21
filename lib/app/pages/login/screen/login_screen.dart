import 'package:kasir_app/app/bloc/auth/auth_bloc.dart';
import 'package:kasir_app/app/bloc/category/category_bloc.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/bloc/order/order_bloc.dart';
import 'package:kasir_app/app/bloc/sales/sales_bloc.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/text_field_label.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailC;
  late TextEditingController passwordC;
  late GlobalKey<FormState> formKey;

  late bool obsecureText;

  @override
  void initState() {
    emailC = TextEditingController();
    passwordC = TextEditingController();
    formKey = GlobalKey<FormState>();

    obsecureText = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: kDeffaultPadding,
        ),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header image
                TextFieldWithLabel(
                  label: 'Email',
                  controller: emailC,
                  hintText: 'example@gmail.com',
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWithLabel(
                  label: 'Password',
                  controller: passwordC,
                  obsecureText: obsecureText,
                  hintText: 'example',
                  textInputAction: TextInputAction.send,
                  onFieldSubmitted: (value) => _onLogin(),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                ElevatedButton(
                  style: themeData.elevatedButtonTheme.style?.copyWith(
                    minimumSize: MaterialStatePropertyAll(
                      Size(size.width, 0),
                    ),
                    // maxSize: MaterialStatePropertyAll(
                    //   Size(size.width, 0),
                    // ),
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                    ),
                  ),
                  onPressed: _onLogin,
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthLoggedInState) {
                        // Resumming function _onLogin
                        String email = context
                                .read<AuthRepository>()
                                .firebaseAuth
                                .currentUser
                                ?.email ??
                            '';
                        context.read<ItemBloc>().add(ItemGetEvent(email));
                        context
                            .read<OrderBloc>()
                            .add(OrderGetEvent(email: email));
                        context
                            .read<CategoryBloc>()
                            .add(CategoryGetEvent(email));
                        context.read<SalesBloc>().add(SalesGetEvent(email));
                      }
                    },
                    builder: (context, state) {
                      // if (state is AuthLoadingState) {
                      //   context.pushNamed(Routes.login);
                      // } else if (state is AuthErrorState) {
                      //   context.pushNamed(Routes.login);
                      // }
                      if (state is AuthLoadingState) {
                        return const SizedBox(
                            height: 17,
                            width: 17,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ));
                      }
                      return Text(
                        'Login',
                        style: themeData.textTheme.labelMedium!.copyWith(
                          color: kTextColor2,
                          fontSize: 16,
                        ),
                      );
                    },
                    // child: Text(
                    //   'Login',
                    //   style: themeData.textTheme.labelMedium!.copyWith(
                    //     color: kTextColor2,
                    //     fontSize: 16,
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    context.read<AuthBloc>().add(
          AuthSignInEvent(
            email: emailC.text,
            password: passwordC.text,
          ),
        );
  }
}
