import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_translate/audioExtract.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late File videoFile;
  bool isVideoExist = false;
  bool isVideoPlaying = false;
  String? videoName;
  bool isVideoNameExist = false;
  bool isLoadingVideo = false;
  bool _showLoadingPopup = false;

  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  List<String> extractedAudioPaths = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose only if it's not null
    super.dispose();
  }

  Future<void> getVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        videoFile = File(pickedFile.path);
        videoName = pickedFile.name;
        print("print$videoFile");
        _controller = VideoPlayerController.file(videoFile);

        _initializeVideoPlayerFuture = _controller!.initialize();

        _controller!.setLooping(true);
        isVideoExist = true;
        isVideoNameExist = true;
        isLoadingVideo = true;
      });
      _showLoadingPopup = true;
      await Future.delayed(const Duration(seconds: 10));
      await _initializeVideoPlayerFuture;
      setState(() {
        isLoadingVideo = false;
      });
      _showLoadingPopup = false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please import video'),
          backgroundColor: Color.fromARGB(255, 202, 81, 127),
        ),
      );
    }
  }

  Future<void> extractAudioFromVideo() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String outputPath = '${appDir.path}/extracted_audio.aac';

    // Define the FFmpeg command to extract audio from the video
    // final String command ='-i ${videoFile.path} -vn -acodec copy $outputPath';
    final String command = '-i ${videoFile.path} -vn -c:a copy $outputPath';

    setState(() {
      _showLoadingPopup = true;
    });

    // Execute the FFmpeg command
    var result = await _flutterFFmpeg
        .execute('-i ${videoFile.path} -vn -acodec copy $outputPath');

    if (result == 0) {
      // Audio extraction successful
      setState(() {
        extractedAudioPaths.add(outputPath);
        _showLoadingPopup = false;
      });
    } else {
      // Audio extraction failed
      setState(() {
        _showLoadingPopup = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to extract audio'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 224, 218),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text('Video Translator'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.menu,
            ),
            offset: const Offset(0, 48),
            onSelected: (value) {
              if (value == 'Item 1') {
              } else if (value == 'Item 2') {
              } else if (value == 'Item 3') {}
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                padding: const EdgeInsets.only(left: 20, right: 50),
                value: 'Item 1',
                child: Row(
                  children: const [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('My Profile'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                padding: const EdgeInsets.only(left: 20, right: 50),
                value: 'Item 2',
                child: Row(
                  children: const [
                    Icon(
                      Icons.language,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Language'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                padding: const EdgeInsets.only(left: 20, right: 50),
                value: 'Item 3',
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 226, 224, 218),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(color: Colors.black)),
                    padding: const EdgeInsets.all(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.arrowUpFromBracket,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Import Video",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                onPressed: () {
                  getVideo();
                  _showLoadingPopup = true;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 226, 224, 218),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(color: Colors.black)),
                    padding: const EdgeInsets.all(15)),
                child: isVideoNameExist
                    ? Text(
                        "$videoName",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        "Empty",
                        style: TextStyle(color: Colors.black),
                      ),
                onPressed: () {},
              ),
              const SizedBox(height: 16.0),
              Container(
                width: 300,
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: isVideoExist
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!))
                    : Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.fast_rewind),
                    onPressed: () {
                      _controller?.seekTo(Duration(
                          seconds: _controller!.value.position.inSeconds - 10));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isVideoPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isVideoPlaying) {
                          _controller?.pause();
                        } else {
                          _controller?.play();
                        }
                        isVideoPlaying = !isVideoPlaying;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.fast_forward),
                    onPressed: () {
                      _controller?.seekTo(Duration(
                          seconds: _controller!.value.position.inSeconds + 10));
                    },
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.all(15)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(FontAwesomeIcons.closedCaptioning),
                    SizedBox(width: 10),
                    Text(
                      'Create Subtitle ',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.all(15)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AudioExtractorPage(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(FontAwesomeIcons.closedCaptioning),
                    SizedBox(width: 10),
                    Text(
                      'Extract Audio ',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _showLoadingPopup
          ? Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 300, right: 10, left: 20),
              width: 400,
              height: 220,
              child: AlertDialog(
                content: Column(
                  children: const <Widget>[
                    Text(
                      "Do not close the page, we are importing the video from your device",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Popup example'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Hello"),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            extractAudioFromVideo(); // Call the audio extraction function
            Navigator.of(context).pop();
          },
          child: const Text('Extract Audio'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
