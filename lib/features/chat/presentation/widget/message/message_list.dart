import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat/presentation/widget/message/message_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/chat_provider.dart';
import '../../../domain/message.dart';

class MessageList extends ConsumerStatefulWidget {
  const MessageList({
    super.key,
    required this.senderId,
    required this.receiverId,
    this.chatRoomId,
  });

  final String senderId;
  final String? chatRoomId;
  final String receiverId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MessageListState();
}

class MessageListState extends ConsumerState<MessageList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageList = ref.watch(messagesListProvider(
      widget.chatRoomId,
      widget.senderId,
      widget.receiverId,
    ));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return switch (messageList) {
      AsyncData(:final value) => ListView.builder(
          controller: _scrollController,
          cacheExtent: 1000,
          itemCount: value.length,
          itemBuilder: (context, index) {
            final Message message = value[index];
            final bool isReceiver = message.receiverId == widget.receiverId;

            return MessageItem(isReceiver: isReceiver, message: message);
          },
        ),
      AsyncError(:final error) => Center(
          child: Text(error.toString()),
        ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
