import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  final videoPlayerController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
  ChewieController? chewieController;
  bool isFinish = false;

  Future init() async {
    await videoPlayerController.initialize();
    videoPlayerController.addListener(checkVideo);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    chewieController?.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: videoPlayerController.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: Chewie(controller: chewieController!),
                  ),
                  isFinish
                      ? TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('閉じる'))
                      : const TextButton(onPressed: null, child: Text('閉じる')),
                ],
              )
            : Container(),
      ),
    );
  }

  void checkVideo() {
    // Implement your calls inside these conditions' bodies :
    if (videoPlayerController.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      setState(() {
        isFinish = false;
      });
      print('video Started');
    }

    if (videoPlayerController.value.position ==
        videoPlayerController.value.duration) {
      setState(() {
        isFinish = true;
      });
      print('video Ended');
    }
  }
}
