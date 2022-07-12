import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

const loremText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

class LightBulbPage extends StatefulWidget {
  const LightBulbPage({
    super.key,
    required this.lightColor,
  });

  final Color lightColor;

  @override
  State<LightBulbPage> createState() => _LightBulbPageState();
}

class _LightBulbPageState extends State<LightBulbPage> {
  late AssetsAudioPlayer assetsPlayer;

  late bool isBulbOn;
  void _toggleIsBulbOn() {
    setState(() {
      isBulbOn = !isBulbOn;
    });
  }

  late Offset bulbPosition;
  void _setBulbPosition(Offset newPosition, Size screenSize) {
    final isOutsideBoundaries = newPosition.dx <= 50 ||
        newPosition.dy <= 50 ||
        newPosition.dx >= (screenSize.width - 50) ||
        newPosition.dy >= (screenSize.height - 50);
    if (isOutsideBoundaries) return;

    setState(() {
      bulbPosition = newPosition;
    });
  }

  @override
  void initState() {
    super.initState();

    final screenWidth =
        window.physicalSize.shortestSide / window.devicePixelRatio;

    bulbPosition = Offset(screenWidth / 2, 100);
    isBulbOn = false;

    assetsPlayer = AssetsAudioPlayer.newPlayer();
  }

  Future<void> _playOnSound() async {
    await assetsPlayer.open(Audio('assets/audio/bulb-on.mp3'));
  }

  Future<void> _playOffSound() async {
    await assetsPlayer.open(Audio('assets/audio/bulb-off.mp3'));
  }

  @override
  void dispose() {
    assetsPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragStart: (DragStartDetails details) {
          _setBulbPosition(details.localPosition, screenSize);
        },
        onVerticalDragDown: (DragDownDetails details) {
          _setBulbPosition(details.localPosition, screenSize);
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
          _setBulbPosition(details.localPosition, screenSize);
        },
        child: Stack(
          children: <Widget>[
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return RadialGradient(
                  colors: [
                    widget.lightColor.withOpacity(0.9),
                    widget.lightColor.withOpacity(0.6),
                    widget.lightColor.withOpacity(0.5),
                    Colors.transparent.withOpacity(0.5),
                  ],
                  stops: const [0.05, 0.5, 0.8, 1],
                ).createShader(
                  Rect.fromCenter(
                    center: bulbPosition,
                    width: isBulbOn ? MediaQuery.of(context).size.width : 0,
                    height: isBulbOn ? MediaQuery.of(context).size.height : 0,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 32,
                ),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: const <Widget>[
                        Text(
                          'Flutter Secret Spagetti 🍝',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          loremText,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        FlutterLogo(size: 150),
                        SizedBox(height: 16),
                        Text(
                          loremText,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        FlutterLogo(size: 150),
                        SizedBox(height: 16),
                        Text(
                          loremText,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        FlutterLogo(size: 150),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: bulbPosition.dy,
              left: bulbPosition.dx,
              child: FractionalTranslation(
                translation: const Offset(-0.5, -0.25),
                child: GestureDetector(
                  onTap: () async {
                    if (isBulbOn) {
                      _toggleIsBulbOn();
                      await _playOffSound();
                    } else {
                      _toggleIsBulbOn();
                      await _playOnSound();
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      RotatedBox(
                        quarterTurns: 2,
                        child: Icon(
                          Icons.lightbulb_rounded,
                          color: isBulbOn
                              ? widget.lightColor
                              : widget.lightColor.withOpacity(0.3),
                          size: 50,
                          shadows: isBulbOn
                              ? [
                                  BoxShadow(
                                    color: widget.lightColor,
                                    blurRadius: 5,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      if (!isBulbOn) const SizedBox(height: 16),
                      if (!isBulbOn)
                        const Text(
                          'Click the bulb icon\n'
                          'to turn the light on!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
