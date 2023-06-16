import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lilac_machine_test/service/getx.dart';
import 'package:lilac_machine_test/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  GetController layoutController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: (){
                      Get.back();
                    },
                      child: Icon(Icons.arrow_back_ios_new))),
            ),
            SizedBox(height: 50,),
            CircleAvatar(
              radius: 55,
                child: SvgPicture.asset("assets/images/avatar_man.svg",)
            ),
            SizedBox(height: 20,),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
              child: TextField(
                enabled: false,
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: buildInputDecoration(labelText: layoutController.newUserModel.userName)
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
              child: TextField(
                enabled: false,
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: buildInputDecoration(labelText: layoutController.newUserModel.email)
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
              child: TextField(
                enabled: false,
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: buildInputDecoration(labelText: layoutController.newUserModel.dob)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
