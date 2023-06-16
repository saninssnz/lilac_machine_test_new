import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lilac_machine_test/service/getx.dart';
import 'package:lilac_machine_test/ui/home_screen/home_screen.dart';
import 'package:lilac_machine_test/ui/login_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lilac_machine_test/ui/video_List_Screen.dart';
import 'model/user_model.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  Get.put(GetController());
}

class MyApp extends StatelessWidget {

  UserModel userModel = UserModel();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: VideoListScreen(),
    );
  }
}
