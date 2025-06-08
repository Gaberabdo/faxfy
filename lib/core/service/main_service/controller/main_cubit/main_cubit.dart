import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faxfy/core/network/config_model.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../feature/add_fax/data/models/fax_model.dart';
import '../../../../../feature/auth/domain/entities/user_entites.dart';
import '../../../../../test.dart';
import '../../../cache/cache_helper.dart';
import 'main_state.dart';
import 'package:intl/intl.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);
  String? language;

  void changeAppLang({String? fromSharedLang, String? langMode}) {
    if (fromSharedLang != null) {
      language = fromSharedLang;

      emit(AppChangeModeState());
    } else {
      language = langMode;

      CacheHelper.saveData('language', langMode!).then((value) {
        emit(AppChangeModeState());
      });
    }
  }

  File? localPdfFile;
  Future<void> getPdf(id) async {
    emit(GetPdfLoading());
    try {
      final result = await DioFinalHelper.getDataHtml(
        method: getFaxHtmlEndPoint(id),
      );
      localPdfFile = File(result);
      OpenFile.open(localPdfFile!.path, type: 'text/html');

      emit(GetPdfSuccess());
    } on DioException catch (e) {
      emit(GetPdfError());
    }
  }

  Future<void> connectToSocket() async {
    print('Connecting to WebSocket...');
    try {
      WebSocketChannel channel = IOWebSocketChannel.connect(
        Uri.parse(ConfigModel.serverFirstHalfOfWebSocket),
        headers: {'cookie': CacheHelper.getData('token') ?? ''},
      );

      channel.stream.listen(
        (data) async {
          print('data: $data');

          if (data.contains('new_fax')) {
            await sendWindowsNotification(
              title: "تم استلام فاكس جديد بنجاح على جهازك",
              body:
                  ".يرجى العلم أن الفاكس يحتوي على معلومات هامة قد تحتاج إلى مراجعتها في أقرب وقت ممكن.",
            );
          } else {
            try {
              final Map<String, dynamic> jsonData = json.decode(data);
              if (jsonData.containsKey('fax_id')) {
                getPdf(jsonData['fax_id']);
              } else {
                print('Missing fax_id in WebSocket data.');
              }
            } catch (e) {
              print('Error decoding JSON from WebSocket: $e');
            }
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
        onDone: () {
          print('WebSocket disconnected.');
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('Connection error: $e');
    }
  }

  bool isDark = false;

  List<Roles> roles = [];
  bool isSend = false;
  void scheduleCheckAt9AM() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();

      if (!isSend) {
        if (now.hour == 9) {
          checkFollowUpFaxes(allFaxes);
          isSend = true;
        }
      } else {
        timer.cancel();
      }
    });
    emit(AppChangeModeState());
  }

  List<FaxModel> allFaxes = [];
  Future<void> loadFaxes() async {
    if (roles.contains(Roles.follow)) {
      try {
        final response = await DioFinalHelper.getData(method: getFaxEndPoint);
        allFaxes =
            (response.data as List)
                .map((item) => FaxModel.fromJson(item))
                .toList();
        scheduleCheckAt9AM();
      } on DioException catch (e) {
        print(e.response!.data);
      }
    }
  }

  Future<void> loadUserData() async {
    CacheHelper.getData('username');
    String? raw = CacheHelper.getData('role');
    if (raw != null) {
      List<String> roleStrings = List<String>.from(jsonDecode(raw));
      roles = roleStrings.map((e) => Roles.values.byName(e)).toList();
    }
    emit(AppChangeModeState());
  }

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeFromSharedState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData('isDark', isDark);
      emit(AppChangeModeState());
    }
  }

  Future<void> checkFollowUpFaxes(List<FaxEntities> faxes) async {
    print('checkFollowUpFaxes');
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    for (var fax in faxes) {
      try {
        final faxFollowDate = DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.parse(fax.followDate.trim()));
        if (faxFollowDate == today) {
          print('Sending notification for fax: ${fax.faxId}');
          await sendWindowsNotification(
            title: "لديك فاكس متابعة بتاريخ اليوم",
            body:
                "الموضوع: ${fax.subject}\nالرجاء مراجعته في أقرب وقت، فقد يحتوي على معلومات هامة.",
          );
          break; // only one notification needed per day
        }
      } catch (e) {
        print(
          'Date parse error for fax: ${fax.faxId}, followDate: ${fax.followDate}',
        );
      }
    }
  }
}

enum NotificationTypeFax { new_fax, print_cover }
