import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator_app/resources/components/app_colors.dart';
import 'package:translator_app/resources/components/custom_textFormfield.dart';
import 'package:translator_app/resources/components/round_button.dart';
import 'package:translator_app/utils/routes/routes_names.dart';
import 'package:translator_app/view_model/login_view_model.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthenticationViewModel>(context);
    final height = MediaQuery.of(context).size.height * 1;
    LinearGradient myLinearGradient = AppColors.linearGradientColor();
    CustomTextFormField nameField = CustomTextFormField(
      text: 'Name',
      controller: _nameController,
    );
    CustomTextFormField userNameField = CustomTextFormField(
      text: 'User name',
      controller: _userNameController,
    );
    CustomTextFormField emailField = CustomTextFormField(
      text: 'Email',
      controller: _emailController,
    );
    CustomTextFormField addressField = CustomTextFormField(
      text: 'Address',
      controller: _addressController,
    );
    CustomTextFormField phoneField = CustomTextFormField(
      text: 'Mobile No.',
      controller: _phoneController,
    );
    CustomTextFormField passwordField = CustomTextFormField(
      text: 'Password',
      controller: _passwordController,
    );

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(
                  height: height *.05,
                ),
                Hero(
                  tag: "icon",
                    child: Image.asset('assets/images/translateLogo.png',height: 82,)),
                SizedBox(height: height *.05,),
                nameField,
                const SizedBox(height: 15,),
                userNameField,
                const SizedBox(height: 15,),
                emailField,
                const SizedBox(height: 15,),
                addressField,
                const SizedBox(height: 15,),
                phoneField,
                const SizedBox(height: 15,),
                passwordField,
                SizedBox(height: height *.05,),
                RoundButton(title: 'Signup',loading: authViewModel.signupLoading,onPress: (){
                  authViewModel.signupWithEmailandPassword(name:_nameController.text.toString(),userName:_userNameController.text.toString(),email:_emailController.text.toString(),address:_addressController.text.toString(),phone:_phoneController.text.toString(),password: _passwordController.text.toString(), context);
                }, ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("already have an account? ",style: TextStyle(fontSize: 17),),
                    ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds)=> myLinearGradient.createShader(bounds),
                        child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, RoutesNames.login);
                            },
                            child: const Text("login",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),))),
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