import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewMedia extends StatefulWidget {
  const PreviewMedia({super.key, required this.type, required this.url});

  final String type;
  final String url;

  @override
  State<PreviewMedia> createState() => _PreviewMediaState();
}

class _PreviewMediaState extends State<PreviewMedia> {
  late FlickManager? _flickManager;

  @override
  void initState() {
    if (widget.type == 'video') {
      _flickManager = FlickManager(
        autoPlay: true,
        autoInitialize: true,
        videoPlayerController:
            VideoPlayerController.networkUrl(Uri.parse(widget.url)),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _flickManager?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Preview'),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: widget.type == 'image',
      backgroundColor: Colors.grey[400],
      body: Center(
        child: widget.type == 'image'
            ? InteractiveViewer(
                maxScale: 5,
                child: Hero(
                  tag: 'preview-image',
                  child: CachedNetworkImage(
                    imageUrl: widget.url,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error_outline)),
                  ),
                ),
              )
            : Hero(
                tag: 'preview-video',
                child: FlickVideoPlayer(flickManager: _flickManager!),
              ),
      ),
    );
  }
}
