import 'package:faxfy/core/service/global_widget/toast.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:faxfy/feature/view_fax/controller/FaxDetails_cubit.dart';
import 'package:flutter/material.dart';

class AddEventFollowDialog extends StatefulWidget {
  const AddEventFollowDialog({
    super.key,
    required this.cubit,
    required this.faxEntities,
  });
  final FaxDetailsCubit cubit;
  final FaxEntities faxEntities;

  @override
  _AddEventFollowDialogState createState() => _AddEventFollowDialogState();
}

class _AddEventFollowDialogState extends State<AddEventFollowDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _noteController = TextEditingController();

  late DateTime _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _followDate;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _followDate = widget.faxEntities.followDate ?? '';
    _noteController.text = widget.faxEntities.note;
    _selectedDate = DateTime.now();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectFollowUpDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      locale: const Locale('ar', ''),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E2756),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E2756),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _followDate =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        title: Text(
          _followDate != null ? 'تعديل فاكس للمتابعة' : 'إضافة فاكس للمتابعة',
          style: TextStyle(
            color: Color(0xFF1E2756),
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2756).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'التاريخ: ${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
                        style: const TextStyle(color: Color(0xFF1E2756)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFF5B93F),
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          locale: const Locale('ar', ''),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF1E2756),
                                  onPrimary: Colors.white,
                                  onSurface: Color(0xFF1E2756),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2756).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'الوقت: ${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Color(0xFF1E2756)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.access_time,
                        color: Color(0xFFF5B93F),
                      ),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF1E2756),
                                  onPrimary: Colors.white,
                                  onSurface: Color(0xFF1E2756),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedTime = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2756).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'تاريخ المتابعة: ${_followDate ?? 'غير محدد'}',
                        style: const TextStyle(color: Color(0xFF1E2756)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Color(0xFFF5B93F),
                      ),
                      onPressed: _selectFollowUpDate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'ملاحظات',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFF5B93F),
                      width: 2,
                    ),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5B93F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (_followDate != null) {
                print('followDate: ${widget.faxEntities.toJson()}');
                FaxEntities faxEntities = FaxEntities(
                  faxType: widget.faxEntities.faxType,
                  index: widget.faxEntities.index,
                  toInform: widget.faxEntities.toInform,
                  subject: widget.faxEntities.subject,
                  dateTime: widget.faxEntities.dateTime,
                  faxAddress: widget.faxEntities.faxAddress,
                  receiverName: widget.faxEntities.receiverName,
                  faxId: widget.faxEntities.faxId,
                  senderName: widget.faxEntities.senderName,
                  note: _noteController.text,
                  followDate: _followDate ?? '',
                  linkedFaxId: widget.faxEntities.linkedFaxId,
                );
                widget.cubit.addToFollowOrEditFax(faxEntities, context);

                Navigator.pop(context, faxEntities);
              } else {
                infoToast(context, 'يرجى تحديد تاريخ المتابعة');
              }
            },
            child: const Text(
              'إضافة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
