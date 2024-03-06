import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../data/chat_provider.dart';
import '../../domain/message.dart';

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

class MessageItem extends StatefulWidget {
  const MessageItem({
    super.key,
    required this.isReceiver,
    required this.message,
  });

  final bool isReceiver;
  final Message message;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late VideoPlayerController _playerController;

  @override
  void initState() {
    _init();

    super.initState();
  }

  Future<void> _init() async {
    if (widget.message.type == 'video') {
      _playerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.message.message));

      await _playerController.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment:
              widget.isReceiver ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: widget.message.type == 'text'
                    ? const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      )
                    : null,
                decoration: BoxDecoration(
                  color: widget.isReceiver
                      ? const Color(0xff3D4A7A)
                      : const Color(0xffF2F7FB),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    bottomLeft: Radius.circular(widget.isReceiver ? 10 : 0),
                    topRight: const Radius.circular(10),
                    bottomRight: Radius.circular(widget.isReceiver ? 0 : 10),
                  ),
                ),
                child: widget.message.type == 'text'
                    ? Text(
                        widget.message.message,
                        style: TextStyle(
                          color: widget.isReceiver
                              ? Colors.white
                              : const Color(0xff000E08),
                        ),
                      )
                    : widget.message.type == 'image'
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                _previewMedia(),
                              );
                            },
                            child: Hero(
                              tag: 'preview',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  widget.message.message,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  height: 250,
                                ),
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              height: 250,
                              child: AspectRatio(
                                aspectRatio: 5 / 3,
                                child: VideoPlayer(_playerController),
                              ),
                            ),
                          ),
              ),
              const SizedBox(height: 2),
              Text(
                '${widget.message.timestamp.hour}:${widget.message.timestamp.minute}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff797C7B),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  MaterialPageRoute<dynamic> _previewMedia() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Preview'),
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.grey[400],
        body: InteractiveViewer(
          maxScale: 5,
          child: Center(
            child: Hero(
              tag: 'preview',
              child: Image.network(widget.message.message),
            ),
          ),
        ),
      ),
    );
  }
}
