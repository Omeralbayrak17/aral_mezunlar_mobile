import 'package:aral_mezunlar_mobile/view/privacy_policy/privacy_policy_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/color_constants.dart';
import '../../extension/navigator_extension.dart';
import '../terms_of_use/terms_of_use_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);


  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {


  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();
  final TextEditingController _controllerAbout = TextEditingController();

  bool _isSecure = true;
  bool _isConfirmSecure = true;
  String? errorMessage = " ";
  bool _isChecked = false;
  bool _isCheckedTOS = false;


  final formKey = GlobalKey<FormState>();

  Widget _nameEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(fontSize: 12.sp),
        validator: (value) {
          if (value!.isEmpty) {
            return "Lütfen isim girin.";
          } else if (value.length < 2) {
            return "İsminiz en az 2 karakterden oluşabilir";
          } else if (value.length > 14) {
            return "İsminiz en fazla 14 karakterden oluşabilir";
          } else if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ]+(?: [a-zA-ZğüşıöçĞÜŞİÖÇ]+)?\s*$').hasMatch(value)) {
            return "Lütfen doğru isim girin.";
          }
        },
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.person),
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

  Widget _surnameEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(fontSize: 12.sp),
        validator: (value) {
          if (value!.isEmpty) {
            return "Lütfen soyisim girin.";
          } else if (value.length < 2) {
            return "Soyisminiz en az 2 karakterden oluşabilir";
          } else if (value.length > 16) {
            return "Soyisminiz en fazla 16 karakterden oluşabilir";
          } else if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ]+(?: [a-zA-ZğüşıöçĞÜŞİÖÇ]+)?\s*$').hasMatch(value)) {
            return "Lütfen soyisim girin.";
          }
        },
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.person),
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

  Widget _aboutEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        maxLines: 2,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(fontSize: 12.sp),
        validator: (value) {
          if (value!.isEmpty) {
            return "Lütfen hakkınızda bir açıklama girin.";
          } else if (value.length < 3) {
            return "Açıklamanız en az 3 karakterden oluşmalıdır.";
          }
          if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ0-9\s]+$').hasMatch(value)) {
            return "Lütfen sadece harf ve rakam kullanın.";
          }
        },
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.person),
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

  Widget _emailEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        style: TextStyle(fontSize: 12.sp),
        controller: controller,
        keyboardType: TextInputType.emailAddress,
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
        keyboardType: TextInputType.visiblePassword,
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

  Widget _confirmPasswordEntryField(String title, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Lütfen şifrenizi tekrar girin";
          }
        },
        style: TextStyle(fontSize: 12.sp),
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _isConfirmSecure,
        decoration: InputDecoration(
            suffixIcon: toggleConfirmPassword(),
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

  Widget toggleConfirmPassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isConfirmSecure = !_isConfirmSecure;
          });
        },
        icon: _isConfirmSecure
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off));
  }
  
  Widget _checkPrivacyPolicy(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value!;
                });
              },
            ),
            Expanded(child: TextButton(onPressed: (){Navigator.push(context, NavigatorExtension.expandFromEdgeAnimation(const PrivacyPolicyView(), Alignment.bottomRight));}, child: Text('Gizlilik politikasını okudum ve kabul ediyorum.', style: Theme.of(context).textTheme.titleSmall,))),
          ],
        ),
      ],
    );
  }

  Widget _checkTermsOfUse(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isCheckedTOS,
              onChanged: (bool? value) {
                setState(() {
                  _isCheckedTOS = value!;
                });
              },
            ),
            Expanded(child: TextButton(onPressed: (){Navigator.push(context, NavigatorExtension.expandFromEdgeAnimation(const TermsOfUseView(), Alignment.bottomRight));}, child: Text('Kullanım koşullarını okudum ve kabul ediyorum.', style: Theme.of(context).textTheme.titleSmall,))),
          ],
        ),
      ],
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
              if ((_isChecked && _isCheckedTOS)) {
                if (_controllerPassword.text == _controllerConfirmPassword.text) {
                  if (formKey.currentState!.validate()) {
                    try {
                      UserCredential authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _controllerEmail.text,
                        password: _controllerPassword.text,
                      );
                      String uid = authResult.user!.uid;

                      if (mounted) {
                        await FirebaseFirestore.instance.collection('users').doc(uid).set({
                          'name': _controllerName.text,
                          'surname': _controllerSurname.text,
                          'email': _controllerEmail.text,
                          'about': _controllerAbout.text,
                          'role': "Uye",
                          'imageurl': " ",
                          'bannerurl': "",
                          'uid': uid,
                          'likes': [],
                          'createdAt': FieldValue.serverTimestamp(),
                        }).then((value) {
                          Navigator.pop(context);
                        });
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        setState(() {
                          errorMessage = "Şifreniz en az 6 karakterden oluşmalıdır..";
                        });
                      } else if (e.code == 'email-already-in-use') {
                        setState(() {
                          errorMessage = "Girilen e-mail kullanılmaktadır.";
                        });
                      } else {
                        setState(() {
                          errorMessage = "Bir problem oluştu. Lütfen uygulamayı kapatıp tekrar deneyin.";
                        });
                      }
                    }
                  }
                } else {
                  setState(() {
                    errorMessage = "Şifreleriniz uyuşmamaktadır.";
                  });
                }
              } else {
                setState(() {
                  errorMessage = "Lütfen gizlilik politikasını ve kullanım koşullarını kabul edin.";
                });
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                "Kayıt Ol",
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
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerAbout.dispose();
    _controllerConfirmPassword.dispose();
    _controllerSurname.dispose();
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
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text(
                  "Kayıt Ol",
                  style: TextStyle(color: Colors.white),
                ),
                elevation: 0,
                backgroundColor: ColorConstants.primaryButtonColor,
                foregroundColor: Colors.white,
              ),
              body: SizedBox(
                height: ScreenUtil().screenHeight,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          _nameEntryField("İsim girin", _controllerName),
                          SizedBox(
                            height: 25.h,
                          ),
                          _surnameEntryField("Soyisim girin", _controllerSurname),
                          SizedBox(
                            height: 25.h,
                          ),
                          _emailEntryField("E-posta girin", _controllerEmail),
                          SizedBox(
                            height: 25.h,
                          ),
                          _passwordEntryField(
                              "Şifrenizi girin", _controllerPassword),
                          SizedBox(
                            height: 25.h,
                          ),
                          _confirmPasswordEntryField(
                              "Şifrenizi tekrar girin", _controllerConfirmPassword),
                          SizedBox(
                            height: 25.h,
                          ),
                          _aboutEntryField(
                              "Hakkınızda bir açıklama girin", _controllerAbout),
                          SizedBox(
                            height: 5.h,
                          ),
                          _checkPrivacyPolicy(),
                          SizedBox(
                            height: 5.h,
                          ),
                          _checkTermsOfUse(),
                          SizedBox(
                            height: 5.h,
                          ),
                          _submitButton(),
                          Text(errorMessage!,style: TextStyle(color: Colors.black, fontSize: 18.sp),),
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
