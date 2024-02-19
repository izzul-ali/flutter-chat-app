import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/screens/signin_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/chat/presentation/chats_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';

part 'route.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  ref.onDispose(() {
    print('router dispose');
  });

  final User? authProvider = ref.watch(authRepositoryProvider).currentUser;

  return GoRouter(
    redirect: (context, state) {
      final bool isLoggedIn = authProvider != null;

      if (!isLoggedIn) {
        return '/signup/login';
      }

      if (isLoggedIn && state.uri.path.startsWith('/onboarding')) {
        return '/chats';
      }

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
}
