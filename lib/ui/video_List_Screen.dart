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


  @override
  void initState() {

    layoutController.initializeDriveApi();

    super.initState();
  }
  @override
  void dispose() {
    layoutController.videoListPlayerController!.dispose();
    layoutController.chewieController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() =>Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Text('Videos in Drive',style: TextStyle(
          color: Colors.white
        ),),
      ),
      drawer: DrawerScreen(),
      body: SafeArea(
        child: layoutController.videoFiles.isEmpty?
        Center(
            child: CircularProgressIndicator(
              color: primaryColor,)):
        _buildBody(),
      ),
    ));
  }

  Widget _buildBody() {
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
      );
  }
}
