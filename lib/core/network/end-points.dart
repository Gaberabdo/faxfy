import 'config_model.dart';

/// Base API paths
const String vetCare = '/vetcare';

/// Media URLs
String imageUrl = '${ConfigModel.baseApiUrlfaxfy}/files/';
String imageUrlWithVetICare = ConfigModel.serverFirstHalfOfWebSocket;

/// Auth & User Management
const String loginEndPoint = 'login';

/// API Endpoints
const String addFaxEndPoint = 'add_fax';
const String editFaxEndPoint = 'edit_fax';
const String newFaxIndexEndPoint = 'new_index';
const String getAddressEndPoint = 'get_address';
const String getFaxEndPoint = 'get_fax';
const String deleteFaxEndPoint = 'delete_fax';
const String getToInformEndPoint = 'get_names';
const String getLinkFaxEndPoint = 'linked_faxes';
const String printCoverEndPoint = 'print_cover';
String getFaxPdfEndPoint(String id) => 'fax_pdf/$id.pdf';
String getFaxHtmlEndPoint(String id) => 'cover_html/$id.html';
