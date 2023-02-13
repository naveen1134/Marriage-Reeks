// ignore_for_file: must_be_immutable, library_private_types_in_public_api, non_constant_identifier_names, deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  File videoFiles;
  VideoPlayerScreen({
    Key? key,
    required this.videoFiles,
  }) : super(key: key);
  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController VideoController;
  late ChewieController chewieController;
  shareFiles() async {
    await Share.shareFiles(
      [widget.videoFiles.path],
    );
  }

  @override
  void initState() {
    super.initState();
    VideoController = VideoPlayerController.file(widget.videoFiles);
    chewieController = ChewieController(
      videoPlayerController: VideoController,
      autoPlay: true,
      autoInitialize: true,
      looping: false,
      allowFullScreen: true,
      fullScreenByDefault: true,
    );
  }

  @override
  void dispose() {
    VideoController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Chewie(
              controller: chewieController,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/show');
                },
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 700, left: 300),
              child: IconButton(
                onPressed: () => {
                  shareFiles(),
                },
                icon: const Icon(Icons.share),
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
