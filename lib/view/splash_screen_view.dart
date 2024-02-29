import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:translator_app/resources/components/app_colors.dart';
import 'package:translator_app/view_model/splash_screen_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenViewModel viewModel = SplashScreenViewModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    viewModel.navigateToNextScreen(context);
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<SplashScreenViewModel>(
        builder: (context, viewModel, child){
          return PopScope(canPop: false,
              child: Scaffold(
                backgroundColor: AppColors.whiteColor.withOpacity(0.9),
                body: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Image.asset('assets/images/Ellipse2.png'),
                    ),
                    Hero(
                        tag:"icon",
                        child: Image.asset('assets/images/Ellipse1.png')),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: Image.asset('assets/images/translateLogo.png',height: 82,)),
                        const Gap(20),
                        Text('TRANSLATE ON THE GO',style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),),
                      ],
                    )
                  ],
                ),
              ));
        },
      )

    );
  }
}
