// ignore_for_file: avoid_print, prefer_final_fields
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);
  @override
  State<RecordPage> createState() => RecordPageState();
}

class RecordPageState extends State<RecordPage> {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  VideoPlayerController? videoController;
  final ImagePicker _picker = ImagePicker();
  FilePickerResult? result;
  String? videoUrlName;
  String? audioUrlName;
  String? outputUrlName;
  File? videoFile;
  File? audioFile;
  @override
  void initState() {
    super.initState();
    videoFilePick();
  }

  click() {
    audioFilePick().then((_) {
      m();
    });
  }

  m() {
    mergeFiles().then((_) {
      Navigator.of(context).pushReplacementNamed('/show');
    });
  }

  videoFilePick() async {
    if (result == null) {
      setState(() async {
        final XFile? file = await _picker.pickVideo(
          source: ImageSource.camera,
          maxDuration: const Duration(seconds: 30),
        );
        setState(() {});
        videoUrlName = file?.path;
      });
    }
  }

  audioFilePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'aac', 'wav', 'flac', 'ogg', 'alac'],
    );
    if (result != null) {
      setState(
        () {
          audioFile = File(result.files.single.path!);
          audioUrlName = audioFile?.path;
        },
      );
    }
  }

  mergeFiles() async {
    if (outputUrlName == null) {
      const String folderName = 'Vids';
      final directory = await getApplicationDocumentsDirectory();
      final String path = '${directory.path}/$folderName';
      final folder = Directory(path);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }
      final DateTime date = DateTime.now();
      final String dateString =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final String timeString =
          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
      final String timeStamp = "$dateString-$timeString";
      final String outputUrl = '$path/$timeStamp.mp4';
      var videoController = VideoPlayerController.file(File(videoUrlName!));
      await videoController.initialize();
      int videoDuration = videoController.value.duration.inSeconds;
      final String commandToExecute =
          '-r 15 -i $videoUrlName -i $audioUrlName -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $videoDuration -y $outputUrl';
      await _flutterFFmpeg.execute(commandToExecute);
      await GallerySaver.saveVideo(outputUrl, albumName: folderName);
      setState(
        () {
          outputUrlName = outputUrl;
          videoController = VideoPlayerController.file(File(outputUrlName!))
            ..initialize().then(
              (_) {
                setState(() {});
              },
            );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                click();
              },
              child: const Text("Select Audio"),
            ),
          ],
        ),
      ),
    );
  }
}
