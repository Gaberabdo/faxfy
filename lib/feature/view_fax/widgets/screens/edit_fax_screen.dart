import 'dart:io';

import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:faxfy/feature/auth/domain/entities/user_entites.dart';
import 'package:faxfy/feature/fax_details/widget/screens/fax_system_screen.dart';
import 'package:faxfy/feature/view_fax/widgets/component/FaxHeaderDetails.dart';
import 'package:faxfy/feature/view_fax/widgets/component/add_event_dialog.dart';
import 'package:faxfy/feature/view_fax/widgets/component/new.dart';
import 'package:faxfy/feature/view_fax/widgets/component/search_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:ui';

import '../../controller/FaxDetails_cubit.dart';

class FaxSystemEditScreen extends StatefulWidget {
  FaxEntities fax;
  final String faxType;
  final dynamic startDate;
  final dynamic endDate;

  FaxSystemEditScreen({
    super.key,
    required this.fax,
    required this.faxType,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<FaxSystemEditScreen> createState() => _FaxSystemEditScreenState();
}

class _FaxSystemEditScreenState extends State<FaxSystemEditScreen> {
  // Controllers for text fields
  late TextEditingController _subjectController;
  late TextEditingController _addressController;
  late TextEditingController _indexController;
  late TextEditingController _receiverNameController;
  late TextEditingController _senderNameController;
  late TextEditingController _noteController;
  late TextEditingController _dateController;
  Set<String> selectedPeople = {};
  // List of people to inform
  List<ToInformEntities> toInform = [];
  // Controller for adding new people
  final TextEditingController _newPersonController = TextEditingController();

  // Tab controller for mobile view

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _subjectController = TextEditingController(text: widget.fax.subject);
    _addressController = TextEditingController(text: widget.fax.faxAddress);
    _dateController = TextEditingController(
      text: widget.fax.dateTime.toString().substring(0, 10),
    );
    _indexController = TextEditingController(text: widget.fax.index.toString());
    _receiverNameController = TextEditingController(
      text: widget.fax.receiverName,
    );
    _senderNameController = TextEditingController(
      text: widget.fax.senderName ?? '',
    );
    _noteController = TextEditingController(text: widget.fax.note);

    // Initialize toInform list
    toInform = List.from(widget.fax.toInform);

    print('toInform: $toInform');
    print('toInform: ${widget.fax.faxType}');
    // Initialize tab controller for mobile view
  }

  @override
  void dispose() {
    // Dispose controllers
    _subjectController.dispose();
    _addressController.dispose();
    _indexController.dispose();
    _receiverNameController.dispose();
    _senderNameController.dispose();
    _noteController.dispose();
    _newPersonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<FaxDetailsCubit>()
                ..getPdf(widget.fax.faxId)
                ..getToInform()
                ..loadFaxes(widget.fax.faxId),
      child: BlocConsumer<FaxDetailsCubit, FaxDetailsState>(
        listener: (context, state) {
          // Handle state changes if needed
        },
        builder: (context, state) {
          var cubit = FaxDetailsCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [const Color(0xFF1E2756), const Color(0xFF131A3D)],
                  ),
                ),
                child: Column(
                  children: [
                    // Mobile Tabs - Only visible on mobile
                    FaxViewHeader(
                      faxTypeModel: widget.fax.faxType,
                      faxType: widget.faxType,
                      start: widget.startDate,
                      end: widget.endDate,
                    ),
                    // Main Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildLandscapeLayout(cubit),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLandscapeLayout(FaxDetailsCubit cubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fax Edit Form
        Expanded(child: SingleChildScrollView(child: _buildFaxEditForm(cubit))),
        const SizedBox(width: 16),
        // Fax Preview
        Expanded(child: _buildFaxPreview(cubit)),
      ],
    );
  }

  Widget _buildFaxEditForm(FaxDetailsCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fax Title and Address
        Row(
          children: [
            Expanded(
              child: _buildLabeledField(
                label: 'عنوان الفاكس',
                child: _buildGlassTextField(
                  controller: _subjectController,
                  hintText: 'أدخل عنوان الفاكس',
                ),
                isSmall: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildLabeledField(
                label: 'الجهة',
                child: _buildGlassTextField(
                  controller: _addressController,
                  hintText: 'أدخل الجهة',
                ),
                isSmall: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Fax Index and Date
        Row(
          children: [
            Expanded(
              child: _buildLabeledField(
                label: 'مسلسل الوارد',
                child: _buildGlassTextField(
                  controller: _indexController,
                  hintText: 'أدخل المسلسل',
                  keyboardType: TextInputType.number,
                ),
                isSmall: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildLabeledField(
                label: 'التاريخ',
                icon: Icons.calendar_today,
                child: _buildGlassTextField(
                  controller: _dateController,
                  hintText: 'ادخل التاريخ',
                  prefixIcon: Icons.calendar_today,
                ),
                isSmall: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FaxLinkedIndicator(
          linkedFaxes: cubit.allFaxes,
          onOpenFax: (fax) {
            navigateToScreen(
              context,
              FaxSystemEditScreen(
                fax: fax,
                faxType: fax.faxType,
                endDate: widget.endDate,
                startDate: widget.startDate,
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Sender/Receiver Row
        Row(
          children: [
            Expanded(
              child: _buildLabeledField(
                label: 'جندي الفاكس المستلم',
                child: _buildGlassTextField(
                  controller: _receiverNameController,
                  hintText: 'أدخل اسم المستلم',
                  prefixIcon: Icons.person,
                ),
                isSmall: true,
              ),
            ),
            const SizedBox(width: 8),
            if (widget.fax.senderName.isNotEmpty)
              Expanded(
                child: _buildLabeledField(
                  label: 'جندي الفاكس المسلم',
                  child: _buildGlassTextField(
                    controller: _senderNameController,
                    hintText: 'أدخل اسم المسلم',
                    prefixIcon: Icons.person,
                  ),
                  isSmall: true,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // People to inform
        if (widget.fax.faxType != 'sader')
          _buildLabeledField(
            label: 'الأشخاص للإبلاغ',
            child: Column(
              children: [
                // Add new person field
                Row(
                  children: [
                    Expanded(
                      child: buildFormFieldSearchEntity(
                        controller: _newPersonController,
                        hint: 'أضف شخصًا للإبلاغ',
                        context: context,
                        items: cubit.toInform,
                        setState: () => setState(() {}),
                        onItemSelected: (value) {},
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
                        if (_newPersonController.text.isNotEmpty) {
                          selectedPeople.isNotEmpty
                              ? selectedPeople.forEach((element) {
                                setState(() {
                                  var model = ToInformEntities(
                                    element,
                                    false,
                                    '',
                                    note2: '',
                                    isSelect: true,
                                  );
                                  toInform.add(model);
                                  final seenUsernames = <String>{};
                                  toInform =
                                      toInform.where((item) {
                                        if (seenUsernames.contains(
                                          item.username,
                                        )) {
                                          return false; // Duplicate username, exclude from the new list
                                        } else {
                                          seenUsernames.add(item.username);
                                          return true; // First time seeing this username, include it
                                        }
                                      }).toList();
                                  _newPersonController.clear();
                                  selectedPeople = {};
                                });
                              })
                              : setState(() {
                                var model = ToInformEntities(
                                  _newPersonController.text,
                                  false,
                                  '',
                                  note2: '',
                                  isSelect: true,
                                );
                                toInform.add(model);
                                final seenUsernames = <String>{};
                                toInform =
                                    toInform.where((item) {
                                      if (seenUsernames.contains(
                                        item.username,
                                      )) {
                                        return false; // Duplicate username, exclude from the new list
                                      } else {
                                        seenUsernames.add(item.username);
                                        return true; // First time seeing this username, include it
                                      }
                                    }).toList();
                                _newPersonController.clear();
                              });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Display people tags
                toInform.isEmpty
                    ? Center(
                      child: Text(
                        'لم تتم إضافة أي أشخاص أو أقسام بعد. أضف شخصًا لإبلاغه بهذا الفاكس.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          toInform.length,
                          (index) => _buildEditableTag(toInform[index], index),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        const SizedBox(height: 16),

        // Notes
        _buildLabeledField(
          label: 'ملاحظات',
          child: _buildGlassTextField(
            controller: _noteController,
            hintText: 'أدخل الملاحظات',
            maxLines: 5,
          ),
        ),
        const SizedBox(height: 24),

        // Save Button
        Row(
          children: [
            Expanded(
              child: _buildGlassButton(
                icon: Icons.save,
                label: 'حفظ التغييرات',
                onPressed: () => _saveChanges(context, cubit),
              ),
            ),
            const SizedBox(width: 8),
            if (widget.fax.faxType != 'sader')
              Expanded(
                child: _buildGlassButton(
                  icon: IconlyBold.calendar,
                  label:
                      widget.fax.followDate.isEmpty
                          ? 'حفظ في المتابعة'
                          : 'تمت المتابعة بالفعل بتاريخ ${widget.fax.followDate}',
                  onPressed: () async {
                    print('save to follow up');
                    var faxEntities = await showDialog<FaxEntities>(
                      context: context,
                      builder:
                          (context) => AddEventFollowDialog(
                            cubit: cubit,
                            faxEntities: widget.fax,
                          ),
                    );
                    if (faxEntities != null) {
                      widget.fax = faxEntities;
                      setState(() {});
                    }
                  },
                ),
              ),

            const SizedBox(width: 8),
            if (MainCubit.get(context).roles.contains(Roles.create))
              if (widget.fax.faxType != 'sader')
                Expanded(
                  child: _buildGlassButton(
                    icon: Icons.print,
                    label: 'طباعة الغلاف',
                    onPressed:
                        () => _saveChanges(
                          context,
                          cubit,
                        ).then((value) => cubit.printCover(faxId: value.faxId)),
                  ),
                ),
            const SizedBox(width: 8),

            if (MainCubit.get(context).roles.contains(Roles.create))
              Expanded(
                child: _buildGlassButton(
                  icon: Icons.print,
                  label: 'طباعة الفاكس',
                  onPressed: () {
                    File file = File(cubit.localPdfFile!.path);
                    OpenFile.open(file.path);

                  },
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFaxPreview(FaxDetailsCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE6A23C).withOpacity(0.8),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE6A23C).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child:
            (cubit.localPdfFile != null)
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SfPdfViewer.file(
                    cubit.localPdfFile!,
                    interactionMode: PdfInteractionMode.pan,
                    canShowHyperlinkDialog: true,
                    canShowPaginationDialog: true,
                  ),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: const Color(0xFFE6A23C)),
                    const SizedBox(height: 16),
                    Text(
                      'جاري تحميل الفاكس...',
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildEditableTag(ToInformEntities tag, int index) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      color: tag.status ? Colors.green : const Color(0xFF4361EE),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          _showPersonNoteDialog(tag);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Icon(Icons.person, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(tag.username, style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () {
                      setState(() {
                        toInform.removeAt(index);
                      });
                    },
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ],
              ),
              Text(
                'ملاحظات.....',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required Widget child,
    IconData? icon,
    bool isSmall = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: const Color(0xFFE6A23C)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFFE6A23C),
                fontSize: isSmall ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    IconData? prefixIcon,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6A23C).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              prefixIcon:
                  prefixIcon != null
                      ? Icon(
                        prefixIcon,
                        color: const Color(0xFFE6A23C),
                        size: 20,
                      )
                      : null,
            ),
          ),
        ),
      ),
    );
  }

  void _showPersonNoteDialog(ToInformEntities personName) async {
    print('personName: ${personName.toJson()}');
    final TextEditingController _noteController = TextEditingController(
      text: personName.note1,
    );
    final TextEditingController _note2Controller = TextEditingController(
      text: personName.note2,
    );
    var inform = await showDialog<ToInformEntities>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            width: 200,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE6A23C).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ملاحظة لـ ${personName.username}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (MainCubit.get(
                      context,
                    ).roles.contains(Roles.follow)) ...[
                      Text(
                        'ملاحظات القائد',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildGlassTextField(
                        controller: _noteController,
                        hintText: 'أدخل ملاحظة',
                        maxLines: 3,
                      ),
                    ],
                    const SizedBox(height: 12),

                    if (!MainCubit.get(context).roles.contains(Roles.follow) &&
                        MainCubit.get(context).roles.contains(Roles.edit)) ...[
                      Text(
                        'ملاحظات قائد ثاني',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildGlassTextField(
                        controller: _note2Controller,
                        hintText: 'أدخل ملاحظة',
                        maxLines: 3,
                      ),
                    ],
                    const SizedBox(height: 12),

                    if (_note2Controller.text.isNotEmpty &&
                        MainCubit.get(
                          context,
                        ).roles.contains(Roles.follow)) ...[
                      Text(
                        'ملاحظات قائد ثاني',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildGlassTextField(
                        controller: _note2Controller,
                        hintText: 'أدخل ملاحظة',
                        maxLines: 3,
                      ),
                    ],

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildGlassIconButton(
                          icon: Icons.check,
                          onPressed: () {
                            Navigator.pop(context, personName);
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildGlassIconButton(
                          icon: Icons.close,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    if (inform != null) {
      toInform.firstWhere((element) {
        if (element.username == inform.username) {
          element.note1 = _noteController.text;
          element.note2 = _note2Controller.text;
          return true;
        }
        return false;
      });
      setState(() {});
    }
  }

  Widget _buildGlassButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE6A23C).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFFE6A23C), size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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

  Future<FaxEntities> _saveChanges(
    BuildContext context,
    FaxDetailsCubit cubit,
  ) async {
    final updatedFax = FaxEntities(
      faxId: widget.fax.faxId,
      subject: _subjectController.text,
      faxAddress: _addressController.text,
      index: int.tryParse(_indexController.text) ?? widget.fax.index,
      receiverName: _receiverNameController.text,
      senderName:
          _senderNameController.text.isEmpty ? '' : _senderNameController.text,
      note: _noteController.text,
      toInform: toInform,
      dateTime: DateTime.parse(_dateController.text),
      faxType: widget.fax.faxType,
      followDate: widget.fax.followDate,
      linkedFaxId: widget.fax.linkedFaxId,
    );

    cubit
        .addToFollowOrEditFax(updatedFax, context)
        .then((value) => successToast(context, 'تم حفظ التغييرات بنجاح'));

    return updatedFax;
  }
}
