import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator_app/resources/components/app_colors.dart';
import 'package:translator_app/resources/components/custom_textFormfield.dart';
import 'package:translator_app/resources/components/round_button.dart';
import 'package:translator_app/utils/routes/routes_names.dart';
import 'package:translator_app/view_model/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthenticationViewModel>(context);
    final height = MediaQuery.of(context).size.height * 1;
    LinearGradient myLinearGradient = AppColors.linearGradientColor();
    CustomTextFormField emailField = CustomTextFormField(text: 'email',controller: _emailController,);
    CustomTextFormField passwordField = CustomTextFormField(text: 'password',controller: _passwordController,);
    return Scaffold(
backgroundColor: AppColors.whiteColor.withOpacity(0.9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(
                  height: height *.1,
                ),
                Center(child: Image.asset('assets/images/translateLogo.png',height: 82,)),
                SizedBox(height: height *.1,),
                emailField,
                const SizedBox(height: 15,),
                passwordField,
                SizedBox(height: height *.1,),
                RoundButton(title: 'Login',loading: authViewModel.loading, onPress: (){
                  authViewModel.loginWithEmailandPassword(_emailController.text.toString(), _passwordController.text.toString(), context);
                },),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("don't have account?",style: TextStyle(fontSize: 17),),
                    ShaderMask(
                     blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds)=> myLinearGradient.createShader(bounds),
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, RoutesNames.signup);
                          },
                            child: const Text("signup",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),))),
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
