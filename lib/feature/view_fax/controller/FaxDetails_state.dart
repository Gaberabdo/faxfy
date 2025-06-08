part of 'FaxDetails_cubit.dart';

@immutable
abstract class FaxDetailsState {}

class FaxDetailsInitial extends FaxDetailsState {}

class GetPdfLoading extends FaxDetailsState {}
class GetPdfSuccess extends FaxDetailsState {}
class GetPdfFailure extends FaxDetailsState {}


class AddFaxToFollowLoading extends FaxDetailsState {}
class AddFaxToFollowSuccess extends FaxDetailsState {}
class AddFaxToFollowFailure extends FaxDetailsState {}
class AddOrEditFaxLoading extends FaxDetailsState {}
class AddOrEditFaxSuccess extends FaxDetailsState {
  final String? faxId;

  AddOrEditFaxSuccess(this.faxId);
}
class AddOrEditFaxFailure extends FaxDetailsState {
  final String error;

  AddOrEditFaxFailure(this.error);
}

class GetToInformLoading extends FaxDetailsState {}
class GetToInformSuccess extends FaxDetailsState {}
class GetToInformFailure extends FaxDetailsState {}