abstract class MainState {}

class MainInitial extends MainState {}

class AppChangeModeState extends MainState {}
class AppChangeModeError extends MainState {}
class AppChangeModeFromSharedState extends MainState {}

class DeleteTokenLoading extends MainState {}
class DeleteTokenSuccess extends MainState {}
class DeleteTokenError extends MainState {}

class SaveTokenLoading extends MainState {}
class SaveTokenSuccess extends MainState {}
class SaveTokenError extends MainState {}

class RequestNotificationPermissionsLoading extends MainState {}
class RequestNotificationPermissionsSuccess extends MainState {}
class RequestNotificationPermissionsError extends MainState {}

class ImageHelperLoading extends MainState {}
class ImageHelperSuccess extends MainState {}
class ImageHelperError extends MainState {}

class VideoHelperLoading extends MainState {}
class VideoHelperSuccess extends MainState {}
class VideoHelperError extends MainState {}

class SoundHelperLoading extends MainState {}
class SoundHelperSuccess extends MainState {}
class SoundHelperError extends MainState {}

class GetPdfLoading extends MainState {}
class GetPdfSuccess extends MainState {}
class GetPdfError extends MainState {}