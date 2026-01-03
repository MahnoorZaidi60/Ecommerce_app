import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../view_models/auth_vm.dart';
import '../../shared/custom_textfield.dart';
import '../../shared/custom_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    // Dynamic Colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor), // Back button color
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Create Account",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor, // ✅ Fixed
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Join Windigo and start shopping",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: subTextColor, // ✅ Fixed
                      ),
                    ),
                    const SizedBox(height: 40),

                    CustomTextField(
                      controller: _nameController,
                      label: "Full Name",
                      hint: "Enter your full name",
                      validator: AppValidators.validateName,
                      suffixIcon: const Icon(Icons.person_outline),
                    ),

                    CustomTextField(
                      controller: _emailController,
                      label: "Email",
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                      suffixIcon: const Icon(Icons.email_outlined),
                    ),

                    CustomTextField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "Create a password",
                      isPassword: true,
                      validator: AppValidators.validatePassword,
                      suffixIcon: const Icon(Icons.lock_outline),
                    ),

                    const SizedBox(height: 30),

                    CustomButton(
                      text: "Sign Up",
                      isLoading: authVM.isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authVM.register(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _nameController.text.trim(),
                            context,
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?", style: TextStyle(color: subTextColor)),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}