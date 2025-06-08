import 'dart:ui';

import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:faxfy/feature/add_fax/widgets/controller/add_fax_cubit.dart';
import 'package:flutter/material.dart';

final suggestionBoxController = SuggestionsBoxController();

Widget buildFormFieldSearch({
  required String label,
  required TextInputType inputType,
  required TextEditingController controller,
  required String validator,
  required IconData icon,
  required String hint,
  required AddFaxCubit cubit,
  required List<String> address,
  required setState,
}) {
  List<dynamic> getSuggestions(String query) {
    return address
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

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
              child: DropDownSearchFormField(
                suggestionsBoxController: suggestionBoxController,
                textFieldConfiguration: TextFieldConfiguration(
                  controller: controller,
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

                    hintText: controller.text.isEmpty ? hint : controller.text,
                    hintStyle: TextStyle(
                      color:
                          controller.text.isEmpty
                              ? Colors.grey.withOpacity(0.7)
                              : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return validator;
                  }
                  return null;
                },
                itemBuilder: (context, dynamic suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
                suggestionsCallback: (pattern) {
                  return getSuggestions(pattern);
                },
                onSaved: (value) {
                  controller.text = value!;
                  print('controller.text: ${controller.text}');
                  setState(() {});
                },

                onSuggestionSelected: (suggestion) {
                  controller.text = suggestion;
                  print('controller.text: ${controller.text}');

                  setState(() {});
                },
                displayAllSuggestionWhenTap: true,
              ),
            ),
          );
        },
      ),
    ],
  );
}
