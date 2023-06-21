// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Online Video Player'),
//       ),
//       body: Center(
//         child: Chewie(
//           controller: _chewieController!,
//         ),
//       ),
//     );
//   }
// }

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
  GetController layoutController = Get.find();
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {

    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

    _videoPlayerController = VideoPlayerController.network(
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    );

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
    );
    // layoutController.videoPlayerController = VideoPlayerController.network(layoutController
    //     .selectedFile.webViewLink
    //     .replaceAll('view?usp=drivesdk', 'preview')
    //     .toString())
    //   ..initialize();

    layoutController.fetchMp4Files();

    // _controller = VideoPlayerController.network(
    //   'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    // );
    //
    // _controller!.addListener(() {
    //   setState(() {});
    // });
    // _controller!.setLooping(true);
    // _controller!.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // layoutController.videoPlayerController!.dispose();
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
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
                      Center(
                        child: AspectRatio(
                          aspectRatio: _videoPlayerController!.value.aspectRatio,
                          child: Chewie(
                            controller: _chewieController!,
                          ),
                        ),
                      ),
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
                          // if(layoutController.index==0){
                          //   layoutController.index=layoutController.videoFiles.length-1;
                          // }
                          // else {
                          //   layoutController.index--;
                          // }
                          // layoutController.selectedFile =
                          // layoutController.videoFiles[layoutController.index];
                          // String selectedVideoUrl = layoutController
                          //     .selectedFile.webViewLink
                          //     .replaceAll('view?usp=drivesdk', 'preview')
                          //     .toString();
                          // final webViewController = layoutController
                          //     .controllerRef.value;
                          // webViewController?.loadUrl(urlRequest: URLRequest(
                          //     url: Uri.parse(selectedVideoUrl)));
                        }),
                        InkWell(
                          onTap: () async {
                            var status = await Permission.storage.request();
                            if (status.isGranted) {
                              String? savePath =
                                  (await getExternalStorageDirectory())!.path +
                                      "/" +
                                      'sample.mp4';
                              await layoutController.downloadFiles(
                                  'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
                                  savePath);
                              layoutController.fetchMp4Files();
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
                        Utils.forwardButton(onTap: () {
                          // if(layoutController.index==layoutController.videoFiles.length-1){
                          //   layoutController.index=0;
                          // }
                          // else {
                          //   layoutController.index++;
                          // }
                          // layoutController.selectedFile =
                          // layoutController.videoFiles[layoutController.index];
                          // String selectedVideoUrl = layoutController
                          //     .selectedFile.webViewLink
                          //     .replaceAll('view?usp=drivesdk', 'preview')
                          //     .toString();
                          // final webViewController = layoutController
                          //     .controllerRef.value;
                          // webViewController?.loadUrl(urlRequest: URLRequest(
                          //     url: Uri.parse(selectedVideoUrl)));
                        })
                      ],
                    ),
                  ),
                  Text("Downloads",style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),),
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
                          title: Text(fileName),
                          leading: Icon(Icons.video_file_rounded),// Display file name
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

}


