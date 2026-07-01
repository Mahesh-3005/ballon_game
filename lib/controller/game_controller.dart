import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class GameController extends GetxController {
  var score = 0.obs;
  var targetColor = Colors.red.obs;
  final player = AudioPlayer();
  var poppingIndex = (-1).obs;
  late ConfettiController confettiController;


  List<MaterialColor> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];

  var balloons = <Color>[].obs;

  var showCorrect = false.obs;
  var showWrong = false.obs;

  @override
  void onInit() {
    confettiController =
      ConfettiController(duration: const Duration(milliseconds: 300));
    generateRound();
    super.onInit();
  }

  void generateRound() {
    final random = Random();

    // pick target
    targetColor.value = colors[random.nextInt(colors.length)];

    balloons.clear();

    // ensure at least one correct balloon
    balloons.add(targetColor.value);

    // fill remaining randomly
    while (balloons.length < 4) {
      balloons.add(colors[random.nextInt(colors.length)]);
    }

    balloons.shuffle();
  }

  void onBalloonTap(Color color, int index) {
    if (color == targetColor.value) {
      confettiController.play();
      player.play(AssetSource('sounds/correct.mp3'));

      poppingIndex.value = index;

      Future.delayed(const Duration(milliseconds: 250), () {
        poppingIndex.value = -1;
        score++;

        showCorrect.value = true;
        Future.delayed(const Duration(milliseconds: 400), () {
          showCorrect.value = false;
          generateRound();
        });
      });
    } else {
      player.play(AssetSource('sounds/wrong.mp3'));

      showWrong.value = true;
      Future.delayed(const Duration(milliseconds: 400), () {
        showWrong.value = false;
      });
    }
  }

  String getColorName(Color color) {
    if (color == Colors.red) return "RED";
    if (color == Colors.blue) return "BLUE";
    if (color == Colors.green) return "GREEN";
    if (color == Colors.yellow) return "YELLOW";
    return "";
  }

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }
}
