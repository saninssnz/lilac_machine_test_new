import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lilac_machine_test/model/user_model.dart';
import 'package:lilac_machine_test/service/getx.dart';
import 'package:lilac_machine_test/ui/file_video_screen.dart';
import 'package:lilac_machine_test/ui/home_screen/components/drawer_screen.dart';
import 'package:lilac_machine_test/utils/constants.dart';
import 'package:lilac_machine_test/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:permission_handler/permission_handler.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VideoPlayerController? _videoPlayerController;
  // late ChewieController? chewieController;
  GetController layoutController = Get.find();


  @override
  void initState() {
    // playVideo(layoutController.selectedFile.webViewLink.
    // replaceAll('view?usp=drivesdk', 'preview').toString());

     FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

    _videoPlayerController = VideoPlayerController.network(layoutController
        .selectedFile.webViewLink
        .replaceAll('view?usp=drivesdk', 'preview')
        .toString())
      ..initialize();

    layoutController.fetchMp4Files();

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    // chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: layoutController.key,
      drawer: DrawerScreen(),
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade300,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: _videoPlayerController!.value.aspectRatio,
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(
                            url: Uri.parse(layoutController.selectedFile.webViewLink
                                .replaceAll('view?usp=drivesdk', 'preview')
                                .toString()),
                          ),
                          initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(),
                          ),
                          onWebViewCreated: (InAppWebViewController controller) {
                            // webView = controller;
                          },
                          onLoadStart:
                              (InAppWebViewController controller, Uri? url) {},
                          onLoadStop:
                              (InAppWebViewController controller, Uri? url) {},
                        ),
                      ),
                      // FlickVideoPlayer(
                      //     flickManager: FlickManager(
                      //       onVideoEnd: () {
                      //         // fileModel.controller!.pause();
                      //         // setState(() { });
                      //       },
                      //       autoPlay: true,
                      //       videoPlayerController: _videoPlayerController!,
                      //
                      //     ),
                      //     flickVideoWithControlsFullscreen: FlickVideoWithControls(
                      //       controls: FlickLandscapeControls(),
                      //     ),
                      //     // flickVideoWithControls: FlickVideoWithControls(
                      //     //   closedCaptionTextStyle: TextStyle(fontSize: 8),
                      //     //   controls: FlickPortraitControls(),
                      //     // ),
                      //     ),
                      // chewieController != null?
                      //   Container(
                      //     alignment: Alignment.topCenter,
                      //     child: AspectRatio(
                      //       aspectRatio: _videoPlayerController!.value.aspectRatio,
                      //         child: Chewie(controller: chewieController!,))
                      //   ),
                      //   :
                      // Container(
                      //   height: 200,
                      //   child: Center(
                      //     child: CircularProgressIndicator(),
                      //   ),
                      // ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15.0, top: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                layoutController.key.currentState!.openDrawer();
                              },
                              child: SvgPicture.asset("assets/icons/menu_icon.svg"),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20.0, right: 5),
                              child: SvgPicture.asset(
                                  "assets/images/avatar_man.svg",
                                  height: 55,
                                  width: 50),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Utils.backButton(onTap: () {
                          // if (layoutController.index > 0) {
                          //   layoutController.index--;
                          //   layoutController.selectedFile =
                          //   layoutController.mp4Files[layoutController.index];
                          //   final previousVideoUrl =
                          //       layoutController.mp4Files[layoutController.index].path;
                          //   setState(() {
                          //     _videoUrl = previousVideoUrl;
                          //   });
                          // }
                          // if (layoutController.index == 0) {
                          //   layoutController.index = 3;
                          // } else {
                          //   layoutController.index = layoutController.index - 1;
                          //   layoutController.selectedFile =
                          //       layoutController.videoFiles[layoutController.index];
                          // }
                          // Navigator.pushAndRemoveUntil(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => HomeScreen()),
                          //   (Route<dynamic> route) => false,
                          // );
                        }),
                        InkWell(
                          onTap: () async {
                            var status = await Permission.storage.request();
                            if (status.isGranted) {
                              String? savePath =
                                  (await getExternalStorageDirectory())!.path +
                                      "/" +
                                      layoutController.selectedFile.name.toString();
                              await layoutController.downloadFiles(
                                  layoutController.selectedFile.webContentLink
                                      .toString(),
                                  savePath);
                            } else {
                              // Permission denied, handle accordingly
                              print('Permission denied');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Download',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Utils.forwardButton(onTap: () {})
                      ],
                    ),
                  ),
                  Text("Downloads"),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Obx(() => ListView.builder(
                          itemCount: layoutController.mp4Files.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final file = layoutController.mp4Files[index];
                            final fileName = file.path.split('/').last; // Extract file name
                            return ListTile(
                              title: Text(fileName), // Display file name
                              onTap: () {
                                layoutController.selectVideo(file);
                                final selectedVideoPath = file.path;// Select the tapped file
                                Get.to(() => VideoPage(videoPath: selectedVideoPath));
                              },
                            );
                          },
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> playVideo(String videoUrl) async {
    _videoPlayerController = VideoPlayerController.network(videoUrl);
    // _videoPlayerController!.initialize();
    // ..addListener(() => setState(() {}))
    // ..setLooping(true)
    // ..initialize().then((value) => _videoPlayerController!.play());

    // chewieController = ChewieController(
    //   videoPlayerController: _videoPlayerController!,
    //   autoPlay: true,
    //   looping: false,
    //   allowFullScreen: true,
    //   materialProgressColors: ChewieProgressColors(
    //       backgroundColor: Colors.black,
    //       playedColor: Colors.green.shade300),
    //   allowPlaybackSpeedChanging: true,
    //   showControls: true,
    //   showOptions: false,
    // );
  }
}
