import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/configs/firebase_options.dart';
import 'package:flutter_chat_app/core/constant/theme.dart';
import 'package:flutter_chat_app/core/route/route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      child: ChatApp(),
    ),
  );
}

class ChatApp extends ConsumerWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: themeData,
        routerConfig: router,
      ),
    );
  }
}
