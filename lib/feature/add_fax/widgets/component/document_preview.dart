import 'dart:io';
import 'package:faxfy/feature/add_fax/widgets/controller/add_fax_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';

import '../controller/add_fax_cubit.dart';

class DocumentPreview extends StatefulWidget {
  final bool useLocalFile;
  final int faxType;

  const DocumentPreview({
    super.key,
    this.useLocalFile = false,
    required this.faxType,
  });

  @override
  State<DocumentPreview> createState() => _DocumentPreviewState();
}

class _DocumentPreviewState extends State<DocumentPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // If using local file, prompt to pick a file on init
    if (widget.useLocalFile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pickPdfFile();
      });
    }
  }

  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        AddFaxCubit.get(context).localPdfFile = File(result.files.single.path!);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddFaxCubit, AddFaxState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = AddFaxCubit.get(context);
        return ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isHovered = true),
            onTapUp: (_) => setState(() => _isHovered = false),
            onTapCancel: () => setState(() => _isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: MediaQuery.of(context).size.height * 0.7 + 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF5B93F), width: 4),
                boxShadow:
                    _isHovered
                        ? [
                          BoxShadow(
                            color: const Color(0xFFF5B93F).withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                        : [],
              ),
              child: Stack(
                children: [
                  if (widget.useLocalFile && cubit.localPdfFile != null)
                    // Display local PDF file
                    SfPdfViewer.file(
                      cubit.localPdfFile!,
                      interactionMode: PdfInteractionMode.pan,
                      canShowHyperlinkDialog: true,
                      canShowPaginationDialog: true,
                    )
                  else if (widget.useLocalFile && cubit.localPdfFile == null)
                    // Show placeholder with button to pick file
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/pdf_icon.svg',
                            width: 150,
                            height: 150,
                            color: const Color(0xFFF5B93F),
                          ),
                          const SizedBox(height: 16),

                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _pickPdfFile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5B93F),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'اختر ملف PDF',
                              style: TextStyle(
                                color: Color(0xFF1E2756),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
