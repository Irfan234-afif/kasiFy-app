import 'package:kasir_app/app/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/app/bloc/category/category_bloc.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/bloc/order/order_bloc.dart';
import 'package:kasir_app/app/repository/auth_repository.dart';

import '../../../theme/app_theme.dart';
import '../widget/text_field_label.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController nameC;
  late TextEditingController shopNameC;
  late TextEditingController emailC;
  late TextEditingController passwordC;
  late GlobalKey<FormState> formKey;

  late bool obsecureText;

  @override
  void initState() {
    nameC = TextEditingController();
    shopNameC = TextEditingController();
    emailC = TextEditingController();
    passwordC = TextEditingController();
    formKey = GlobalKey<FormState>();
    obsecureText = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: kDeffaultPadding,
        ),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Header image
                TextFieldWithLabel(
                  label: 'Name',
                  controller: nameC,
                  hintText: 'Alex',
                ),
                TextFieldWithLabel(
                  label: 'Shop Name',
                  controller: shopNameC,
                  hintText: 'New Caffe',
                ),
                TextFieldWithLabel(
                  label: 'Email',
                  controller: emailC,
                  hintText: 'example@gmail.com',
                ),
                TextFieldWithLabel(
                  label: 'Password',
                  controller: passwordC,
                  obsecureText: obsecureText,
                  hintText: 'example',
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                ElevatedButton(
                  style: themeData.elevatedButtonTheme.style!.copyWith(
                    minimumSize: MaterialStatePropertyAll(
                      Size(size.width, 0),
                    ),
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                    ),
                  ),
                  onPressed: _onSignUp,
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthLogOutState) {
                        // Resumming function _onSignUp
                        final String token = context.read<AuthRepository>().userModel.token!;
                        context.read<ItemBloc>().add(ItemInitialEvent(token));
                        context.read<OrderBloc>().add(OrderGetEvent(token: token));
                        context.read<CategoryBloc>().add(CategoryGetEvent(token));
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
                        'Signup',
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

  void _onSignUp() {
    context.read<AuthBloc>().add(
          AuthSignUpEvent(
            shopName: shopNameC.text,
            name: nameC.text,
            email: emailC.text,
            password: passwordC.text,
          ),
        );
  }
}
