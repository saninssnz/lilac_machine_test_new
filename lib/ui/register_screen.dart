import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lilac_machine_test/model/user_model.dart';
import 'package:lilac_machine_test/ui/login_screen.dart';
import 'package:lilac_machine_test/utils/Toast.dart';
import 'package:lilac_machine_test/utils/constants.dart';
import 'package:lilac_machine_test/utils/data_repo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                ),
              ),
              child: Center(
                child: Text("Register",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 40
                ),),
              ),),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                controller: usernameController,
                decoration: buildInputDecoration(hintText: "Enter your name"),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                controller: dobController,
                decoration: buildInputDecoration(hintText: "Select DOB",suffixIcon: InkWell(
                    onTap: () {
                      selectDate(context)
                          .then((value) {
                        if (null != value) {
                          dobController.text =
                          value
                              .toString()
                              .split(" ")[0];
                        } else {
                          dobController.text =
                          "";
                        }
                      });

                      setState(() {});
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.only(
                          right: 8.0),
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.black,
                        size: 18,
                      ),
                    )),),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                controller: emailController,
                decoration: buildInputDecoration(hintText: "Enter Email address"),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                controller: mobileController,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(hintText: "Enter mobile no. with country code"),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: (){
                  if(usernameController.text.isEmpty || dobController.text.isEmpty ||
                  emailController.text.isEmpty || mobileController.text.isEmpty){
                    Toast.show("Enter all details", context);
                  }
                  else{
                    UserModel userModel = new UserModel();
                    userModel.userName = usernameController.text;
                    userModel.dob = dobController.text;
                    userModel.email = emailController.text;
                    userModel.mobile = mobileController.text;
                    addUser(userModel, context);
                  }
                },
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(20),
                    color: primaryColor,
                  ),
                  height: 50,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: primaryColor, // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: primaryColor, // body text color
                ),
              ),

              child: child!);
        },
        initialDate: DateTime.now());

    return picked;
  }

  void addUser(UserModel userModel,BuildContext context){

    DataRepo().addUser(userModel).then((value) {

      userModel.id=value.id;

      if (userModel.id!.isNotEmpty){

        Toast.show("User created successfully", context);
        Navigator.of(context).pop();

        DataRepo().updateUser(userModel);
       Get.to(()=>LoginScreen());

      }else{
        Toast.show('Registration failed.',context);

      }
    });

  }
}
