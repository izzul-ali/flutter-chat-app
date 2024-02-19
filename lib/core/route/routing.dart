import 'package:flutter_chat_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:flutter_chat_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter_chat_app/features/chat/presentation/chats_screen.dart';
import 'package:flutter_chat_app/features/onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

final routes = GoRouter(
  redirect: (context, state) {
    return null;
  },
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/chats',
      builder: (context, state) => const ChatsScreen(),
    ),
  ],
);
