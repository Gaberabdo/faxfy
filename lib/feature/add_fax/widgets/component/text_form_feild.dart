import 'dart:ui';
import 'package:flutter/material.dart';


Widget buildFormField({
  required String label,
  required TextInputType inputType,
  required TextEditingController controller,
  required String validator,
  required IconData icon,
  required String hint,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5B93F).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFF5B93F), size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFF5B93F),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.95, end: 1.0),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF5B93F).withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: inputType,
                textDirection: TextDirection.rtl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return validator;
                  }
                  return null;
                },
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: const Color(0xFFF5B93F).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFFF5B93F),
                      width: 2,
                    ),
                  ),
                  errorBorder: InputBorder.none,
                  suffixIcon: Icon(
                    icon,
                    color: const Color(0xFFF5B93F).withOpacity(0.5),
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        },
      ),
    ],
  );
}