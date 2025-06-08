import 'package:dio/dio.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:path_provider/path_provider.dart';

class DioFinalHelper {
  static late Dio dio;

  static Map<String, String> _buildHeaders() {
    return {
      "Content-Type": "application/json",
      'set-cookie': CacheHelper.getData('token') ?? '',
      'ngrok-skip-browser-warning': 'true', // any value works

    };
  }

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: ConfigModel.baseApiUrlfaxfy,
        receiveDataWhenStatusError: true,
        headers: _buildHeaders(),
      ),
    );

  }

  static Future<Response> postData({
    required String method,
    required dynamic data,
  }) async {
    return await dio.post(
      method,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          'cookie': CacheHelper.getData('token') ?? '',
          'ngrok-skip-browser-warning': 'true', // any value works

        },
      ),
    );
  }

  static Future<Response> getData({required String method}) async {
    return await dio.get(
      method,
      options: Options(
        headers: {
          'cookie': CacheHelper.getData('token') ?? '',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<String> getDataPdf({required String method}) async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/downloaded_fax.pdf';

    await dio.download(
      method,
      filePath,
      options: Options(
        headers: {
          'cookie': CacheHelper.getData('token') ?? '',
          'Content-Type': 'application/pdf',
        },
      ),
    );


    return filePath;  // Return the file path
  }
  static Future<String> getDataHtml({required String method}) async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/cover_fax.html';

    await dio.download(
      method,
      filePath,
      options: Options(
        headers: {
          'cookie': CacheHelper.getData('token') ?? '',
          'Content-Type': 'text/html',
        },
      ),
    );
    return filePath;  // Return the file path

  }
  static Future<Response> putData({
    required String method,
    required Map<String, dynamic> data,
  }) async {
    return await dio.put(method, data: data);
  }

  static Future<Response> patchData({
    required String method,
    required Map<String, dynamic> data,
  }) async {
    return await dio.patch(method, data: data);
  }

  static Future<Response> deleteData({
    required String method,
    Map<String, dynamic>? data,
  }) async {
    return await dio.delete(method, data: data);
  }
}
