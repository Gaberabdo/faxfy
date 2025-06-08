import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MovingText extends StatelessWidget {
  const MovingText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height:  (MediaQuery.of(context).size.width < 600) ? 100 : 50,
      color: const Color(0xA0FBC821),
      alignment: AlignmentDirectional.center,
      child: AnimatedTextKit(
        repeatForever: true,
        controller: AnimatedTextController(

        ),

        animatedTexts: [
          TyperAnimatedText(
            'تم تطوير هذه المنظومة عام 2024 بواسطة الجنود: جابر عبد الرحيم، أحمد علاء، ومحمد عبد الحميد، تحت إشراف السيد العميد/ ياسر محمد داوود،',
            speed: const Duration(milliseconds: 50),
            curve: Curves.decelerate,

            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w900,
              height: 0.12,
            ),
          ),
        ],
      ),
    );
  }
}
