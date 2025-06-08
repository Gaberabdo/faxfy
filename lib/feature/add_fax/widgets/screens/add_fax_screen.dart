import 'package:faxfy/feature/add_fax/widgets/controller/add_fax_cubit.dart';
import 'package:faxfy/feature/add_fax/widgets/controller/add_fax_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../component/document_preview.dart';
import '../component/fax_form.dart';
import '../component/fax_header.dart';

class AddFaxScreen extends StatelessWidget {
  const AddFaxScreen({super.key, required this.faxType});

  final int faxType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              sl<AddFaxCubit>()
                ..getFaxIndex(faxType: faxType == 1 ? 'sader' : 'wared')
                ..getDocuments()
                ..getToInform()
                ..getFaxes(
                  isFollow: false,
                  isToday: false,
                  isSader: faxType == 2,
                  isWared: faxType == 1,
                ),
      child: BlocConsumer<AddFaxCubit, AddFaxState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = AddFaxCubit.get(context);
          return Scaffold(
            backgroundColor: const Color(0xFF1E2756), // Dark blue background
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header with logo and title
                    FaxHeader(faxType: faxType, cubit: cubit),

                    const SizedBox(height: 20),

                    // Main content
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Document preview section (left side)

                          // Form section (right side)
                          Expanded(flex: 2, child: FaxForm(faxType: faxType)),
                          const SizedBox(width: 20),

                          Expanded(
                            flex: 2,
                            child: DocumentPreview(
                              faxType: faxType,
                              useLocalFile: true,
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
      ),
    );
  }
}
