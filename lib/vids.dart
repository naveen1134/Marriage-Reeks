import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reelsclone/record.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'play.dart';

class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Video> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        elevation: 5,
        automaticallyImplyLeading: false,
        title: const Text(
          'Videos',
          style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: FutureBuilder(
        future: _getVideos(),
        builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7,
                children: snapshot.data!,
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 255, 255, 255),
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.video_camera_back_rounded,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecordPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> _getVideos() async {
    final directory = Directory('/storage/emulated/0/Movies/Vids');
    List<FileSystemEntity> files = directory.listSync();
    List<FileSystemEntity> videos = [];
    for (var file in files) {
      if (file is File && file.path.endsWith('.mp4')) {
        videos.add(file);
      }
    }
    List<Widget> videoWidgets = [];
    for (var video in videos) {
      final videoFiles = File(video.path);
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: video.path,
        imageFormat: ImageFormat.JPEG,
        quality: 100,
      );
      videoWidgets.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                  videoFiles: videoFiles,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Stack(
                children: <Widget>[
                  Image.memory(
                    thumbnail!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black54,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        videoFiles.path.split('/').last,
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return videoWidgets;
  }
}
