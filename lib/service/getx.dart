import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:lilac_machine_test/model/user_model.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class GetController extends GetxController {

  UserModel newUserModel = UserModel();
  bool isDarkThemeSelected = false;
  final videoFiles = <drive.File>[].obs;
  double _progress = 0.0;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    drive.DriveApi.driveFileScope,
    drive.DriveApi.driveMetadataReadonlyScope,
  ]);
  drive.DriveApi? driveApi;
  final GlobalKey<ScaffoldState> key = GlobalKey();
  String API_KEY = 'AIzaSyAv3LCC4LjPaz3Q2_53C-8lW6qfj_E-UlE';
  var selectedFile;
  int index = 0;
  late VideoPlayerController fileVideoPlayerController;
  late Directory directory;
  RxList<File> mp4Files = <File>[].obs;
  final Rx<File?> selectedVideo = Rx<File?>(null);
  final controllerRef = Rx<InAppWebViewController?>(null);
  VideoPlayerController? videoPlayerController;
  late VideoPlayerController fileVideoController;
  late Future<void> initializeVideoPlayerFuture;
  late VideoPlayerController? videoListPlayerController;
  late ChewieController? chewieController;
  bool isDataLoading = false;



  getUserDetails(UserModel userModel) {
    newUserModel = userModel;
    this.update();
  }

  void selectVideo(File file) {
    selectedVideo.value = file;
  }


  Future<void> fetchMp4Files() async {
    String downloadFolderPath = '/storage/emulated/0/Download';
    Directory directory = Directory(downloadFolderPath);
    List<FileSystemEntity> files = directory.listSync(recursive: true);

    List<File> tempFiles = [];

    for (FileSystemEntity file in files) {
      if (file is File && file.path.endsWith('.mp4')) {
        tempFiles.add(file as File);
      }
    }

    mp4Files.assignAll(tempFiles);
    update();
  }


  Future downloadFiles(String url, name){
    return FileDownloader.downloadFile(
          url: url,
          name: name,
          onProgress: (String? fileName, double progress) {
            _progress = progress;
            showProgressBarNotification(progress);
          },
          onDownloadCompleted: (String path) {
          },
          onDownloadError: (String error) {
          });
  }

  void showProgressBarNotification(double progress) {
    final int progressPercentage = (progress * 100).toInt();

    Fluttertoast.showToast(
      msg: 'Downloading...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }



  Future<void> initializeDriveApi() async {
    final client = await _googleSignIn.signInSilently();
    if (client == null) {
      await _googleSignIn.signIn();
    }
    final currentUser = _googleSignIn.currentUser;
    if (currentUser != null) {
      final authHeaders = await currentUser.authHeaders;
      final authenticatedClient = _AuthClient(authHeaders['Authorization']!);
      authenticatedClient.headers['X-Goog-Api-Key'] = API_KEY;
      driveApi = drive.DriveApi(authenticatedClient);
       var fileList = await driveApi?.files.list(q: "mimeType='video/mp4'",
           $fields: 'files(kind,name,id,webContentLink,webViewLink)');
      if (fileList != null && fileList.files != null) {
        for (var file in fileList.files!) {
          final kind = file.kind;
          final name = file.name;
          final id = file.id;
          final webContentLink = file.webContentLink;
          final webViewLink = file.webViewLink;
          final extension = file.fileExtension;
        }
      }
      videoFiles.value = fileList?.files??[];
      update();
    }
    update();
  }
}

class _AuthClient extends http.BaseClient {
  final String authorizationHeader;
  final http.Client _inner = http.Client();

  Map<String, String> _headers = {};

  Map<String, String> get headers => _headers;

  set headers(Map<String, String> headers) {
    _headers = headers;
  }

  _AuthClient(this.authorizationHeader);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    request.headers['Authorization'] = authorizationHeader;
    return _inner.send(request);
  }
}