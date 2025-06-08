part of 'fax_system_cubit.dart';

abstract class FaxSystemState extends Equatable {
  const FaxSystemState();

  @override
  List<Object> get props => [];
}

class FaxSystemInitial extends FaxSystemState {
  const FaxSystemInitial();
}

class FaxSystemLoading extends FaxSystemState {
  final String searchQuery;
  final int currentPage;
  final String selectedPdfPath;

  const FaxSystemLoading({
    this.searchQuery = '',
    this.currentPage = 1,
    this.selectedPdfPath = '',
  });

  @override
  List<Object> get props => [searchQuery, currentPage, selectedPdfPath];
}

class FaxSystemLoaded extends FaxSystemState {
  final List<FaxEntities> faxes;

  const FaxSystemLoaded({required this.faxes});
}

class FaxSystemError extends FaxSystemState {
  final String message;

  const FaxSystemError(this.message);

  @override
  List<Object> get props => [message];
}
class DeleteFaxState extends FaxSystemState {}