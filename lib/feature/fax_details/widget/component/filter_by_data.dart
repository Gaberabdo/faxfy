import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/fax_system_cubit.dart';

class DateFilterCalendar extends StatefulWidget {
  const DateFilterCalendar({super.key, required this.faxSystemCubit});
  final FaxSystemCubit faxSystemCubit;
  @override
  State<DateFilterCalendar> createState() => _DateFilterCalendarState();
}

class _DateFilterCalendarState extends State<DateFilterCalendar> {
  DateTimeRange? _selectedDateRange;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd', 'en_US');

  void _showDateRangePicker() async {
    final initialDateRange = DateTimeRange(
      start:
          widget.faxSystemCubit.startDate ??
          DateTime.now().subtract(const Duration(days: 7)),
      end: widget.faxSystemCubit.endDate ?? DateTime.now(),
    );
    // Filter faxes by date range
    _selectedDateRange = initialDateRange;
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      initialEntryMode: DatePickerEntryMode.input,
      lastDate: DateTime.now(),

      initialDateRange: _selectedDateRange ?? initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFD700), // Gold color for selected dates
              onPrimary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
      });

      // Filter faxes by date range
      widget.faxSystemCubit.filterByDateRange(
        _selectedDateRange!.start,
        _selectedDateRange!.end,
      );
    }
  }

  @override
  initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      if (widget.faxSystemCubit.startDate != null &&
          widget.faxSystemCubit.endDate != null) {
        setState(() {
          _selectedDateRange = DateTimeRange(
            start: widget.faxSystemCubit.startDate!,
            end: widget.faxSystemCubit.endDate!,
          );
        });
      }
    });
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDateRange = null;
    });
    // Reset date filter
    widget.faxSystemCubit.resetDateFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: _showDateRangePicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFD700), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    _selectedDateRange != null
                        ? '${_dateFormat.format(_selectedDateRange!.start)} - ${_dateFormat.format(_selectedDateRange!.end)}'
                        : 'تصفية حسب التاريخ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.calendar_today,
                    color: const Color(0xFFFFD700),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (_selectedDateRange != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.red, size: 20),
              onPressed: _clearDateFilter,
              tooltip: 'مسح التصفية',
            ),
        ],
      ),
    );
  }
}
