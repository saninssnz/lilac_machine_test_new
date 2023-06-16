import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
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
  // RxList<String> mp4FileNames = <String>[].obs;
  drive.DriveApi? driveApi;
  final GlobalKey<ScaffoldState> key = GlobalKey();
  String API_KEY = 'AIzaSyAv3LCC4LjPaz3Q2_53C-8lW6qfj_E-UlE';
  var selectedFile;
  int index = 0;
  late VideoPlayerController fileVideoPlayerController;
  late Directory directory;
  RxList<File> mp4Files = <File>[].obs;
  final Rx<File?> selectedVideo = Rx<File?>(null);


  getUserDetails(UserModel userModel) {
    newUserModel = userModel;
    this.update();
  }

  // Future<void> fetchMp4Files() async {
  //   String downloadFolderPath = '/storage/emulated/0/Download';
  //   Directory directory = Directory(downloadFolderPath);
  //   List<FileSystemEntity> files = directory.listSync(recursive: true);
  //
  //   if (await directory.exists()) {
  //     final files = await directory
  //         .list(recursive: false)
  //         .where((entity) => entity is File && entity.path.endsWith('.mp4'))
  //         .map((entity) => File(entity.path))
  //         .toList();
  //     mp4Files.assignAll(files);
  //     update();
  //   }
  // }

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

  // Future<void> initializeDriveApi() async {
  //   final client = await _googleSignIn.signInSilently();
  //   if (client == null) {
  //     await _googleSignIn.signIn();
  //   }
  //   final currentUser = _googleSignIn.currentUser;
  //   if (currentUser != null) {
  //     final authHeaders = await currentUser.authHeaders;
  //     final authenticatedClient = http.Client();
  //     final url = Uri.parse('https://www.googleapis.com/drive/v3/files?key=' + API_KEY);
  //     final request = http.Request('GET', url);
  //     request.headers['Authorization'] = authHeaders['Authorization']!;
  //     request.headers['X-Goog-Api-Key'] = API_KEY;
  //     final streamedResponse = await authenticatedClient.send(request);
  //     final response = await http.Response.fromStream(streamedResponse);
  //     if (response.statusCode == 200) {
  //       driveApi = drive.DriveApi(authenticatedClient);
  //     } else {
  //       print('Failed to authenticate: ${response.statusCode}');
  //     }
  //   }
  // }

  //
  // Future<void> downloadFile(String webContentLink, String savePath) async {
  //   final response = await http.get(Uri.parse(webContentLink));
  //   final file = File(savePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   print('File downloaded successfully!');
  // }

  Future downloadFiles(String url, name){
    return FileDownloader.downloadFile(
          url: url,
          name: name,
          onProgress: (String? fileName, double progress) {
            _progress = progress;
            showProgressBarNotification(progress);
            print('FILE fileName HAS PROGRESS $progress');
          },
          onDownloadCompleted: (String path) {
            print('FILE DOWNLOADED TO PATH: $path');
          },
          onDownloadError: (String error) {
            print('DOWNLOAD ERROR: $error');
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
      print(currentUser);
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

          // Do something with the retrieved file metadata
          print('Kind: $kind');
          print('Name: $name');
          print('ID: $id');
          print('Web Content Link: $webContentLink');
          print('Web View Link: $webViewLink');
          print('Extension: $extension');
          print('---------------------');
        }
      }
      videoFiles.value = fileList?.files??[];
      update();
    }
    update();
  }

  // Future<void> updateWebContentLink(String fileId, String webContentLink) async {
  //   final authHeaders = await _googleSignIn.currentUser?.authHeaders;
  //   final authenticatedClient = _AuthClient(authHeaders!['Authorization']!);
  //   final driveApi = drive.DriveApi(authenticatedClient);
  //   final file = drive.File();
  //   file.webContentLink = webContentLink;
  //
  //   try {
  //     await driveApi.files.update(file, fileId);
  //     print('Web content link updated successfully.');
  //   } catch (e) {
  //     print('Failed to update web content link: $e');
  //   }
  // }


  // Future<void> listFiles() async {
  //   try {
  //     final response = await driveApi?.files.list();
  //       videoFiles = response!.files!;
  //   } catch (error) {
  //     print('Error listing files: $error');
  //   }
  //   update();
  // }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    driveApi = null;
    videoFiles.clear();
  }


  // Future<void> retrieveVideoFiles() async {
  //   try {
  //     final authClient = await authenticate();
  //     final files = await getVideoFiles(authClient);
  //     videoFiles = files;
  //   } catch (e) {
  //     print('Error retrieving video files: $e');
  //   }
  // }


  // Future<auth.AuthClient> authenticate() async {
  //   const scopes = [drive.DriveApi.driveReadonlyScope];
  //   final clientId = auth.ClientId(
  //       '202959916943-f3n8pfu791qr69u214e4vmglharaqtob.apps.googleusercontent.com',
  //       'AIzaSyA-Od9lolWcOAytLFXm3ztNUitG9gL3roU');
  //   final credential = await clientViaUserConsent(
  //     clientId,
  //     scopes,
  //         (url) {
  //       launch(url);
  //       // Open the authorization URL in a webview or browser
  //     },
  //   );
  //   return credential;
  // }

  // Future<List<drive.File>> getVideoFiles(auth.AuthClient client) async {
  //   final driveApi = drive.DriveApi(client);
  //   final fileList = await driveApi.files.list(q: "mimeType='video/*'");
  //   return fileList.files ?? [];
  // }

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