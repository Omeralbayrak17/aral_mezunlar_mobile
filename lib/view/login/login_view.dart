import 'package:aral_mezunlar_mobile/constant/color_constants.dart';
import 'package:aral_mezunlar_mobile/extension/popup_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _isSecure = true;
  String? errorMessage = '';
  final formKey = GlobalKey<FormState>();

  Widget _emailEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        style: TextStyle(fontSize: 12.sp),
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.none,
        validator: (value) {
          if (value!.isEmpty) {
            return "Lütfen e-posta adresinizi girin";
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(value)) {
            return "Lütfen doğru formatta e-posta adresinizi girin";
          }
        },
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.mail),
            suffixIconColor: ColorConstants.primaryButtonColor,
            hintText: title,
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  Widget _passwordEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Lütfen şifrenizi girin.";
          }
        },
        controller: controller,
        obscureText: _isSecure,
        style: TextStyle(fontSize: 12.sp),
        decoration: InputDecoration(
            suffixIcon: togglePassword(),
            suffixIconColor: ColorConstants.primaryButtonColor,
            hintText: title,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.white.withOpacity(0.7),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSecure = !_isSecure;
          });
        },
        icon: _isSecure
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off));
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Lütfen bekleyin..."),
            ],
          ),
        );
      },
    );
  }

  Widget _submitButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.primaryButtonColor,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () async {
              showLoadingDialog(context);
              try {
                if (formKey.currentState!.validate()) {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _controllerEmail.text,
                    password: _controllerPassword.text,
                  ).then((value) {
                    Navigator.pop(context);
                  });
                }
                if(mounted) Navigator.pop(context);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-disabled') {
                  setState(() {
                    Navigator.pop(context);
                    errorMessage = "Hesabınız uzaklaştırıldı.";
                  });
                } else if (e.code == 'user-not-found') {
                  setState(() {
                    Navigator.pop(context);
                    errorMessage = "Girilen e-posta adresi ile bir hesap bulunamadı.";
                  });
                } else if (e.code == 'invalid-credential') {
                  setState(() {
                    Navigator.pop(context);
                    errorMessage = "E-posta adresinizi veya şifrenizi kontrol edin.";
                  });
                } else {
                  setState(() {
                    Navigator.pop(context);
                    errorMessage = "Lütfen internet bağlantınızı kontrol edin.";
                  });
                }
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                "Giriş Yap",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: ColorConstants.primaryButtonColor,
                foregroundColor: Colors.white,
                title: const Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.white),
                ),
                elevation: 0,
              ),
              body: SizedBox(
                height: ScreenUtil().screenHeight,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                          children: [
                            _emailEntryField("E-posta girin", _controllerEmail),
                            SizedBox(
                              height: 25.h,
                            ),
                            _passwordEntryField("Şifrenizi girin", _controllerPassword),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: (){PopUpExtension.showForgetPasswordDialog(context);},
                                  child: const Text("Şifremi Unuttum"),
                                ),
                              ],
                            ),
                            _submitButton(),
                            Text(errorMessage!,style: TextStyle(color: Colors.black, fontSize: 18.sp),
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
              )
          ),
        );
      },
    );
  }
}