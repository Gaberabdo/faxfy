import 'package:faxfy/feature/calendar/controller/calendar_cubit.dart';
import 'package:faxfy/feature/calendar/controller/calendar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../../models/meeting_data_source.dart';
import '../component/event/event_list_sheet.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  CalendarView _currentView = CalendarView.month;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CalendarCubit>()..getFaxes(),
      child: BlocConsumer<CalendarCubit, CalendarState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = CalendarCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xFF1E2756),
              appBar: AppBar(
                backgroundColor: const Color(0xFF1E2756),
                elevation: 0,
                title: Row(
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animationController.value * 2 * 3.14159,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/logo_placeholder.png',
                                width: 30,
                                height: 30,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.calendar_month,
                                    color: Color(0xFF1E2756),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'منظومة فاكسات المتابعة',
                      style: TextStyle(
                        color: Color(0xFFF5B93F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              body: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SfCalendar(
                            showDatePickerButton: true,
                            view: _currentView,
                            dataSource: MeetingDataSource(cubit.allFaxes),
                            headerStyle: const CalendarHeaderStyle(
                              textStyle: TextStyle(
                                color: Color(0xFF1E2756),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            allowedViews: [
                              CalendarView.day,
                              CalendarView.week,
                              CalendarView.workWeek,
                              CalendarView.month,
                            ],
                            scheduleViewSettings: const ScheduleViewSettings(),
                            monthViewSettings: MonthViewSettings(
                              appointmentDisplayMode:
                                  MonthAppointmentDisplayMode.appointment,
                            ),
                            appointmentTextStyle: const TextStyle(
                              color: Color(0xFF1E2756),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            appointmentBuilder: (
                              context,
                              calendarAppointmentDetails,
                            ) {
                              final meeting =
                                  calendarAppointmentDetails.appointments.first;
                              return InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder:
                                        (context) => EventListSheet(
                                          cubit: cubit,
                                          selectedDate: meeting.startTime,
                                          faxes: cubit.allFaxes,
                                          onFaxesChanged: () {},
                                        ),
                                  );
                                },

                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5B93F),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      meeting.subject,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            todayHighlightColor: const Color(0xFFF5B93F),
                            selectionDecoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFF5B93F),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),

                            onTap: (calendarTapDetails) {
                              if (calendarTapDetails.targetElement ==
                                  CalendarElement.calendarCell) {
                                final selectedDate = calendarTapDetails.date;
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder:
                                      (context) => EventListSheet(
                                        cubit: cubit,
                                        selectedDate: selectedDate!,
                                        faxes: cubit.allFaxes,
                                        onFaxesChanged: () {},
                                      ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
