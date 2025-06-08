import 'dart:ui';
import 'package:flutter/material.dart';

Widget buildFormFieldSearchEntity({
  required TextEditingController controller,
  required String hint,
  required BuildContext context,
  required List<dynamic> items,
  required void Function() setState,
  required void Function(String) onItemSelected,
  required Set<String> selectedItems,
  required void Function(Set<String>) onItemsSelected,
  bool isEnglish = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE6A23C).withOpacity(0.3)),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,

            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: (value) => onItemSelected(value),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (_) {}, // We'll handle selection in the item builder
          itemBuilder: (context) {
            return items.map((item) {
              return PopupMenuItem<String>(
                value: item,
                enabled: false, // Disable the default selection behavior
                child: StatefulBuilder(
                  builder: (context, setStateLocal) {
                    return CheckboxListTile(
                      title: Text(
                        item,
                        style: const TextStyle(color: Colors.black),
                      ),
                      value: selectedItems.contains(item),
                      onChanged: (bool? value) {
                        if (value == true) {
                          selectedItems.add(item);
                        } else {
                          selectedItems.remove(item);
                        }

                        // Update the controller text to show selected items
                        controller.text = selectedItems.join(', ');

                        // Call the callbacks
                        onItemSelected(item);
                        onItemsSelected(selectedItems);

                        // Update both local and parent state
                        setStateLocal(() {});
                        setState();
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              );
            }).toList();
          },
          offset: const Offset(0, 50),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
