import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constant/color.dart';
import 'package:flutter_chat_app/features/auth/presentation/widget/form_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width - 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/images/signup.png')),
              const SizedBox(height: 40),
              Text(
                'Sign Up',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              const AuthForm(isSignin: false),
              const SizedBox(height: 30),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Joined us before? ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go('/signup/login');
                          },
                        text: 'Login',
                        style: const TextStyle(color: kLinkTextColor),
                      ),
                    ],
                  ),
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
