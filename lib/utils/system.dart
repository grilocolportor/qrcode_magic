import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

Future<void> checkPermission(TargetPlatform platform) async {
  if (platform == TargetPlatform.android) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.manageExternalStorage,
    ].request();

    if (statuses[Permission.manageExternalStorage] !=
        PermissionStatus.granted) {
      await Permission.manageExternalStorage.request();
      // if (result == PermissionStatus.granted) {
      //   return true;
      // }
    }
    if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      openAppSettings();
    }

    if (statuses[Permission.photos] != PermissionStatus.granted) {
      final result = await Permission.photos.request();
      // if (result == PermissionStatus.granted) {
      //   return true;
      // }
      if (await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  } else if (platform == TargetPlatform.iOS) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.photos,
    ].request();
    if (statuses[Permission.manageExternalStorage] !=
        PermissionStatus.granted) {
      await Permission.manageExternalStorage.request();
      // if (result == PermissionStatus.granted) {
      //   return true;
      // }
    }
    if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      openAppSettings();
    }
    if (statuses[Permission.photos] != PermissionStatus.granted) {
      final result = await Permission.photos.request();
      // if (result == PermissionStatus.granted) {
      //   return true;
      // }
      if (await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }
}

Future<File> writeBytes(Uint8List bytes, String? path) async {
  var now = DateTime.now();
  Directory? directory = await getDownloadsDirectory();
  //final Directory directory = await getApplicationDocumentsDirectory();
  final file = File(path ??
      "${directory!.path}/QRCodeMagic/${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}.png");
  try {
    await file.create(recursive: true);
    // Uint8List bytes = await file.readAsBytes();
    //final File file = File('${directory.path}/my_file.txt');
    final file2 = File(
        "${directory!.path}/QRCodeMagic/${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}.txt");
    await file.writeAsString('Isso e umte ste');
    return await file.writeAsBytes(bytes);
  } catch (e) {
    print(e);
    return file;
  }
}

Future<String?> _findLocalPath(TargetPlatform platform) async {
  if (platform == TargetPlatform.android) {
    return "/sdcard/download/";
  } else {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path + Platform.pathSeparator + 'Download';
  }
}

Future<String> read() async {
  String text;
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    text = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
    return e.toString();
  }
  return text;
}
