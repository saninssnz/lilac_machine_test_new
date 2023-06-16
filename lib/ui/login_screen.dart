import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lilac_machine_test/model/user_model.dart';
import 'package:lilac_machine_test/service/getx.dart';
import 'package:lilac_machine_test/ui/home_screen/home_screen.dart';
import 'package:lilac_machine_test/ui/register_screen.dart';
import 'package:lilac_machine_test/utils/Toast.dart';
import 'package:lilac_machine_test/utils/constants.dart';
import 'package:lilac_machine_test/utils/data_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController mobileController = TextEditingController();
  String enteredPin = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIdReceived = "";
  bool otpCodeVisible = false;
  bool isLoading = false;
  UserModel userModel = UserModel();
  GetController layoutController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                  ),
                ),
            child: Center(
              child: Text("Login",style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 40
              ),),
            ),),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: buildInputDecoration(hintText: "Enter mobile no. with country code"),
              ),
            ),
            Visibility(
              visible: otpCodeVisible,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _textFieldOTP(first: true, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: false),
                    _textFieldOTP(first: false, last: false),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50,),
            isLoading?
            CircularProgressIndicator():Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: () {

                  if (mobileController.text != "") {

                    isLoading=true;
                    setState(() {

                    });
                    List<DocumentSnapshot> docs;

                    DataRepo.userCollection.get().then((query) async{

                      docs = query.docs;
                      if(docs.length>0){
                        userModel = UserModel.fromSnapshot(docs[0]);
                        DataRepo.userCollection.where('mobile', isEqualTo: mobileController.text).
                      get().then((value) async {
                          docs = value.docs;
                          if (docs.length > 0) {

                           layoutController.getUserDetails(UserModel.fromSnapshot(docs[0]));
                          }
                        });
                        isLoading=false;
                        setState(() {

                        });
                        if(userModel.mobile == mobileController.text){
                          if (otpCodeVisible) {
                            verifyCode();
                          }
                          else {
                            verifyNumber();
                          }

                        }
                        else{
                          Toast.show("User not found", context);

                        }
                      }
                    });

                  }
                  else{
                    Toast.show("Enter mobile no", context);
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
                      otpCodeVisible?"Verify":"Log in",
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

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Text("Don't have an account?",
                      style: TextStyle(
                        color: Colors.black
                      )
                    ),
                  ),
                  InkWell(
                    onTap: () {
                     Get.to(()=>RegisterScreen());
                    },
                    child: Text("Sign up",
                        style: TextStyle(
                          // decoration: TextDecoration.underline,
                          color: primaryColor,
                          fontSize:
                          15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void verifyNumber(){

    auth.verifyPhoneNumber(
        phoneNumber: mobileController.text,
        verificationCompleted: (PhoneAuthCredential credential)async{
           await auth.signInWithCredential(credential).then((value){
            print("logged in successfully");
          });
        },
        verificationFailed: (FirebaseAuthException exception){
          print(exception.message);
        },
        codeSent: (String verificationId, int? resendToken){
          verificationIdReceived = verificationId;
          otpCodeVisible = true;
          setState(() {});
        },
        codeAutoRetrievalTimeout:(String? verificationId){});
}


void verifyCode() async{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationIdReceived,
        smsCode: enteredPin);

    await  auth.signInWithCredential(credential).then((value){
      print("logged in successfully");

      Get.to(()=>HomeScreen());
    });
}


  Widget _textFieldOTP({bool? first, last}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2),
        height: 75,
        child: TextField(
          // controller: pinController,
          autofocus: true,
          obscureText: true,
          onSubmitted: (value) {
            // if(enteredPin.length==6){
            //   if(enteredPin.isNotEmpty && enteredPin==widget.doctorModel.pin){
            //     Navigator.of(context).pop(true);
            //   }else{
            //     Toast.show("Wrong pin", context);
            //   }
            // }
          },
          onChanged: (value) {
            if (enteredPin.length < 6 || value.length == 0) {
              if (value.length == 1 && last == false) {
                enteredPin = enteredPin + value;
                print(enteredPin);
                FocusScope.of(context).nextFocus();
              }
              if (value.length == 0 && first == false) {
                enteredPin = enteredPin.substring(0, enteredPin.length - 1);
                print(enteredPin);
                FocusScope.of(context).previousFocus();
              }
              if (value.length == 1 && last == true) {
                enteredPin = enteredPin + value;
                print(enteredPin);
              }
              if (value.length == 0 && first == true) {
                enteredPin = "";
                print(enteredPin);
              }
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.phone,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: primaryColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
