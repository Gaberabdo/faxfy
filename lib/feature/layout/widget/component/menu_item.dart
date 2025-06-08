import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final int index;
  final String title;
  final IconData icon;
  final Animation<Offset> animation;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.index,
    required this.title,
    required this.icon,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Text(
                    title,
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontColor: ColorManager.thirdColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF8E7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: ColorManager.secondColor,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}