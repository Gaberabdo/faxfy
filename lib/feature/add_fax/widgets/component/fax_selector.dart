// File: lib/feature/add_fax/widgets/component/fax_selector.dart
import 'package:faxfy/feature/add_fax/data/models/fax_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:faxfy/feature/add_fax/widgets/controller/add_fax_cubit.dart';

class FaxSelector extends StatefulWidget {
  final Function(String) onFaxSelect;
  final int currentFaxType;
  final List<FaxEntities> allFaxes;

  const FaxSelector({
    super.key,
    required this.onFaxSelect,
    required this.currentFaxType,
    required this.allFaxes,
  });

  @override
  State<FaxSelector> createState() => _FaxSelectorState();
}

class _FaxSelectorState extends State<FaxSelector> {
  String? selectedFaxId;
  String searchTerm = '';
  int? filterType;
  bool isDialogOpen = false;

  // Mock data - replace with your actual data fetching

  List<FaxEntities> get filteredFaxes {
    return widget.allFaxes.where((fax) {
      bool matchesSearch =
          searchTerm.isEmpty ||
          fax.subject.toLowerCase().contains(searchTerm.toLowerCase()) ||
          fax.faxAddress.toLowerCase().contains(searchTerm.toLowerCase()) ||
          fax.followDate.toLowerCase().contains(searchTerm.toLowerCase()) ||
          fax.formattedDate.toLowerCase().contains(searchTerm.toLowerCase());

      bool matchesType = filterType == null || fax.faxType == filterType;

      return matchesSearch && matchesType;
    }).toList();
  }

  void handleFaxSelect(String id) {
    setState(() {
      selectedFaxId = id;
    });
    widget.onFaxSelect(id);
    Navigator.of(context).pop(); // Close dialog
  }

  void clearSelection() {
    setState(() {
      selectedFaxId = null;
    });
    widget.onFaxSelect(''); // 0 or null to indicate no selection
  }

  FaxEntities? get selectedFax {
    if (selectedFaxId == null) return null;
    return widget.allFaxes.firstWhere((fax) => fax.faxId == selectedFaxId);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              _showFaxSelectionDialog(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFF5B93F).withOpacity(0.4),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  selectedFaxId != null
                      ? Row(
                        children: [
                          Icon(
                            Icons.link,
                            size: 16,
                            color: const Color(0xFFF5B93F),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              '${selectedFax?.subject}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      )
                      : const Text(
                        'اختر فاكس للربط',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (selectedFaxId != null)
          IconButton(
            onPressed: clearSelection,
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
          ),
      ],
    );
  }

  void _showFaxSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'اختر فاكس للربط',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search and filter row
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'ابحث عن فاكس...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchTerm = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Fax list
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child:
                            filteredFaxes.isEmpty
                                ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'لا توجد نتائج مطابقة للبحث',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filteredFaxes.length,
                                  itemBuilder: (context, index) {
                                    final fax = filteredFaxes[index];
                                    final isSelected =
                                        selectedFaxId == fax.faxId;

                                    return Card(
                                      elevation: 1,
                                      margin: const EdgeInsets.only(bottom: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),

                                      ),
                                      color:
                                          isSelected
                                              ? Colors.white.withOpacity(0.2)
                                              : Colors.white,
                                      child: InkWell(
                                        onTap: () => handleFaxSelect(fax.faxId),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          fax.faxAddress,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 2,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                widget.currentFaxType ==
                                                                        1
                                                                    ? const Color(
                                                                      0xFFF5B93F,
                                                                    )
                                                                    : Colors
                                                                        .grey
                                                                        .shade300,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            widget.currentFaxType ==
                                                                    2
                                                                ? 'صادر'
                                                                : 'وارد',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  widget.currentFaxType ==
                                                                          1
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      fax.subject,
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade700,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                  ],
                                                ),
                                              ),
                                              if (isSelected)
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Color(0xFF4CAF50),
                                                  size: 24,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('إلغاء'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
