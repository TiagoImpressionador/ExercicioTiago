import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerPage extends StatefulWidget {
  final String title;
  final String url; // pode ser mp4 ou link do YouTube
  const VideoPlayerPage({super.key, required this.title, required this.url});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _mp4Ctrl;
  ChewieController? _chewie;
  YoutubePlayerController? _ytCtrl;
  String? _err;

  bool get _isYouTube {
    final u = widget.url.toLowerCase();
    return u.contains('youtube.com') || u.contains('youtu.be');
  }

  String? _extractYouTubeId(String url) {
    // tenta pegar o ID em vários formatos
    final patterns = <RegExp>[
      RegExp(r'youtu\.be/([0-9A-Za-z_-]{11})'),
      RegExp(r'v=([0-9A-Za-z_-]{11})'),
      RegExp(r'embed/([0-9A-Za-z_-]{11})'),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(url);
      if (m != null && m.groupCount >= 1) return m.group(1);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      if (_isYouTube) {
        final id = _extractYouTubeId(widget.url);
        if (id == null) {
          throw Exception('URL do YouTube inválido');
        }
        _ytCtrl = YoutubePlayerController.fromVideoId(
          videoId: id,
          autoPlay: true,
          params: const YoutubePlayerParams(
            showFullscreenButton: true,
            strictRelatedVideos: true,
            enableCaption: true,
          ),
        );
        setState(() {});
      } else {
        _mp4Ctrl = VideoPlayerController.networkUrl(Uri.parse(widget.url));
        await _mp4Ctrl!.initialize();
        _chewie = ChewieController(
          videoPlayerController: _mp4Ctrl!,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
          allowMuting: true,
          allowPlaybackSpeedChanging: true,
        );
        setState(() {});
      }
    } catch (e) {
      _err = 'Falha ao carregar o vídeo.\n${e.toString()}';
      setState(() {});
    }
  }

  @override
  void dispose() {
    _chewie?.dispose();
    _mp4Ctrl?.dispose();
    _ytCtrl?.close(); // youtube_iframe
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _err != null
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_err!, style: const TextStyle(color: Colors.white)),
              )
            : _isYouTube
                ? (_ytCtrl == null
                    ? const CircularProgressIndicator(color: Colors.white)
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubePlayer(controller: _ytCtrl!),
                      ))
                : (_chewie == null
                    ? const CircularProgressIndicator(color: Colors.white)
                    : AspectRatio(
                        aspectRatio: _mp4Ctrl!.value.aspectRatio == 0
                            ? 16 / 9
                            : _mp4Ctrl!.value.aspectRatio,
                        child: Chewie(controller: _chewie!),
                      )),
      ),
    );
  }
}
