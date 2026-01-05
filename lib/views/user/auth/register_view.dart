import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/routes.dart';
import '../../../core/utils/validators.dart';
import '../../../view_models/auth_vm.dart';
import '../../shared/custom_button.dart';
import '../../shared/custom_textfield.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // 📞 Added Phone
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // 1. HEADER
                  Text(
                    "CREATE ACCOUNT",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Join the exclusive club.",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),

                  const SizedBox(height: 40),

                  // 2. FORM FIELDS
                  CustomTextField(
                    controller: _nameController,
                    label: "Full Name",
                    hint: "e.g. John Doe",
                    validator: AppValidators.validateName,
                    suffixIcon: const Icon(Icons.person_outline),
                  ),
                  CustomTextField(
                    controller: _phoneController,
                    label: "Phone Number",
                    hint: "e.g. +92 300 1234567",
                    keyboardType: TextInputType.phone,
                    validator: (val) => val!.length < 10 ? "Enter valid phone" : null,
                    suffixIcon: const Icon(Icons.phone_outlined),
                  ),
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
                    hint: "Minimum 6 characters",
                    isPassword: true,
                    validator: AppValidators.validatePassword,
                    suffixIcon: const Icon(Icons.lock_outline),
                  ),

                  const SizedBox(height: 30),

                  // 3. SIGN UP BUTTON
                  CustomButton(
                    text: "SIGN UP",
                    isLoading: authVM.isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        authVM.register(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          _nameController.text.trim(),
                          _phoneController.text.trim(), // 📞 Passed Phone
                          "", // 🏠 Address empty for now (Add at Checkout)
                          context,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // 4. LOGIN LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a member? ", style: TextStyle(color: Colors.grey.shade600)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Log In",
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}