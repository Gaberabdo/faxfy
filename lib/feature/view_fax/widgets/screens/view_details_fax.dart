import 'package:faxfy/core/service/main_service/controller/main_cubit/main_cubit.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:faxfy/feature/view_fax/widgets/component/FaxHeaderDetails.dart';
import 'package:faxfy/feature/view_fax/widgets/component/add_event_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:ui';

import '../../../../core/service/service_locator/service_locator.dart';
import '../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../../add_fax/domain/entities/fax_entities.dart';
import '../../../auth/domain/entities/user_entites.dart';
import '../../controller/FaxDetails_cubit.dart';

class FaxSystemScreen extends StatefulWidget {
  FaxEntities fax;
  final String faxType;

  FaxSystemScreen({super.key, required this.fax, required this.faxType});

  @override
  State<FaxSystemScreen> createState() => _FaxSystemScreenState();
}

class _FaxSystemScreenState extends State<FaxSystemScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isPdfLoaded = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).size.width > 800;

    return BlocProvider(
      create: (context) => sl<FaxDetailsCubit>()..getPdf(widget.fax.faxId),
      child: BlocConsumer<FaxDetailsCubit, FaxDetailsState>(
        listener: (context, state) {
          // TODO: implement listener
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
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // App Bar
                        FaxViewHeader(
                          faxTypeModel: widget.fax.faxType,
                          faxType: widget.faxType,
                          start: null,
                          end: null,
                        ),

                        // Mobile Tabs - Only visible on mobile
                        if (!isLandscape) _buildMobileTabs(),

                        // Main Content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Content based on screen size
                                Expanded(
                                  child:
                                      isLandscape
                                          ? _buildLandscapeLayout(cubit)
                                          : _buildPortraitLayout(cubit),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildMobileTabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2756).withOpacity(0.8),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE6A23C), width: 0.3),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFE6A23C),
            labelColor: const Color(0xFFE6A23C),
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            tabs: const [Tab(text: 'تفاصيل الفاكس'), Tab(text: 'عرض الفاكس')],
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(FaxDetailsCubit cubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fax Details
        Expanded(child: _buildFaxDetails(cubit)),
        const SizedBox(width: 16),
        // Fax Preview
        Expanded(child: _buildFaxPreview(cubit)),
      ],
    );
  }

  Widget _buildPortraitLayout(FaxDetailsCubit cubit) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Fax Details Tab
        SingleChildScrollView(child: _buildFaxDetails(cubit)),
        // Fax Preview Tab
        _buildFaxPreview(cubit),
      ],
    );
  }

  Widget _buildFaxDetails(FaxDetailsCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fax Title
        Row(
          children: [
            Expanded(
              child: _buildLabeledField(
                label: 'عنوان الفاكس',
                child: _buildGlassContainer(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        widget.fax.subject,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                isSmall: true,
              ),
            ),

            const SizedBox(width: 8),
            Expanded(
              child: _buildLabeledField(
                label: 'الجهة',
                child: _buildGlassContainer(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        widget.fax.faxAddress,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                isSmall: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Fax Info Row
        Row(
          children: [
            Expanded(
              child: _buildLabeledField(
                label: 'مسلسل الوارد',
                child: _buildGlassContainer(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        widget.fax.index.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                isSmall: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildLabeledField(
                label: 'التاريخ',
                icon: Icons.calendar_today,
                child: _buildGlassContainer(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        widget.fax.formattedDate,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                isSmall: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Sender/Receiver Row
        Row(
          children: [
            Expanded(
              child: _buildLabeledField(
                label: 'جندي الفاكس المستلم',
                child: _buildGlassContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.person,
                          size: 16,
                          color: Color(0xFFE6A23C),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.fax.receiverName,

                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                isSmall: true,
              ),
            ),
            const SizedBox(width: 8),
            if (widget.fax.senderName.isNotEmpty)
              Expanded(
                child: _buildLabeledField(
                  label: 'جندي الفاكس المسلم',
                  child: _buildGlassContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Color(0xFFE6A23C),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.fax.senderName,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  isSmall: true,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.fax.faxType != 'sader')
          if (widget.fax.toInform.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  widget.fax.toInform.length,
                  (index) =>
                      _buildEditableTag(widget.fax.toInform[index], index),
                ),
              ),
            ),

        // Notes
        _buildLabeledField(
          label: 'ملاحظات',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildGlassContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      widget.fax.note,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  height: 120,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.all(12),
          child: _buildGlassButton(
            icon: Icons.save,
            label: 'طباعه الفاكس',
            onPressed: () {
              OpenFile.open(cubit.localPdfFile!.path);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEditableTag(ToInformEntities tag, int index) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      color: const Color(0xFF4361EE),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(tag.username, style: TextStyle(color: Colors.white)),
            const SizedBox(width: 6),
          ],
        ),
      ),
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
                : Text(
                  'محتوى الفاكس',

                  style: TextStyle(color: Colors.black54, fontSize: 18),
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

  Widget _buildGlassContainer({required Widget child, double? height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6A23C).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: child,
        ),
      ),
    );
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
            padding: const EdgeInsets.symmetric(vertical: 12),
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
}
