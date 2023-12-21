import 'package:aral_mezunlar_mobile/constant/color_constants.dart';
import 'package:aral_mezunlar_mobile/extension/navigator_extension.dart';
import 'package:aral_mezunlar_mobile/view/armed_info/armed_info_view.dart';
import 'package:aral_mezunlar_mobile/view/login/login_view.dart';
import 'package:aral_mezunlar_mobile/view/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';

class ChooseAuthView extends StatefulWidget {
  const ChooseAuthView({Key? key}) : super(key: key);

  @override
  State<ChooseAuthView> createState() => _ChooseAuthViewState();
}

class _ChooseAuthViewState extends State<ChooseAuthView> {
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
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/authbackground.jpg"),
                    fit: BoxFit.cover
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 150.h,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("lib/assets/aral.png")
                          )
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Text("Hoş geldin 2024 🖤", textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium),
                      const Spacer(),
                      SizedBox(
                        height: 50.h,
                        child: GFButton(
                          onPressed: () { Navigator.push(context, NavigatorExtension.rightToLeftAnimation(const LoginView())); },
                          shape: GFButtonShape.standard,
                          color: ColorConstants.primaryButtonColor,
                          splashColor: Colors.white10,
                          hoverColor: Colors.white10,
                          focusColor: Colors.white10,
                          highlightColor: Colors.white10,
                          disabledColor: Colors.white10,
                          child: Text("Giriş Yap", style: Theme.of(context).textTheme.headlineMedium),
                        ),
                      ),
                      SizedBox(height: 15.h,),
                      SizedBox(
                        height: 50.h,
                        child: GFButton(
                          color: ColorConstants.primaryButtonColor,
                          type: GFButtonType.outline2x,
                          splashColor: Colors.white10,
                          hoverColor: Colors.white10,
                          focusColor: Colors.white10,
                          highlightColor: Colors.white10,
                          disabledColor: Colors.white10,
                          onPressed: () { Navigator.push(context, NavigatorExtension.rightToLeftAnimation(const RegisterView())); },
                          child: Text("Kayıt Ol", style: Theme.of(context).textTheme.displayMedium),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, NavigatorExtension.bottomToTopAnimation(const ArmedInfoView()));
                        },
                        child: const Text("ARMED nedir?"),
                      ),
                      SizedBox(height: 40.h,),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
