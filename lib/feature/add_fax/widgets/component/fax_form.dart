// File: lib/feature/add_fax/widgets/component/fax_form.dart

import 'dart:ui';

import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:faxfy/feature/add_fax/widgets/component/infrom_to_form.dart';
import 'package:faxfy/feature/add_fax/widgets/component/search_address.dart';
import 'package:faxfy/feature/add_fax/widgets/component/submit_btn.dart';
import 'package:faxfy/feature/add_fax/widgets/component/text_form_feild.dart';
import 'package:faxfy/feature/add_fax/widgets/component/fax_selector.dart'; // Import the new component
import 'package:faxfy/feature/add_fax/widgets/controller/add_fax_cubit.dart';
import 'package:faxfy/feature/add_fax/widgets/controller/add_fax_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaxForm extends StatefulWidget {
  const FaxForm({super.key, required this.faxType});

  final int faxType;

  @override
  State<FaxForm> createState() => _FaxFormState();
}

class _FaxFormState extends State<FaxForm> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _floatController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _floatAnimation;

  List<ToInformEntities> toInform = [];
  List<String> address = [];
  String? linkedFaxId; // Add this to store the linked fax ID

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeInAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  final formKey = GlobalKey<FormState>();

  // Add this method to handle fax selection
  void handleFaxSelect(String faxId) {
    setState(() {
      linkedFaxId = faxId == 0 ? null : faxId; // Handle clearing selection
    });
    print('Linked to fax ID: $faxId');
    // You can also update your cubit here if needed
    // AddFaxCubit.get(context).updateLinkedFaxId(faxId);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddFaxCubit, AddFaxState>(
      listener: (context, state) {
        if (state is GetAddressSuccess) {
          address.addAll(state.address);
        }
      },
      builder: (context, state) {
        var cubit = AddFaxCubit.get(context);

        return FadeTransition(
          opacity: _fadeInAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: const Color(0xFFF5B93F).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Animated title
                          Center(
                            child: AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnimation.value),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(
                                            0xFFF5B93F,
                                          ).withOpacity(0.8),
                                          const Color(
                                            0xFFF5B93F,
                                          ).withOpacity(0.6),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFF5B93F,
                                          ).withOpacity(0.3),
                                          blurRadius: 15,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      widget.faxType == 1
                                          ? 'بيانات الفاكس الصادر'
                                          : 'بيانات الفاكس الوارد',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          buildFormField(
                            inputType: TextInputType.text,
                            controller: cubit.titleController,
                            validator: 'من فضلك ادخل عنوان الفاكس',
                            label: 'أدخل عنوان الفاكس هنا',
                            icon: Icons.edit_document,
                            hint: 'أدخل عنوان الفاكس',
                          ),
                          const SizedBox(height: 20),

                          // Add the Fax Selector component here
                          if (widget.faxType == 1)
                            FaxSelector(
                              onFaxSelect: handleFaxSelect,
                              currentFaxType: widget.faxType,
                              allFaxes: cubit.allFaxes,
                            ),
                          const SizedBox(height: 20),

                          // Section content with animation
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (
                              Widget child,
                              Animation<double> animation,
                            ) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.05, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildFaxDetailsSection(cubit),
                          ),

                          const SizedBox(height: 30),

                          // Submit button with creative design
                          buildSubmit(
                            cubit,
                            formKey,
                            widget.faxType,
                            toInform,
                            linkedFaxId ?? '',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFaxDetailsSection(AddFaxCubit cubit) {
    return Container(
      key: const ValueKey('faxDetails'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF5B93F).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          buildFormField(
            inputType: TextInputType.number,
            controller: cubit.referenceController,
            validator: 'من فضلك ادخل مسلسل الفاكس',
            label: 'مسلسل الفاكس',
            icon: Icons.format_list_numbered,
            hint: 'أدخل رقم مسلسل الفاكس',
          ),
          const SizedBox(height: 15),

          if (widget.faxType == 2)
            TagInputWidget(
              onTagsChanged: (p0) {
                toInform = p0;
                cubit.toInformController.text = toInform.last.username;
                setState(() {});
              },
              controller: cubit.toInformController,
            ),

          const SizedBox(height: 15),
          buildFormField(
            inputType: TextInputType.datetime,
            controller: cubit.dateController,
            validator: 'من فضلك ادخل التاريخ',
            label: 'التاريخ',
            icon: Icons.calendar_today,
            hint: 'أدخل تاريخ الفاكس',
          ),
          const SizedBox(height: 15),
          buildFormFieldSearch(
            inputType: TextInputType.text,
            controller: cubit.departmentController,
            validator: 'من فضلك ادخل الجهة',
            label: 'الجهة',
            icon: Icons.business,
            hint: 'أدخل اسم الجهة',
            cubit: cubit,
            address: address,
            setState: setState,
          ),

          if (widget.faxType == 1)
            buildFormField(
              inputType: TextInputType.text,
              controller: cubit.senderController,
              validator: 'من فضلك ادخل جندي المسلم',
              label: 'جندي المسلم',
              icon: Icons.person_outline,
              hint: 'أدخل اسم جندي المسلم',
            ),
          if (widget.faxType == 1) const SizedBox(height: 15),
          buildFormField(
            inputType: TextInputType.text,
            controller: cubit.recipientController,
            validator: 'من فضلك ادخل جندي المستلم',
            label: 'الجندي المستلم',
            icon: Icons.person,
            hint: 'أدخل اسم الجندي المستلم',
          ),
        ],
      ),
    );
  }
}
