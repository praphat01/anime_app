import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../../constants/colors.dart';
import 'package:path/path.dart';

import '../../models/sqlite_model.dart';

class offlineVdoPlayer extends StatefulWidget {
  const offlineVdoPlayer({
    Key? key,
    required this.sqLiteModel,
  }) : super(key: key);
  final SQLiteModel sqLiteModel;

  @override
  State<offlineVdoPlayer> createState() => _offlineVdoPlayerState();
}

class _offlineVdoPlayerState extends State<offlineVdoPlayer> {
  ChewieController? _chewieController;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  Future initializeVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.sqLiteModel.book_file));

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.sqLiteModel.book_name,
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
