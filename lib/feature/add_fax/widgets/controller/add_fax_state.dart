import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';

abstract class AddFaxState {}

class AddFaxInitial extends AddFaxState {}

class AddFaxIndexLoading extends AddFaxState {}

class AddFaxIndexFetched extends AddFaxState {
  final int index;

  AddFaxIndexFetched(this.index);
}

class AddOrEditFaxLoading extends AddFaxState {}

class AddOrEditFaxSuccess extends AddFaxState {
  final String? faxId;

  AddOrEditFaxSuccess(this.faxId);
}

class AddOrEditFaxFailure extends AddFaxState {
  final String error;

  AddOrEditFaxFailure(this.error);
}

class GetAddressLoading extends AddFaxState {}

class GetAddressSuccess extends AddFaxState {
  final List<String> address;

  GetAddressSuccess(this.address);
}

class GetAddressFailure extends AddFaxState {
  final String error;

  GetAddressFailure(this.error);
}

class GetToInformLoading extends AddFaxState {}

class GetToInformSuccess extends AddFaxState {}

class GetToInformFailure extends AddFaxState {}

class FaxSystemLoading extends AddFaxState {
  final String searchQuery;
  final int currentPage;
  final String selectedPdfPath;

  FaxSystemLoading({
    this.searchQuery = '',
    this.currentPage = 1,
    this.selectedPdfPath = '',
  });

  @override
  List<Object> get props => [searchQuery, currentPage, selectedPdfPath];
}

class FaxSystemLoaded extends AddFaxState {
  final List<FaxEntities> faxes;

  FaxSystemLoaded({required this.faxes});
}

class FaxSystemError extends AddFaxState {
  final String message;

  FaxSystemError(this.message);

  @override
  List<Object> get props => [message];
}
