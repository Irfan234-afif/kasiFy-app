import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/constant.dart';

const kPrimaryColor = Color(0xff5D4037);

const kTextColor = Color(0xFF3C3C3C);
const kTextColor2 = Color(0xFFFEFEFE);
const kTextColor3 = Color(0xFF555555);

Color kCircleAvatarBackground = const Color(0xFF56483C).withOpacity(0.05);

const kLabelColor = Color(0xFF5D4037);
const kLabelColor2 = Color(0xFFCACACA);

const kButtonColor = Color(0xFF5D4037);
const kButtonColor2 = Color(0xFFFEFEFE);
const kButtonColor3 = Colors.green;

final Color kScaffolColor = Colors.blue[50]!;

const double kDeffaultPadding = 16;
const double kSmallPadding = 8;

final kSmallBorderRadius = BorderRadius.circular(kSmallPadding);

const double kRadiusDeffault = 16;
const double kSmallRadius = 8;
const kBorderColor = Color(0xFFD0D0D0);
const kBorderColor2 = Color(0xFFD7CCC8);

// final kPhysicsDeffault = Platform.isIOS ? ClampingScrollPhysics() : RangeMaintainingScrollPhysics();

class AppTheme {
  final ThemeMode mode;
  final ThemeData themeData;
  AppTheme({
    required this.mode,
    required this.themeData,
  });

  factory AppTheme.light() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark, // IOS
        statusBarIconBrightness: Brightness.dark, // Android
        systemNavigationBarColor: Colors.white, // Android
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    const mode = ThemeMode.light;

    final themeData1 = ThemeData(
      primaryColor: kPrimaryColor,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: kScaffolColor,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      useMaterial3: true,
      // primaryColor: ,
      appBarTheme: AppBarTheme(
        surfaceTintColor: kScaffolColor,
        backgroundColor: kScaffolColor,
        elevation: 0,
      ),
      cardTheme: CardTheme(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusDeffault),
          )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kButtonColor,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(0),
          padding: EdgeInsets.symmetric(
              vertical: isTablet ? kDeffaultPadding + 8 : kDeffaultPadding),
          textStyle: GoogleFonts.poppins(
            color: kTextColor2,
            fontWeight: FontWeight.w700,
            // fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kSmallRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 0),
          padding: EdgeInsets.symmetric(
              vertical: isTablet ? kDeffaultPadding + 8 : kDeffaultPadding),
          side: const BorderSide(
            color: Colors.black26,
          ),
          textStyle: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            // fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kSmallRadius),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kScaffolColor,
        selectedItemColor: kButtonColor,
        unselectedItemColor: kLabelColor2,
        selectedIconTheme: const IconThemeData(
          size: 28,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 28,
        ),
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          // fontSize: 12,
          color: kTextColor,
        ),
        enableFeedback: false,
        showUnselectedLabels: false,
      ),
      searchBarTheme: SearchBarThemeData(
        hintStyle: MaterialStatePropertyAll(
          GoogleFonts.poppins(
            color: Colors.black38,
            fontWeight: FontWeight.w400,
          ),
        ),
        // constraints: BoxConstraints(minHeight: 0),
        textStyle: MaterialStatePropertyAll(
          GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
          ),
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: kSmallPadding,
          ),
        ),
        elevation: const MaterialStatePropertyAll(3),
        // shape: MaterialStatePropertyAll(
        //   RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(24),
        //     side: const BorderSide(
        //       color: kBorderColor2,
        //       width: 1.3,
        //     ),
        //   ),
        // ),
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
        // shadowColor: const MaterialStatePropertyAll(Colors.white),
        overlayColor: const MaterialStatePropertyAll(Colors.white),
        surfaceTintColor: const MaterialStatePropertyAll(Colors.white),
      ),
      searchViewTheme: const SearchViewThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFEFEBE9),
        iconTheme: const IconThemeData(
          color: kTextColor,
        ),
        secondaryLabelStyle: GoogleFonts.poppins(
          color: Colors.white,
          // fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        secondarySelectedColor: kTextColor,
        labelStyle: GoogleFonts.poppins(
          color: kTextColor,
          // fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        showCheckmark: false,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      tabBarTheme: TabBarTheme(
        indicatorColor: kPrimaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: Colors.black45,
        labelColor: kPrimaryColor,
        labelStyle: GoogleFonts.poppins(
          color: kLabelColor,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          color: kLabelColor2,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: Colors.transparent,
        indicator: UnderlineTabIndicator(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: kPrimaryColor,
            width: 2,
          ),
        ),
      ),
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: kButtonColor,
        contentTextStyle: GoogleFonts.poppins(
          color: kTextColor2,
          // fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusDeffault),
        ),
        // minVerticalPadding: 16,
        selectedColor: kTextColor3,
        selectedTileColor: Colors.black12,
        titleTextStyle: GoogleFonts.poppins(
          color: kTextColor3,
          // fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        leadingAndTrailingTextStyle: GoogleFonts.poppins(
          color: kTextColor3,
          // fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: GoogleFonts.poppins(
          color: kTextColor3,
          // fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      textTheme: AppTextTheme.textTheme,
    );
    return AppTheme(mode: mode, themeData: themeData1);
  }

  factory AppTheme.dark() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark, // IOS
        statusBarIconBrightness: Brightness.dark, // Android
        systemNavigationBarColor: Colors.black, // Android
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    const mode = ThemeMode.dark;

    final themeData = ThemeData.dark().copyWith(
      useMaterial3: true,
      textTheme: AppTextTheme.textTheme,
      primaryTextTheme: AppTextTheme.textTheme,
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusDeffault),
        ),
        // minVerticalPadding: 16,
        selectedColor: Colors.white,
        selectedTileColor: Colors.black12,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          // fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        leadingAndTrailingTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          // fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          // fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    return AppTheme(mode: mode, themeData: themeData);
  }
}

class AppTextTheme {
  static final TextTheme textTheme = GoogleFonts.poppinsTextTheme().copyWith(
    headlineMedium: GoogleFonts.poppins(
      color: kTextColor3,
      fontWeight: FontWeight.w600,
    ),
    labelLarge: GoogleFonts.poppins(
      color: kTextColor2,
      fontWeight: FontWeight.w500,
      // fontSize: 16,
    ),
    labelMedium: GoogleFonts.poppins(
      color: kTextColor,
      fontWeight: FontWeight.w400,
      // fontSize: 12,
    ),
    labelSmall: GoogleFonts.poppins(
      color: kTextColor,
      fontWeight: FontWeight.w500,
      // fontSize: 10,
    ),
    titleLarge: GoogleFonts.poppins(
      color: kTextColor3,
      // fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.poppins(
      color: kTextColor3,
      // fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.poppins(
      color: kTextColor3,
      // fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.poppins(
      color: kTextColor,
      fontWeight: FontWeight.w400,
      // fontSize: 14,
    ),
  );
}
