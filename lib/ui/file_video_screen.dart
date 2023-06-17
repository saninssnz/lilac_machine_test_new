import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lilac_machine_test/service/getx.dart';
import 'package:lilac_machine_test/utils/constants.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String videoPath;

  const VideoPage({required this.videoPath});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  GetController layoutController = Get.find();


  @override
  void initState() {
    super.initState();

    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    
    layoutController.fileVideoController = VideoPlayerController.file(
      File(widget.videoPath),
    );
    layoutController.initializeVideoPlayerFuture = layoutController.fileVideoController.initialize();
    layoutController.fileVideoController.play();
  }

  @override
  void dispose() {
    layoutController.fileVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Video Player'),
      ),
      body: FutureBuilder(
        future: layoutController.initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: layoutController.fileVideoController.value.aspectRatio,
              child: VideoPlayer(layoutController.fileVideoController),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
