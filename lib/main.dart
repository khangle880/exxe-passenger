import 'package:exxe/src/storage/models/photo.dart';
import 'package:exxe/src/storage/models/suggestive_province.dart';
import 'package:exxe/src/storage/models/transaction.dart';
import 'package:exxe/src/storage/models/user.dart';
import 'package:exxe/src/storage/models/user_chat.dart';
import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:upgrader/upgrader.dart';

import 'src/app/app.dart';
import 'src/dependencies/app_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotificationHelper.init();
  await Firebase.initializeApp();

  await dotenv.load(fileName: ".env");
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(UserHiveAdapter());
  Hive.registerAdapter(ChatUserHiveAdapter());
  Hive.registerAdapter(PhotoHiveModelAdapter());
  Hive.registerAdapter(SuggestiveProvinceAdapter());
  Hive.registerAdapter(TransactionHiveModelAdapter());
  // ignore: unused_local_variable
  var box = await BoxesUser.openBoxUser();
  log(await BoxesUser.instance.getDataTokenUser());
  log(await BoxesChatUser.instance.getDataTokenUser());
  //print(await BoxesChatUser.instance.getDataTokenUser());
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  // Hive.init();
  await AppDependencies.init();
  await Upgrader.clearSavedSettings();

  // await precachePicture(
  //   ExactAssetPicture(
  //       SvgPicture.svgStringDecoderBuilder, AppIcons.loginBannerSvg),
  //   null,
  // );

  runApp(
    const MyApp(),
  );
}
