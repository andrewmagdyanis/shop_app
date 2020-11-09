import 'dart:async';
import 'dart:io' as Io;
import 'dart:io';
import '../components/constants.dart';
import '../components/dialogs.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class SaveFile {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<Io.File> getImageFromNetwork(String url) async {
    var cacheManager = DefaultCacheManager();
    Io.File file = await cacheManager.getSingleFile(url);
    return file;
  }

  Future<void> checkPermissions () async {
    var storageStatus = await Permission.storage.status;
    var photosStatus = await Permission.photos.status;
    print('storageStatus: ' + storageStatus.toString());
    print('photoStatus: ' + photosStatus.toString());

    if (storageStatus.isUndetermined || photosStatus.isUndetermined || photosStatus
        .isDenied || photosStatus.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
          Permission.photos

    //Permission.camera,
    ].request();
    print(statuses[Permission.storage]);
    print(statuses[Permission.photos]);
  }
  }

  void notifyDownloadLocation(BuildContext scaffoldContext, String name, String imagePath){
    try {
      Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
        //backgroundColor: Colors.blueGrey,
        behavior: SnackBarBehavior.floating,
        content: Container(
          child: Text('$name is saved to '
              '$imagePath',),
        ),
      ));
    } catch (e) {
      Dialogs().showsSimpleDialog(scaffoldContext,
          dialogText: '$name is saved to '
              '$imagePath folder');
    }
  }

  Future<Io.File> saveImage(String url, String selectedFilmName, String name) async {
    //check the permissions:
    checkPermissions();

    // create directory:
    var firstPath = "/storage/emulated/0/Comicer/$selectedFilmName";
    var filePathAndName = "/storage/emulated/0/Comicer/$selectedFilmName/$name";
    await Directory(firstPath).create(recursive: true);

    //retrieve img from url:
    var response = await get(url);

    //create the file:
    File file2 = File(filePathAndName);

    //write the response body in the file
    file2.writeAsBytesSync(response.bodyBytes);

    //OR:
    //retrieve from url:
    final file = await getImageFromNetwork(url);
    return Io.File(filePathAndName)..writeAsBytesSync(file.readAsBytesSync());
  }

  Future<Io.File> pickImage(String url, String selectedFilmName, String name) async {
    /*var response = await http.get(url);
    var filePath = await ImagePickerSaver.saveFile(
        fileData: response.bodyBytes);
    var savedFile= File.fromUri(Uri.file(filePath));
     */
    var dirPath = "/storage/emulated/0/Android/data/com.comic"
        ".comicer/files/Pictures/$selectedFilmName";
    var filePath = dirPath + name;
    var response = await get(url);
    var documentDirectory = await getExternalStorageDirectory();
    await Directory(dirPath).create(recursive: true);

    File file = new File(join(dirPath, name));
    print(documentDirectory.path);
    return file..writeAsBytesSync(response.bodyBytes); // This is a sync operation on a real
  }

  Future<void> downloadImage(String url, String selectedFilmName, String name, BuildContext
  scaffoldContext)async{
    var imagePath;
    try {
      File file = await saveImage(url, selectedFilmName, name);
      imagePath = file.path;
      print('imagePath'+imagePath);
    }
    catch(e){
      File file = await pickImage(url, selectedFilmName, name);
      imagePath = file.path;
      print('imagePath'+imagePath);
    }
    SaveFile().notifyDownloadLocation(scaffoldContext, name, imagePath);

  }
}
