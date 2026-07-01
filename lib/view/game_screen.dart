import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/game_controller.dart';

class GameScreen extends StatelessWidget {
  final GameController controller = Get.put(GameController());

  GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlue[100],
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF81D4FA), // sky blue
                Color(0xFFB3E5FC),
                Color(0xFFE1F5FE),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 20,
                child: Icon(Icons.cloud, size: 80, color: Colors.white70),
              ),

              Positioned(
                top: 100,
                right: 30,
                child: Icon(Icons.cloud, size: 70, color: Colors.white60),
              ),
              Column(
                children: [
                  const SizedBox(height: 20),

                  // Score
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.orange, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Obx(
                      () => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("⭐ ", style: TextStyle(fontSize: 20)),
                          Text(
                            "${controller.score}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Instruction
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Tap the ${controller.getColorName(controller.targetColor.value)} balloon",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Balloons
                  Expanded(
                    child: Obx(
                      () => GridView.builder(
                        itemCount: controller.balloons.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                        itemBuilder: (context, index) {
                          final color = controller.balloons[index];

                          return _buildBalloon(color, index);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // // ✅ Correct Feedback
              // Obx(
              //   () => IgnorePointer(
              //     child: AnimatedOpacity(
              //       opacity: controller.showCorrect.value ? 1 : 0,
              //       duration: const Duration(milliseconds: 100),
              //       child: const Center(
              //         child: Text(
              //           "Awesome!",
              //           style: TextStyle(
              //             fontSize: 32,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.green,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // // ❌ Wrong Feedback
              // Obx(
              //   () => IgnorePointer(
              //     child: AnimatedOpacity(
              //       opacity: controller.showWrong.value ? 1 : 0,
              //       duration: const Duration(milliseconds: 100),
              //       child: const Center(
              //         child: Text(
              //           "Oops! Try again",
              //           style: TextStyle(
              //             fontSize: 32,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.red,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Obx(
                () => AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  top: controller.showCorrect.value ? 140 : 40,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: controller.showCorrect.value ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Center(
                        child: Text(
                          "Awesome!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Obx(
                () => AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  top: controller.showWrong.value ? 140 : 40,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: controller.showWrong.value ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Center(
                        child: Text(
                          "Oops! Try again",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: controller.confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 20,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalloon(Color color, int index) {
    return Obx(() {
      bool isPopping = controller.poppingIndex.value == index;

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: -10, end: 10),
        duration: Duration(milliseconds: 2000 + Random().nextInt(1000)),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value, -value), // 👈 wobble + float
            child: child,
          );
        },
        child: GestureDetector(
          onTap: () => controller.onBalloonTap(color, index),
          child: AnimatedScale(
            scale: isPopping ? 1.5 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: AnimatedOpacity(
              opacity: isPopping ? 0 : 1,
              duration: const Duration(milliseconds: 150),
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 95,
                      width: 95,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Container(height: 25, width: 2, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
