import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:kasir_app/app/util/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kasir_app/firebase_options.dart';

import './app/bloc/category/category_bloc.dart';
import './app/bloc/order/order_bloc.dart';
import './app/repository/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize localize DateTime
  await initializeDateFormatting('id_ID');
  // add licencyRegistry from google fonts
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  // init GetStorage
  await GetStorage.init();

  // init Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // use WidgetBindingObserver for listen platformBrightness

  late ThemeCubit _themeCubit;

  @override
  void initState() {
    // check theme devices first
    WidgetsBinding.instance.addObserver(this);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   obsWithChangeTheme(context);
    // });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    obsWithChangeTheme(context);
    super.didChangePlatformBrightness();
  }

  void obsWithChangeTheme(BuildContext context) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    if (brightness == Brightness.light &&
        _themeCubit.state is! ThemeLightState) {
      _themeCubit.themeLight();
    } else if (brightness == Brightness.dark &&
        _themeCubit.state is! ThemeDarkState) {
      _themeCubit.themeDark();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detect Tablet or Mobile and rotatation
    // and save variable in isTablet and isLandscape
    final shortSide = MediaQuery.of(context).size.shortestSide;
    final orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final isMobile = shortSide < 600;
    isTablet = !isMobile;
    isLandscape = !orientation;
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(
              create: (context) => AuthBloc(context.read<AuthRepository>())),
          BlocProvider(create: (context) => ItemBloc()),
          BlocProvider(create: (context) => TempOrderBloc()),
          BlocProvider(create: (context) => OrderBloc()),
          BlocProvider(create: (context) => IndexBloc()),
          BlocProvider(create: (context) => DraggableItemCubit()),
          BlocProvider(create: (context) => HomeScaffoldKeyCubit()),
          BlocProvider(create: (context) => CategoryBloc()),
          BlocProvider(create: (context) => SearchCubit()),
          BlocProvider(create: (context) => SalesBloc()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            _themeCubit = context.read<ThemeCubit>();
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: state.appTheme.themeData,
              themeMode: state.appTheme.mode,
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
