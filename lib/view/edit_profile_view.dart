import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator_app/resources/components/app_colors.dart';
import 'package:translator_app/resources/components/custom_textFormfield.dart';
import 'package:translator_app/resources/components/round_button.dart';
import 'package:translator_app/utils/routes/routes_names.dart';
import 'package:translator_app/view_model/login_view_model.dart';

class EditProfileView extends StatefulWidget {
  EditProfileView({super.key,required this.userData});

  Map<String, dynamic>? userData;
  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with data from userData
    if (widget.userData != null) {
      _nameController.text = widget.userData!['name'] ?? '';
      _userNameController.text = widget.userData!['userName'] ?? '';
      _emailController.text = widget.userData!['email'] ?? '';
      _addressController.text = widget.userData!['address'] ?? '';
      _phoneController.text = widget.userData!['phone'] ?? '';
    }
    setState(() {

    });
  }

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

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text('Edit you profile',style: TextStyle(color: AppColors.whiteColor),),
        backgroundColor: AppColors.primary,
        iconTheme: const  IconThemeData(
          color: AppColors.whiteColor,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                // Add any header or icon if needed
                nameField,
                const SizedBox(height: 15,),
                userNameField,
                const SizedBox(height: 15,),
                emailField,
                const SizedBox(height: 15,),
                addressField,
                const SizedBox(height: 15,),
                phoneField,
                SizedBox(height: height * 0.05,),
                RoundButton(
                  title: 'Update Profile',
                  loading: authViewModel.signupLoading,
                  onPress: () async {
                    // Get updated data from text controllers
                    String name = _nameController.text;
                    String userName = _userNameController.text;
                    String email = _emailController.text;
                    String address = _addressController.text;
                    String phone = _phoneController.text;

                    // Call the updateProfile method from AuthenticationViewModel
                    bool success = await authViewModel.updateProfile(
                      name: name,
                      userName: userName,
                      email: email,
                      address: address,
                      phone: phone,
                    );

                    if (success) {
                      // Successfully updated, you can show a success message or navigate back
                      // You might also want to clear controllers or handle other UI updates
                      Navigator.pop(context); // Go back to the previous screen
                    } else {
                      // Failed to update, show an error message or handle accordingly
                      // You might want to handle errors in the updateProfile method
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
