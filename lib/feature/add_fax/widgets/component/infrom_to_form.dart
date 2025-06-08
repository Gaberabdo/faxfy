import 'dart:ui';

import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:faxfy/feature/add_fax/widgets/controller/add_fax_cubit.dart';
import 'package:faxfy/feature/view_fax/controller/FaxDetails_cubit.dart';
import 'package:faxfy/feature/view_fax/widgets/component/search_info.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;

class TagInputWidget extends StatefulWidget {
  final List<String> initialTags;
  final Function(List<ToInformEntities>) onTagsChanged;
  final String placeholder;
  final Color tagColor;
  final Color textColor;
  final TextEditingController controller;

  const TagInputWidget({
    super.key,
    this.initialTags = const [],
    required this.onTagsChanged,
    this.placeholder = 'أضف شخصًا أو قسمًا لإعلامه',
    this.tagColor = const Color(0xFF4361EE),
    this.textColor = Colors.white,
    required this.controller,
  });

  @override
  _TagInputWidgetState createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget>
    with SingleTickerProviderStateMixin {
  late List<ToInformEntities> _tags;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
    _tags.add(ToInformEntities('رئيس عمليات', false, '', note2: ''));
    // Setup shake animation for duplicate tags
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0)
      .chain(CurveTween(curve: ShakeCurve()))
      .animate(_shakeController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  String? enValue;
  Set<String> selectedPeople = {};

  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });

    widget.onTagsChanged(_tags);
  }

  // Get JSON string of tags
  String getTagsJson() {
    return jsonEncode(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag input field with add button
        AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: child,
            );
          },
          child: Row(
            children: [
              Expanded(
                child: buildFormFieldSearchEntity(
                  controller: widget.controller,
                  hint: 'أضف شخصًا للإبلاغ',
                  context: context,
                  items: AddFaxCubit.get(context).toInform,
                  setState: () => setState(() {}),
                  onItemSelected: (value) {
                    setState(() {
                      enValue = value;
                    });
                  },
                  selectedItems: selectedPeople,
                  onItemsSelected: (items) {
                    setState(() {
                      selectedPeople = items;
                    });
                  },
                  isEnglish: false,
                ),
              ),
              const SizedBox(width: 8),
              _buildGlassIconButton(
                icon: Icons.add,
                onPressed: () {
                  if (widget.controller.text.isNotEmpty) {
                    selectedPeople.isNotEmpty
                        ? selectedPeople.forEach((element) {
                          setState(() {
                            var model = ToInformEntities(
                              element ?? widget.controller.text,
                              false,
                              '',
                              note2: '',
                              isSelect: true,
                            );
                            _tags.add(model);

                            final seenUsernames = <String>{};
                            _tags =
                                _tags.where((item) {
                                  if (seenUsernames.contains(item.username)) {
                                    return false; // Duplicate username, exclude from the new list
                                  } else {
                                    seenUsernames.add(item.username);
                                    return true; // First time seeing this username, include it
                                  }
                                }).toList();
                            selectedPeople = {};
                            widget.onTagsChanged(_tags);
                            widget.controller.clear();
                          });
                        })
                        : setState(() {
                          var model = ToInformEntities(
                            widget.controller.text,
                            false,
                            '',
                            note2: '',
                            isSelect: true,
                          );
                          _tags.add(model);
                          final seenUsernames = <String>{};
                          _tags =
                              _tags.where((item) {
                                if (seenUsernames.contains(item.username)) {
                                  return false; // Duplicate username, exclude from the new list
                                } else {
                                  seenUsernames.add(item.username);
                                  return true; // First time seeing this username, include it
                                }
                              }).toList();
                          widget.onTagsChanged(_tags);
                          widget.controller.clear();
                        });

                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tag display area
        Container(
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
          constraints: BoxConstraints(minHeight: 60),
          child:
              _tags.isEmpty
                  ? Center(
                    child: Text(
                      'لم تتم إضافة أي أشخاص أو أقسام بعد. أضف شخصًا لإبلاغه بهذا الفاكس.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                  )
                  : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_tags.length, (index) {
                      return _buildTag(_tags[index].username, index);
                    }),
                  ),
        ),

        // Hidden field to store JSON value (for form submission)
        Opacity(opacity: 0, child: Text(getTagsJson())),
      ],
    );
  }

  Widget _buildTag(String tag, int index) {
    return Material(
      color: widget.tagColor,
      borderRadius: BorderRadius.circular(50),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {}, // Optional - could show details or edit
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 16, color: widget.textColor),
              const SizedBox(width: 6),
              Text(tag, style: TextStyle(color: widget.textColor)),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => _removeTag(index),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 12, color: widget.textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE6A23C).withOpacity(0.3),
              ),
            ),
            child: Icon(icon, color: const Color(0xFFE6A23C), size: 20),
          ),
        ),
      ),
    );
  }
}

// Custom curve for shake animation
class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t * 3 * math.pi);
  }
}
