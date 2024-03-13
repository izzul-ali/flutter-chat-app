import 'package:flutter_chat_app/core/route/refresh_route.dart';
import 'package:flutter_chat_app/core/screens/not_found_screen.dart';
import 'package:flutter_chat_app/features/auth/data/auth_provider.dart';
import 'package:flutter_chat_app/features/auth/data/auth_repository.dart';
import 'package:flutter_chat_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter_chat_app/features/user/domain/user.dart';
import 'package:flutter_chat_app/features/user/presentation/profile_screen.dart';
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
    errorBuilder: (context, state) => const NotFoundScreen(),
    initialLocation: '/chats',
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'Onboarding',
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'Signup',
        builder: (context, state) => const SignUpScreen(),
        routes: [
          GoRoute(
            path: 'login',
            name: 'Login',
            builder: (context, state) => const LoginScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/chats',
        name: 'Chats',
        builder: (context, state) => const ChatsScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'Profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'detail',
            name: 'Detail',
            builder: (context, state) {
              if (state.extra != null) {
                final senderId =
                    ref.watch(authRepositoryProvider).currentUser?.uid;

                final Map<String, dynamic> data =
                    state.extra as Map<String, dynamic>;

                if (data['receiver'] != null) {
                  return ChatScreen(
                    chatRoomId: data['chatRoomId'],
                    senderId: senderId!,
                    receiver: data['receiver'] as UserModel,
                  );
                }

                return const NotFoundScreen();
              }

              return const NotFoundScreen();
            },
            // routes: [
            //   GoRoute(
            //     path: 'preview/:path/:receiverId/:chatRoomId',
            //     name: 'Preview',
            //     builder: (context, state) {
            //       final Map<String, String> data = state.pathParameters;

            //       return PreviewMediaScreen(
            //         type: '',
            //         path: base64Decode(data['path']!),
            //         receiverId: data['receiverId']!,
            //         chatRoomId: data['chatRoomId']!,
            //       );
            //     },
            //   ),
            // ],
          ),
        ],
      ),
    ],
  );
}
