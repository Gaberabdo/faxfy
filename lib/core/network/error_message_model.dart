import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final String message;

  const ErrorMessageModel({required this.message});

  factory ErrorMessageModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ErrorMessageModel(message: json['message'] ?? 'Unknown error');
    } else if (json is String) {
      return ErrorMessageModel(message: json);
    } else {
      return const ErrorMessageModel(message: 'Unexpected error format');
    }
  }

  @override
  List<Object?> get props => [message];
}
