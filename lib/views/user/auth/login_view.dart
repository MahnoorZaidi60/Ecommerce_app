import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/routes.dart';
import '../../../core/utils/validators.dart';
import '../../../view_models/auth_vm.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium Colors
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = Colors.grey;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. BRAND LOGO (Text Based for Luxury Feel)
                  Text(
                    "WINDIGO",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "PREMIUM FOOTWEAR",
                    style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: subColor
                    ),
                  ),

                  const SizedBox(height: 50),

                  // 2. INPUT FIELDS
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("LOG IN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textColor)),
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: _emailController,
                    label: "Email Address",
                    hint: "hello@example.com",
                    keyboardType: TextInputType.emailAddress,
                    validator: AppValidators.validateEmail,
                    suffixIcon: const Icon(Icons.email_outlined),
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    label: "Password",
                    hint: "••••••••",
                    isPassword: true,
                    validator: AppValidators.validatePassword,
                    suffixIcon: const Icon(Icons.lock_outline),
                  ),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Future feature
                      },
                      child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. LOGIN BUTTON
                  CustomButton(
                    text: "LOG IN",
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

                  const SizedBox(height: 30),

                  // 4. REGISTER LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New to Windigo? ", style: TextStyle(color: subColor)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                        child: Text(
                          "Create Account",
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // 5. ADMIN PORTAL (Subtle)
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.adminLogin),
                    child: const Text(
                      "Admin Access",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}