import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArmedInfoView extends StatelessWidget {
  const ArmedInfoView({super.key});

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
              body: Padding(
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
                    Center(child: Text("Aral Mezunları Derneği Nedir?", style: Theme.of(context).textTheme.titleLarge,)),
                    SizedBox(height: 20.h,),
                    Center(child: Text("Aral Mezunları Derneği (tam adı ile Ataşehir Rotary Anadolu Lisesi Mezunları Derneği) Lisemizden mezun olan öğrencilerin dayanışma içinde bulunması ve topluma katkıda bulunması amacı ile kurulmuş bir dernektir.", style: Theme.of(context).textTheme.displaySmall), )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
