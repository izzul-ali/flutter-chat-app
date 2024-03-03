import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:flutter_chat_app/features/auth/domain/auth.dart';
import 'package:flutter_chat_app/widget/button_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/color.dart';

class AuthForm extends ConsumerStatefulWidget {
  final bool isSignin;

  const AuthForm({super.key, required this.isSignin});

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _globalKey.currentState?.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_globalKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      if (widget.isSignin) {
        await ref.read(authServiceProvider.notifier).login(
              AuthModel(
                username: '',
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );
      } else {
        await ref.read(authServiceProvider.notifier).register(
              AuthModel(
                username: _usernameController.text,
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );
      }
    } catch (e) {
      debugPrint('error ${e.toString()}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          ...!widget.isSignin
              ? [
                  AuthInputField(
                    controller: _usernameController,
                    prefixIcon: Icons.person_pin_outlined,
                    hintText: 'Username',
                    textInputType: TextInputType.name,
                  ),
                  const SizedBox(height: 20),
                ]
              : [const SizedBox.shrink()],
          AuthInputField(
            controller: _emailController,
            prefixIcon: Icons.alternate_email,
            hintText: 'Email',
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          AuthInputField(
            controller: _passwordController,
            prefixIcon: Icons.password,
            hintText: 'Password',
            textInputType: TextInputType.visiblePassword,
          ),
          if (!widget.isSignin) ...[
            const SizedBox(height: 30),
            Text.rich(
              style: GoogleFonts.poppins(fontSize: 12),
              TextSpan(
                text: 'By signing up, you’ve agree to our ',
                children: [
                  TextSpan(
                    text: 'terms and conditions',
                    style: const TextStyle(
                      color: kLinkTextColor,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => {},
                  ),
                  const TextSpan(
                    text: ' and ',
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      color: kLinkTextColor,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => {},
                  ),
                ],
              ),
            ),
          ],
          if (widget.isSignin) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {},
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: kLinkTextColor,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: DefaultCustomButton(
              onPressed: () async {
                await _handleSubmit();
              },
              label: 'Continue',
            ),
          )
        ],
      ),
    );
  }
}

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final IconData prefixIcon;
  final String hintText;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: textInputType == TextInputType.visiblePassword,
      validator: (value) {
        if ((value == null || value == '')) {
          return '$hintText cannot be empty';
        }

        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, size: 18),
        prefixIconColor: kOnBoardingTextColor,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(fontSize: 14),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: kOnBoardingTextColor,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
