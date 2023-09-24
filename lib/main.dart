import 'package:intl/date_symbol_data_local.dart';
import 'package:kasir_app/app/bloc/auth/auth_bloc.dart';
import 'package:kasir_app/app/bloc/draggable_item/draggable_item_cubit.dart';
import 'package:kasir_app/app/bloc/index/index_bloc.dart';
import 'package:kasir_app/app/bloc/item/item_bloc.dart';
import 'package:kasir_app/app/bloc/sales/sales_bloc.dart';
import 'package:kasir_app/app/bloc/scaffold_key/home_scaffold_key_cubit.dart';
import 'package:kasir_app/app/bloc/search/search_cubit.dart';
import 'package:kasir_app/app/bloc/temp_order/temp_order_bloc.dart';
import 'package:kasir_app/app/bloc/theme/theme_cubit.dart';
import 'package:kasir_app/app/router/app_pages.dart';
import 'package:kasir_app/app/theme/app_theme.dart';
import 'package:kasir_app/app/util/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import './app/bloc/category/category_bloc.dart';
import './app/bloc/order/order_bloc.dart';
import './app/repository/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  await GetStorage.init();
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarBrightness: Brightness.dark, // IOS
  //     statusBarIconBrightness: Brightness.dark, // Android
  //     // systemNavigationBarColor: Colors.white, // Android
  //     // systemNavigationBarIconBrightness: Brightness.light,
  //   ),
  // );
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle.light,
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // final platformBrightness = MediaQuery.of(context).platformBrightness;
    // if (platformBrightness == Brightness.dark) {
    //   context.read<ThemeCubit>().themeDark();
    // } else {
    //   context.read<ThemeCubit>().themeLight();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Detect Tablet or Mobile and rotatation
    // and save variable in isTablet and isLandscape
    final shortSide = MediaQuery.of(context).size.shortestSide;
    final orientation = MediaQuery.of(context).orientation == Orientation.portrait;

    final isMobile = shortSide < 600;
    isTablet = !isMobile;
    isLandscape = !orientation;

    return RepositoryProvider(
      create: (context) => AuthRepository()..init(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ItemBloc()
              ..add(
                ItemInitialEvent(
                  context.read<AuthRepository>().userModel.token ?? '',
                ),
              ),
          ),
          BlocProvider(
            create: (context) => TempOrderBloc(),
          ),
          BlocProvider(
            create: (context) => OrderBloc()
              ..add(
                OrderGetEvent(
                  token: context.read<AuthRepository>().userModel.token ?? '',
                ),
              ),
          ),
          BlocProvider(
            create: (context) => IndexBloc(),
          ),
          BlocProvider(
            create: (context) => DraggableItemCubit(),
          ),
          BlocProvider(
            create: (context) => HomeScaffoldKeyCubit(),
          ),
          BlocProvider(
            create: (context) => CategoryBloc()
              ..add(
                CategoryGetEvent(
                  context.read<AuthRepository>().userModel.token ?? '',
                ),
              ),
          ),
          BlocProvider(
            create: (context) => SearchCubit(),
          ),
          BlocProvider(
            create: (context) => SalesBloc(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          // listener: (context, state) {
          //   // if (platformBrightness == Brightness.dark) {
          //   //   context.read<ThemeCubit>().themeDark();
          //   // } else {
          //   //   context.read<ThemeCubit>().themeLight();
          //   // }
          //   // if (state is ThemeDarkState) {
          //   //   SystemChrome.setSystemUIOverlayStyle(
          //   //     SystemUiOverlayStyle.dark,
          //   //   );
          //   // } else {
          //   //   SystemChrome.setSystemUIOverlayStyle(
          //   //     SystemUiOverlayStyle.light,
          //   //   );
          //   // }
          // },
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: state.appTheme.themeData,
              // themeMode: state.appTheme.mode,
              routeInformationParser: routerConfig.routeInformationParser,
              routeInformationProvider: routerConfig.routeInformationProvider,
              routerDelegate: routerConfig.routerDelegate,
              // routerConfig: routerConfig,
            );
          },
        ),
      ),
    );
  }
}
