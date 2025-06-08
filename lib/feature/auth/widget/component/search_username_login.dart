import 'dart:ui';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/utils/theme/fonts/font_styles.dart';

final suggestionBoxController = SuggestionsBoxController();

Widget buildFormFieldSearchEntityLogin({
  required TextInputType inputType,
  required TextEditingController controller,
  required String validator,
  required String hint,
  required BuildContext context,
  required List<dynamic> address,
  required void Function() setState,
  required void Function(String) onEnValueSelected, // <-- Add this
  bool isEnglish = false,
}) {
  List<dynamic> getSuggestions(String query) {
    return address.where((e) {
      final value = e.toLowerCase();
      return value.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  OutlineInputBorder _borderStyle() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.grey, width: 1),
  );
  return DropDownSearchFormField(
    suggestionsBoxController: suggestionBoxController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'الرجاء إدخال اسم المستخدم';
      }
      return null;
    },
    textFieldConfiguration: TextFieldConfiguration(
      controller: controller,

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        filled: true,
        fillColor: Colors.white,
        hintText: 'أدخل اسم المستخدم',
        hintStyle: FontStyleThame.textStyle(
          context: context,
          fontColor: const Color(0xFF1E2756),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: const Icon(IconlyLight.profile, color: Color(0xFF1E2756)),
        hintTextDirection: TextDirection.rtl,
        border: _borderStyle(),
        enabledBorder: _borderStyle(),
        focusedBorder: _borderStyle(),
        errorBorder: _borderStyle(),
        disabledBorder: _borderStyle(),
        focusedErrorBorder: _borderStyle(),
      ),
    ),

    itemBuilder: (context, dynamic suggestion) {
      return ListTile(
        title: Text(suggestion, style: const TextStyle(color: Colors.black)),
      );
    },
    suggestionsCallback: (pattern) {
      return getSuggestions(pattern);
    },
    onSaved: (value) {
      controller.text = value!;
      setState();
    },

    onSuggestionSelected: (suggestion) {
      controller.text = suggestion;
      onEnValueSelected(suggestion); // <-- Use callback
      setState();
    },
    displayAllSuggestionWhenTap: true,
  );
}
