import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';

import 'app/bloc/auth/auth_bloc.dart';
import 'app/bloc/category/category_bloc.dart';
import 'app/bloc/draggable_item/draggable_item_cubit.dart';
import 'app/bloc/index/index_bloc.dart';
import 'app/bloc/item/item_bloc.dart';
import 'app/bloc/order/order_bloc.dart';
import 'app/bloc/sales/sales_bloc.dart';
import 'app/bloc/scaffold_key/home_scaffold_key_cubit.dart';
import 'app/bloc/search/search_cubit.dart';
import 'app/bloc/temp_order/temp_order_bloc.dart';
import 'app/bloc/theme/theme_cubit.dart';
import 'app/repository/auth_repository.dart';
import 'app/router/app_pages.dart';
import 'app/util/constant.dart';
import 'package:nested/nested.dart';

class KasiFyApp extends StatefulWidget {
  const KasiFyApp({super.key});

  @override
  State<KasiFyApp> createState() => _KasiFyAppState();
}

class _KasiFyAppState extends State<KasiFyApp> with WidgetsBindingObserver {
  // use WidgetBindingObserver for listen platformBrightness

  @override
  void initState() {
    // check theme devices first
    WidgetsBinding.instance.addObserver(this);
    // _checkTrialDate();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _checkTrialDate();
    });
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
    // final brightness =
    //     SchedulerBinding.instance.platformDispatcher.platformBrightness;
    // if (brightness == Brightness.light &&
    //     _themeCubit.state is! ThemeLightState) {
    //   _themeCubit.themeLight();
    // } else if (brightness == Brightness.dark &&
    //     _themeCubit.state is! ThemeDarkState) {
    //   _themeCubit.themeDark();
    // }
  }

  _checkTrialDate() {
    GetStorage box = GetStorage();
    DateTime? trialEndDate = DateTime.parse(box.read('trialEndDate'));
    if (trialEndDate.isBefore(DateTime.now())) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            title: Text('Uji Coba Berakhir'),
            content: Text(
                'Uji coba aplikasi kasir telah berakhir. Untuk melanjutkan, silakan membeli lisensi penuh.'),
          );
        },
      );
    }
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
      create: (context) => AuthRepository()..initialize(),
      child: MultiBlocProvider(
        providers: _listBlocProvider,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: state.appTheme.themeData,
              themeMode: state.appTheme.mode,
              // themeMode: state.appTheme.mode,
              routeInformationParser: routerConfig.routeInformationParser,
              routeInformationProvider: routerConfig.routeInformationProvider,
              routerDelegate: routerConfig.routerDelegate,
              builder: EasyLoading.init(),
              // routerConfig: routerConfig,
            );
          },
        ),
      ),
    );
  }

  List<SingleChildWidget> get _listBlocProvider {
    return [
      BlocProvider(create: (context) => ThemeCubit()),
      BlocProvider(create: (context) => AuthBloc(context.read<AuthRepository>())),
      BlocProvider(create: (context) => ItemBloc()),
      BlocProvider(create: (context) => TempOrderBloc()),
      BlocProvider(create: (context) => OrderBloc()),
      BlocProvider(create: (context) => IndexBloc()),
      BlocProvider(create: (context) => DraggableItemCubit()),
      BlocProvider(create: (context) => HomeScaffoldKeyCubit()),
      BlocProvider(create: (context) => CategoryBloc()),
      BlocProvider(create: (context) => SearchCubit()),
      BlocProvider(create: (context) => SalesBloc()),
    ];
  }
}
