import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constant/color.dart';
import 'package:flutter_chat_app/features/chat/presentation/widget/message/preview_media.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/message.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.isReceiver,
    required this.message,
  });

  final bool isReceiver;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: isReceiver ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: message.type == 'text'
                    ? const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      )
                    : null,
                decoration: BoxDecoration(
                  color: isReceiver
                      ? const Color(0xff3D4A7A)
                      : const Color(0xffF2F7FB),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    bottomLeft: Radius.circular(isReceiver ? 10 : 0),
                    topRight: const Radius.circular(10),
                    bottomRight: Radius.circular(isReceiver ? 0 : 10),
                  ),
                ),
                child: message.type == 'text'
                    ? Text(
                        message.message,
                        style: TextStyle(
                          color: isReceiver
                              ? Colors.white
                              : const Color(0xff000E08),
                        ),
                      )
                    : message.type == 'image'
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => PreviewMedia(
                                    type: 'image',
                                    url: message.message,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'preview-image',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: message.message,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  height: 250,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                          child: Icon(Icons.error_outline)),
                                ),
                              ),
                            ),
                          )
                        : message.type == 'image'
                            ? MessageTypeVideo(url: message.message)
                            : Container(
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.download_outlined,
                                    color: !isReceiver
                                        ? kPrimaryChatColor
                                        : Colors.white,
                                  ),
                                  title: Text(
                                    'File',
                                    style: TextStyle(
                                      color: !isReceiver
                                          ? kPrimaryChatColor
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
              ),
              const SizedBox(height: 2),
              Text(
                '${message.timestamp.hour}:${message.timestamp.minute}',
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
}

class MessageTypeVideo extends StatefulWidget {
  const MessageTypeVideo({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<MessageTypeVideo> createState() => _MessageTypeVideoState();
}

class _MessageTypeVideoState extends State<MessageTypeVideo> {
  late VideoPlayerController? _playerController;

  Future<void> _init() async {
    _playerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    await _playerController?.initialize();

    setState(() {});
  }

  @override
  void initState() {
    _init();

    super.initState();
  }

  @override
  void dispose() {
    _playerController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => PreviewMedia(
              type: 'video',
              url: widget.url,
            ),
          ),
        );
      },
      child: Hero(
        tag: 'preview-video',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: AspectRatio(
              aspectRatio: _playerController!.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_playerController!),
                  const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
