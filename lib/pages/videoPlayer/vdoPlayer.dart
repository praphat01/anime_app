// import 'dart:html';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../../constants/colors.dart';
import 'package:path/path.dart';

class vdoPlayer extends StatefulWidget {
  final String bookTitle;
  final String fileBook;
  const vdoPlayer({
    Key? key,
    required this.bookTitle,
    required this.fileBook,
  });

  @override
  State<vdoPlayer> createState() => _vdoPlayerState(
        bookTitle: bookTitle,
        fileBook: fileBook,
      );
}

class _vdoPlayerState extends State<vdoPlayer> {
  String bookTitle;
  String fileBook;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  _vdoPlayerState({
    required this.bookTitle,
    required this.fileBook,
  });

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory!.path;
  }

  Future<File> get _localFile async {
    File file = new File(widget.fileBook);
    String filename = basename(file.path);
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future initializeVideo() async {
    // _videoPlayerController = VideoPlayerController.network(
    //     'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4');
    // String? path =
    //     '/storage/emulated/0/Android/data/com.example.anime_app/files/02008441.mp4';
    // final File files = File(path);
    _videoPlayerController = VideoPlayerController.file(await _localFile);

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
    );
    setState(() {});
  }

  @override
  void initState() {
    initializeVideo();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '${widget.bookTitle}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: _chewieVideoPlayer(),
    );
  }

  Widget _chewieVideoPlayer() {
    return _chewieController != null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Chewie(
              controller: _chewieController!,
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

//https://2ebook.com/new/assets/ebook_video/02008441.mp4
//https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4
