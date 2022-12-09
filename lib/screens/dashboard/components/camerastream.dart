import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:haishin_kit/audio_settings.dart';
import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/net_stream_drawable_texture.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:haishin_kit/rtmp_stream.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:haishin_kit/video_source.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:icusensor/constants.dart';
import 'package:string_validator/string_validator.dart';

class CameraStream extends StatefulWidget {
  CameraStream({Key? key, required this.isFullScreen, this.onClick})
      : super(key: key);

  final bool isFullScreen;
  VoidCallback? onClick;

  @override
  State<CameraStream> createState() => _CameraStreamState();
}

class _CameraStreamState extends State<CameraStream> {
  RtmpConnection? _connection;
  RtmpStream? _stream;
  bool _recording = false;
  String _mode = "publish";
  CameraPosition currentPosition = CameraPosition.front;

  Icon playPause = const Icon(Icons.play_arrow);
  Icon recordLive = const Icon(Icons.fiber_smart_record);

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  @override
  void dispose() {
    _stream?.dispose();
    _connection?.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    // Set up AVAudioSession for iOS.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth,
    ));

    RtmpConnection connection = await RtmpConnection.create();

    connection.eventChannel.receiveBroadcastStream().listen((event) {
      switch (event["data"]["code"]) {
        case 'NetConnection.Connect.Success':
          if (_mode == "publish") {
            _stream?.publish("live");
          } else {
            _stream?.play("live");
          }
          setState(() {
            _recording = true;
          });
          break;
      }
    });

    RtmpStream stream = await RtmpStream.create(connection);
    stream.audioSettings = AudioSettings(muted: false, bitrate: 64 * 1000);
    stream.videoSettings = VideoSettings(
      width: 480,
      height: 360,
      bitrate: 512 * 1000,
    );

    stream.attachAudio(AudioSource());
    stream.attachVideo(VideoSource(position: currentPosition));

    if (!mounted) return;
    setState(() {
      _connection = connection;
      _stream = stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isFullScreen ? 500 : 273,
      padding: const EdgeInsets.all(defaultPadding * 0.5),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    if (_mode == "publish") {
                      _mode = "playback";
                      _stream?.attachVideo(null);
                      _stream?.attachAudio(null);
                      setState(() {
                        playPause = const Icon(Icons.play_arrow);
                      });
                    } else {
                      _mode = "publish";
                      _stream?.attachAudio(AudioSource());
                      _stream
                          ?.attachVideo(VideoSource(position: currentPosition));
                      setState(() {
                        playPause = const Icon(Icons.public);
                      });
                    }
                  },
                  icon: playPause),
              IconButton(
                icon: const Icon(Icons.flip_camera_android),
                onPressed: () {
                  if (currentPosition == CameraPosition.front) {
                    currentPosition = CameraPosition.back;
                  } else {
                    currentPosition = CameraPosition.front;
                  }
                  _stream?.attachVideo(VideoSource(position: currentPosition));
                },
              ),
              IconButton(
                onPressed: () {
                  if (_recording) {
                    _connection?.close();
                    setState(() {
                      _recording = false;
                      recordLive = const Icon(Icons.fiber_smart_record);
                    });
                  } else {
                    _connection?.connect("rtmp://192.168.1.9/live");
                    setState(() {
                      _recording = true;
                      recordLive = const Icon(Icons.not_started);
                    });
                  }
                },
                icon: recordLive,
              ),
              if (!widget.isFullScreen)
                IconButton(
                  onPressed: () {
                    widget.onClick!();
                  },
                  icon: const Icon(Icons.pageview),
                )
            ],
          ),
          Expanded(
              child: _stream == null
                  ? const Text("")
                  : NetStreamDrawableTexture(_stream)),
        ],
      ),
    );
  }
}
