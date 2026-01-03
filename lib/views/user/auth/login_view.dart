import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../view_models/auth_vm.dart';
import '../../shared/custom_button.dart';
import '../../shared/custom_textfield.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    // Dynamic Colors based on Theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
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
                    // 1. Logo (Icon changes color automatically)
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: textColor, // ✅ Dynamic Color
                    ),
                    const SizedBox(height: 16),

                    // 2. Headings
                    Text(
                      "Welcome Back!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor, // ✅ Dynamic Color
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to continue shopping",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: subTextColor, // ✅ Dynamic Grey
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 3. Inputs
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
                      hint: "Enter your password",
                      isPassword: true,
                      validator: AppValidators.validatePassword,
                      suffixIcon: const Icon(Icons.lock_outline),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password?"),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4. Button
                    CustomButton(
                      text: "Login",
                      isLoading: authVM.isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authVM.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            context,
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // 5. Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: TextStyle(color: subTextColor)),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                          child: const Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),

                    // 6. Admin Link
                    const SizedBox(height: 40),
                    Center(
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.adminLogin),
                        child: Text(
                          "Admin Portal Access",
                          style: TextStyle(
                            color: subTextColor,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
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