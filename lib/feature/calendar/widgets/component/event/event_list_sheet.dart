import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../add_fax/data/models/fax_model.dart';
import '../../../../view_fax/widgets/screens/edit_fax_screen.dart';
import '../../../controller/calendar_cubit.dart';

class EventListSheet extends StatefulWidget {
  final DateTime selectedDate;
  final List<FaxEntities> faxes;
  final VoidCallback onFaxesChanged;
  final CalendarCubit cubit;
  const EventListSheet({
    super.key,
    required this.selectedDate,
    required this.faxes,
    required this.onFaxesChanged,
    required this.cubit,
  });

  @override
  State<EventListSheet> createState() => _EventListSheetState();
}

class _EventListSheetState extends State<EventListSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedFaxes =
        widget.faxes
            .where(
              (fax) => isSameDay(
                DateTime.parse(fax.followDate.toString()),
                widget.selectedDate,
              ),
            )
            .toList();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            MediaQuery.of(context).size.height * 0.5 * _slideAnimation.value,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2756).withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                        style: const TextStyle(
                          color: Color(0xFF1E2756),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF1E2756)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Fax list
                Expanded(
                  child:
                      selectedFaxes.isEmpty
                          ? const Center(
                            child: Text(
                              'لا توجد فاكسات لهذا اليوم',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: selectedFaxes.length,
                            itemBuilder: (context, index) {
                              final fax = selectedFaxes[index];
                              return TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: Duration(
                                  milliseconds: 300 + (index * 100),
                                ),
                                curve: Curves.easeOut,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(20 * (1 - value), 0),
                                      child: Card(
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          side: BorderSide(
                                            color: const Color(
                                              0xFFF5B93F,
                                            ).withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFFF5B93F,
                                              ).withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.event_note,
                                                color: const Color(0xFFF5B93F),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            fax.subject,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E2756),
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  navigateAndFinish(
                                                    context,
                                                    FaxSystemEditScreen(
                                                      fax: fax,
                                                      faxType: fax.faxType,
                                                      endDate: null,
                                                      startDate: null,
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  fax.faxAddress
                                                      .split('/')
                                                      .last,
                                                  style: TextStyle(
                                                    color: Colors.blue[700],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: PopupMenuButton<String>(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Color(0xFF1E2756),
                                            ),
                                            onSelected: (value) async {
                                              if (value == 'view') {
                                                // widget.cubit
                                                //     .getPdf(fax.faxId)
                                                //     .then(
                                                //       (value) => OpenFile.open(
                                                //         widget
                                                //             .cubit
                                                //             .localPdfFile!
                                                //             .path,
                                                //       ),
                                                //     );
                                                navigateAndFinish(
                                                  context,
                                                  FaxSystemEditScreen(
                                                    fax: fax,
                                                    faxType: fax.faxType,
                                                    endDate: null,
                                                    startDate: null,
                                                  ),
                                                );
                                              } else if (value == 'remove') {
                                                widget.cubit
                                                    .getPdf(fax.faxId)
                                                    .then((value) {
                                                      var model = FaxEntities(
                                                        senderName:
                                                            fax.senderName ??
                                                            '',
                                                        receiverName:
                                                            fax.receiverName,
                                                        subject: fax.subject,
                                                        dateTime: fax.dateTime,
                                                        faxType: fax.faxType,
                                                        faxId: fax.faxId,
                                                        faxAddress:
                                                            fax.faxAddress,
                                                        index: fax.index,
                                                        linkedFaxId:
                                                            fax.linkedFaxId,
                                                        note: fax.note,

                                                        toInform: fax.toInform,
                                                        followDate: '',
                                                      );
                                                      return widget.cubit
                                                          .removeFaxToFollow(
                                                            model,
                                                          );
                                                    });
                                                widget.faxes.remove(fax);

                                                if (selectedFaxes.length == 1) {
                                                  Navigator.pop(context);
                                                } else {
                                                  setState(() {});
                                                }
                                              } else if (value == 'copy') {
                                                _onFollowDatePicked(fax);
                                              }
                                            },
                                            itemBuilder:
                                                (context) => [
                                                  const PopupMenuItem<String>(
                                                    value: 'view',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.visibility,
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text('عرض الملف'),
                                                      ],
                                                    ),
                                                  ),
                                                  const PopupMenuItem<String>(
                                                    value: 'remove',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text('حذف الفاكس'),
                                                      ],
                                                    ),
                                                  ),
                                                  const PopupMenuItem<String>(
                                                    value: 'copy',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.copy,
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text('نسخ إلى يوم آخر'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onFollowDatePicked(FaxEntities fax) async {
    DateTime newDate = await _pickNewDate(context);

    final updatedFax = FaxModel(
      faxType: fax.faxType,
      faxId: fax.faxId,
      index: fax.index,
      subject: fax.subject,
      toInform: fax.toInform,
      faxAddress: fax.faxAddress,
      linkedFaxId: fax.linkedFaxId,
      receiverName: fax.receiverName,
      senderName: fax.senderName,
      note: fax.note,
      followDate: DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
      ).toString().substring(0, 10),
      dateTime: fax.dateTime,
    );

    widget.faxes.add(updatedFax);

    try {
      await widget.cubit.getPdf(fax.faxId);
      await widget.cubit.removeFaxToFollow(updatedFax);
      widget.faxes.remove(fax);
      await widget.cubit.getFaxes();
      setState(() {});
      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<DateTime> _pickNewDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
    return picked ?? DateTime.now();
  }
} // Don't forget to define AddEventDialog somewhere else
