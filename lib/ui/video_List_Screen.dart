import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lilac_machine_test/service/getx.dart';
import 'package:lilac_machine_test/ui/home_screen/components/drawer_screen.dart';
import 'package:lilac_machine_test/ui/home_screen/home_screen.dart';
import 'package:lilac_machine_test/utils/constants.dart';
import 'package:video_player/video_player.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {

  GetController layoutController=Get.find();
  late VideoPlayerController? _videoPlayerController;
  late ChewieController? chewieController;


  @override
  void initState() {

    layoutController.initializeDriveApi();

    super.initState();
  }
  @override
  void dispose() {
    _videoPlayerController!.dispose();
    chewieController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Text('Videos in Drive',style: TextStyle(
          color: Colors.white
        ),),
      ),
      drawer: DrawerScreen(),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // if (layoutController.driveApi == null) {
    //   return Center(
    //     child: ElevatedButton(
    //       child: const Text('Sign In with Google'),
    //       onPressed: (){
    //         layoutController.initializeDriveApi;
    //       }
    //
    //     ),
    //   );
    // } else
    //   if (layoutController.videoFiles.isEmpty) {
    //   return Center(
    //     child: ElevatedButton(
    //       child: const Text('List Files'),
    //       onPressed: layoutController.listFiles,
    //     ),
    //   );
    // } else {
      return Obx(() =>
          ListView.builder(
            itemCount: layoutController.videoFiles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(layoutController.videoFiles[index].name!),
                  leading: Icon(Icons.video_file_rounded),
                onTap: () {
                  layoutController.selectedFile = layoutController.videoFiles[index];
                  layoutController.index = index;
                  Get.to(()=>HomeScreen());
                },
              );
            },
          )
        // ListView.builder(
        // itemCount: layoutController.videoFiles.length,
        // itemBuilder: (context, index) {
        //   final file = layoutController.videoFiles[index];
        //   return ListTile(
        //     leading: Icon(Icons.ac_unit),
        //     title: Text(file.name ?? 'Untitled'),
        //     subtitle: Text(file.id ?? ''),
        //     onTap: (){
        //       playVideo(file.webViewLink ?? '');
        //     },
        //   );
        // },
        // )
      );

    // }
  }

  Future<void> playVideo(String videoUrl) async {
    final videoPlayerController = VideoPlayerController.network(videoUrl);
    videoPlayerController.initialize().then((_) {
      videoPlayerController.play();
    });

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
