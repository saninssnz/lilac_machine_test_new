import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lilac_machine_test/service/getx.dart';
import 'package:lilac_machine_test/ui/login_screen.dart';
import 'package:lilac_machine_test/ui/profile_screen/profile_screen.dart';
import 'package:lilac_machine_test/utils/constants.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  bool isSettingsSelected = false;
  GetController layoutController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(height: 30),
          ListTile(
            leading: Icon(
              Icons.person,
            ),
            title: const Text('Profile'),
            onTap: () {
              Get.back();
              Get.to(()=>ProfileScreen());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: const Text('Logout'),
            onTap: () {
              Get.offAll(()=>LoginScreen());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
            ),
            title: const Text('Settings'),
            trailing: Icon(
              isSettingsSelected?
              Icons.keyboard_arrow_up_rounded:
              Icons.keyboard_arrow_down_rounded,
              size: 25,
            ),
            onTap: () {
              isSettingsSelected = !isSettingsSelected;
              setState(() {});
            },
          ),
          AnimatedOpacity(
            opacity: isSettingsSelected
                ? 1.0
                : 0.0,
            duration: const Duration(
                milliseconds: 500),
            child: Visibility(
              child: Padding(
                padding: const EdgeInsets.only(left: 50.0,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dark Theme"),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        onChanged: (value) {
                            layoutController.isDarkThemeSelected = !layoutController.isDarkThemeSelected;
                            setState(() {});
                            if(layoutController.isDarkThemeSelected) {
                              Get.changeTheme(ThemeData.dark());
                            }
                            else{
                              Get.changeTheme(ThemeData.light());
                            }
                        },
                        value: layoutController.isDarkThemeSelected,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
