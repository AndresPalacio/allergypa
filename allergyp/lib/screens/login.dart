import 'package:allergyp/util/cognito/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../main.dart';
import 'forgot_password.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

void login(BuildContext context) async {
  try {
    Map<String, dynamic>? result = await loginEmailPassowrd();
    if (result['status']) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Allergyp()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPassword()));
    }
  } catch (e) {
    print(e);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPassword()));
  }
}


  Future<Map<String, dynamic>> loginEmailPassowrd() async{
    return await CognitoService.login(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  "Login Allergy",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
                ),
                Image.asset(
                  "assets/images/login.jpg",
                  height: 250.h,
                  width: double.infinity,
                ),
                Text(
                  "Get Logged In From Here",
                  style: TextStyle(fontSize: 12.sp),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Email",
                  style: TextStyle(fontSize: 12.sp),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      color: Colors.grey[100],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Your Email',
                        contentPadding: EdgeInsets.all(10)),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Password",
                  style: TextStyle(fontSize: 12.sp),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      color: Colors.grey[100],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        contentPadding: EdgeInsets.all(10)),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                InkWell(
                    onTap: () {},
                    child: Text(
                      "Forgot Password ? ",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    )),
                SizedBox(
                  height: 10.h,
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  height: 20.h,
                  minWidth: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          color: Theme.of(context).primaryColor)),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                  ),
                  onPressed: () {
                    login(context);
                  },
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "don't have an account ? ",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                          color: Colors.grey),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()));
                      },
                      child: Text(
                        "Sign Up ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}