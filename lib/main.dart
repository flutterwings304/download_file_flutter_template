import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
           debug: false // optional: set to false to disable printing logs to console (default: true)
    
            ); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
     
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {  ReceivePort _port = ReceivePort();
  @override
  void initState() {

    super.initState();
   
      IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      _port.listen((dynamic data) {
        String id = data[0];
        DownloadTaskStatus status = data[1];
        int progress = data[2];
       
         setState((){ });
      });
      FlutterDownloader.registerCallback(downloadCallback);
    
  }
  @override
  void dispose() {
   
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download network file"),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () async {
      final taskId = await FlutterDownloader.enqueue(
  url: 'http://enos.itcollege.ee/~jpoial/allalaadimised/reading/Android-Programming-Cookbook.pdf',

  savedDir: '/storage/emulated/0/Download',
  showNotification: true, // show download progress in status bar (for Android)
  openFileFromNotification: true, // click on notification to open downloaded file (for Android)
);
      }, label: Text(
        "Download file"
      )),
    );
  }
}