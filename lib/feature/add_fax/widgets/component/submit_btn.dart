import 'package:faxfy/feature/add_fax/widgets/controller/add_fax_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../core/service/global_widget/toast.dart';
import '../../domain/entities/fax_entities.dart';
import 'dart:math' as math;

Widget buildSubmit(
  AddFaxCubit cubit,
  formKey,
  faxType,
  List<ToInformEntities> toInform,
  String linkFaxId,
) {
  return Center(
    child: TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [const Color(0xFFF5B93F), const Color(0xFFE0A93F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF5B93F).withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap:
                    cubit.isSubmitting
                        ? null
                        : () {
                          if (formKey.currentState!.validate()) {
                            if (cubit.localPdfFile == null) {
                              errorToast(context, 'من فضلك ادخل الملف');
                            } else {
                              var fax = FaxEntities(
                                senderName: cubit.senderController.text,
                                receiverName: cubit.recipientController.text,
                                subject: cubit.titleController.text,
                                dateTime: DateTime.parse(
                                  cubit.dateController.text,
                                ),
                                faxType: faxType == 1 ? 'sader' : 'wared',
                                faxAddress: cubit.departmentController.text,
                                faxId: cubit.faxId,
                                followDate: '',
                                index: int.parse(
                                  cubit.referenceController.text,
                                ),
                                note: '',
                                toInform: toInform,
                                linkedFaxId: linkFaxId,
                              );
                              print('fax: ${fax.toJson()}');
                              print('fax: ${toInform.length}');
                              cubit.addOrEditFax(fax, context, linkFaxId);
                            }
                          }
                        },
                child: Center(
                  child:
                      cubit.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Animated icon
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: const Duration(seconds: 1),
                                builder: (context, value, child) {
                                  return Transform.rotate(
                                    angle: value * 2 * math.pi,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        cubit.isSuccess
                                            ? Icons.edit
                                            : Icons.send,
                                        color: const Color(0xFFF5B93F),
                                        size: 24,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              Text(
                                cubit.isSuccess ? 'تعديل الفاكس' : 'اضافة فاكس',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
