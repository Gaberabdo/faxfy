
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';

abstract class CalendarState {
  const CalendarState();
}

class CalenderSystemInitial extends CalendarState {
  const CalenderSystemInitial();
}

class CalenderSystemLoading extends CalendarState {
  final String searchQuery;
  final int currentPage;
  final String selectedPdfPath;

  const CalenderSystemLoading({
    this.searchQuery = '',
    this.currentPage = 1,
    this.selectedPdfPath = '',
  });
}

class CalenderSystemLoaded extends CalendarState {
  final List<FaxEntities> calender;

  const CalenderSystemLoaded({required this.calender});
}

class CalenderSystemError extends CalendarState {
  final String message;

  const CalenderSystemError(this.message);
}

class GetPdfLoading extends CalendarState {}

class GetPdfSuccess extends CalendarState {}

class GetPdfFailure extends CalendarState {}


class AddFaxToFollowLoading extends CalendarState {}
class AddFaxToFollowSuccess extends CalendarState {}
class AddFaxToFollowFailure extends CalendarState {}
