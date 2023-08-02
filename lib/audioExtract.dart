import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioExtractorPage extends StatefulWidget {
  @override
  _AudioExtractorPageState createState() => _AudioExtractorPageState();
}

class _AudioExtractorPageState extends State<AudioExtractorPage> {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  VideoPlayerController? _videoPlayerController;
  List<String> extractedAudioPaths = [];
  String? _currentText;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset('assets/Skype_Video.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<String> _copyAssetToTempDirectory() async {
    String videoPath = 'assets/Skype_Video.mp4';

    Directory? tempDir = await getTemporaryDirectory();
    String tempFilePath = '${tempDir.path}/Skype_Video.mp4';

    ByteData data = await rootBundle.load(videoPath);
    List<int> bytes = data.buffer.asUint8List();

    File tempFile = File(tempFilePath);
    await tempFile.writeAsBytes(bytes);

    return tempFilePath;
  }

  void _extractAudioFromVideo() async {
    String tempFilePath = await _copyAssetToTempDirectory();

    // Create a temporary directory to store the extracted audio files
    Directory? tempDir = await getExternalStorageDirectory();
    String outputPath =
        '${tempDir?.path}/audio${DateTime.now().millisecondsSinceEpoch}.m4a';

    // Execute the FFmpeg command to extract audio from the video
    var result = await _flutterFFmpeg
        .execute('-i $tempFilePath -vn -c:a copy $outputPath');

    if (result == 0) {
      setState(() {
        extractedAudioPaths.add(outputPath);
      });
    }
  }

  void _convertAudioToText() async {
    if (extractedAudioPaths.isNotEmpty) {
      String outputPath = extractedAudioPaths.last;
      String text = await convertAudioToText(outputPath);
      print('Extracted Text from Audio: $text');
      setState(() {
        _currentText = text;
      });
    } else {
      print('No audio file to convert.');
    }
  }

  Future<String> convertAudioToText(String outputPath) async {
    final speech = stt.SpeechToText();
    bool isAvailable = await speech.initialize();
    if (!isAvailable) {
      // Speech-to-text is not available on the device
      return "Speech-to-text is not available on this device.";
    }

    String text = "";
    stt.SpeechResultListener result = await speech.listen(onDevice: outputPath);
    if (result != null) {
      text = result.toString();
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Extractor'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 400,
            // width: 800,
            child: Center(
              child: _videoPlayerController != null &&
                      _videoPlayerController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    )
                  : const Text('Loading...'),
            ),
          ),
          ElevatedButton(
            onPressed: _extractAudioFromVideo,
            child: Text('Extract Audio'),
          ),
          ElevatedButton(
            onPressed: _convertAudioToText,
            child: Text('Convert Text'),
          ),
          if (_currentText != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Converted Text: $_currentText',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: extractedAudioPaths.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Extracted Audio ${index + 1}'),
                  subtitle: Text(extractedAudioPaths[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_videoPlayerController != null &&
              _videoPlayerController!.value.isInitialized) {
            setState(() {
              _videoPlayerController!.value.isPlaying
                  ? _videoPlayerController!.pause()
                  : _videoPlayerController!.play();
            });
          }
        },
        child: Icon(
          _videoPlayerController?.value.isPlaying ?? false
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
