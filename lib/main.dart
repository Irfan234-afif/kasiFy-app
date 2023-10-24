import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kasir_app/firebase_options.dart';
import 'package:kasir_app/kasify_app.dart';

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

  runApp(const KasiFyApp());
}
