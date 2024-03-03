import 'package:flutter_chat_app/core/route/refresh_route.dart';
import 'package:flutter_chat_app/core/screens/not_found_screen.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:flutter_chat_app/features/auth/data/auth_repository.dart';
import 'package:flutter_chat_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/screens/signin_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/chat/presentation/screens/chats_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';

part 'route.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final AuthRepository authProvider = ref.watch(authRepositoryProvider);

  return GoRouter(
    redirect: (context, state) {
      final bool isLoggedIn = authProvider.currentUser != null;

      if (isLoggedIn) {
        if (state.uri.path.startsWith('/signup') ||
            state.uri.path.startsWith('/onboarding')) {
          return '/chats';
        }

        return null;
      }

      if (!isLoggedIn && !state.uri.path.startsWith('/signup')) {
        return '/onboarding';
      }

      return null;
    },
    refreshListenable: GoRouteRefreshStream(authProvider.authState),
    initialLocation: '/chats',
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
        routes: [
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              if (state.extra != null) {
                final senderId =
                    ref.watch(authRepositoryProvider).currentUser?.uid;

                final Map<String, dynamic> data =
                    state.extra as Map<String, dynamic>;

                return ChatScreen(
                  chatRoomId: data['chatRoomId'],
                  senderId: senderId!,
                  receiver: data['receiver'] as UserModel,
                );
              }

              return const NotFoundScreen();
            },
          ),
        ],
      ),
    ],
  );
}
