import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;

List<Channel> convertToChannelList(List<dynamic> mapList) {
  List<Channel> channelList = [];
  for (var map in mapList) {
    channelList.add(Channel.fromJson(map));
  }
  return channelList;
}

List<Link> convertToLinkList(List<dynamic> mapList) {
  List<Link> linkList = [];
  for (var map in mapList) {
    linkList.add(Link.fromJson(map));
  }
  return linkList;
}

UploadedFile convertToUploadedFile(dynamic map) {
  UploadedFile uploadedFile = UploadedFile(OriginalName: "", Filename: "");
  uploadedFile = UploadedFile.fromJson(map);
  return uploadedFile;
}

List<Account> convertToAccountList(List<dynamic> mapList) {
  List<Account> channelList = [];
  for (var map in mapList) {
    channelList.add(Account.fromJson(map));
  }
  return channelList;
}

class UploadedFile {
  String OriginalName;
  String Filename;

  UploadedFile({required this.OriginalName, required this.Filename});
  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
        OriginalName: json['OriginalName'], Filename: json['Filename']);
  }
  Map<String, dynamic> toJson() {
    return {'OriginalName': OriginalName, 'Filename': Filename};
  }
}

class Type {
  int value;
  String text;

  Type({required this.value, required this.text});
  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(value: json['value'], text: json['text']);
  }
  Map<String, dynamic> toJson() {
    return {'value': value, 'text': text};
  }
}

class Account {
  int Id;
  String Name;
  int Channel;

  Account({required this.Id, required this.Name, required this.Channel});
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        Id: json['Id'], Name: json['Name'], Channel: json['Channel']);
  }
  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Name': Name,
      'Channel': Channel,
    };
  }
}

class Link {
  String Id;
  String IdExt;
  String? Name;

  Link({required this.Id, required this.IdExt, required this.Name});
  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
        Id: json['Id'].toString(), IdExt: json['IdExt'], Name: json['Name']);
  }
  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'IdExt': IdExt,
      'Name': Name,
    };
  }
}

class Channel {
  int Id;
  String Nm;

  Channel({required this.Id, required this.Nm});
  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      Id: json['Id'],
      Nm: json['Nm'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Nm': Nm,
    };
  }
}

class ApiResponse<T> {
  int code;
  bool isError;
  T data;
  String? error;

  ApiResponse({
    required this.code,
    required this.isError,
    required this.data,
    required this.error,
  });
}

class Nobox {
  String? token;
  String baseUrl = "https://id.nobox.ai/";

  Nobox(this.token) {
    token = token!.replaceAll('"', '');
  }

  Future<ApiResponse<String>> generateToken(
      String username, String password) async {
    final url = Uri.parse("${baseUrl}AccountAPI/GenerateToken");
    final headers = {"Content-Type": "application/json"};
    final data = jsonEncode({"username": username, "password": password});

    final response = await http.post(url, headers: headers, body: data);
    final statusCode = response.statusCode;
    final responseData = jsonDecode(response.body);

    ApiResponse<String> result = ApiResponse<String>(
      code: 0,
      isError: true,
      data: "",
      error: '',
    );
    result.code = statusCode;

    if (statusCode == 200) {
      result.isError = false;
      result.data = responseData["token"].toString();
    } else {
      result.isError = true;
      result.error = responseData["InitialText"];
    }

    return result;
  }

  Future<ApiResponse<String>> sendInboxMessage(String linkId, int channelId,
      String accountIds, int bodyType, String body, String attachment) async {
    final url = Uri.parse("${baseUrl}Inbox/Send");
    final headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json"
    };
    final data = jsonEncode({
      "LinkId": linkId,
      "ChannelId": channelId,
      "AccountIds": accountIds,
      "BodyType": bodyType,
      "Body": body,
      "Attachment": attachment
    });

    final response = await http.post(url, headers: headers, body: data);
    final statusCode = response.statusCode;

    ApiResponse<String> result = ApiResponse<String>(
      code: 0,
      isError: true,
      data: "",
      error: '',
    );
    result.code = statusCode;

    if (statusCode == 200) {
      result.isError = false;
      final responseData = jsonDecode(response.body);
      if (responseData["Error"] == null) {
        result.data = (responseData["Data"]);
      } else {
        result.isError = true;
        result.error = responseData["Error"];
      }
    } else {
      result.isError = true;
      result.error = response.body;
    }

    return result;
  }

  Future<ApiResponse<String>> sendInboxMessageExt(String extId, int channelId,
      String accountIds, int bodyType, String body, String attachment) async {
    final url = Uri.parse("${baseUrl}Inbox/Send");
    final headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json"
    };
    final data = jsonEncode({
      "ExtId": extId,
      "ChannelId": channelId,
      "AccountIds": accountIds,
      "BodyType": bodyType,
      "Body": body,
      "Attachment": attachment
    });

    final response = await http.post(url, headers: headers, body: data);
    final statusCode = response.statusCode;

    ApiResponse<String> result = ApiResponse<String>(
      code: 0,
      isError: true,
      data: "",
      error: '',
    );
    result.code = statusCode;

    if (statusCode == 200) {
      result.isError = false;
      final responseData = jsonDecode(response.body);
      if (responseData["Error"] == null) {
        result.data = (responseData["Data"]);
      } else {
        result.isError = true;
        result.error = responseData["Error"];
      }
    } else {
      result.isError = true;
      result.error = response.body;
    }

    return result;
  }

  Future<ApiResponse<UploadedFile>> uploadBase64(
      String filename, String mimetype, String base64) async {
    final url = Uri.parse("${baseUrl}Inbox/UploadFile/UploadBase64");
    final headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json"
    };
    final data = jsonEncode({
      "filename": filename,
      "mimetype": mimetype,
      "data": base64,
    });

    final response = await http.post(url, headers: headers, body: data);

    final statusCode = response.statusCode;

    ApiResponse<UploadedFile> result = ApiResponse<UploadedFile>(
      code: 0,
      isError: true,
      data: UploadedFile(OriginalName: "", Filename: ''),
      error: '',
    );
    result.code = statusCode;

    var rs = await response.body;
    if (statusCode == 200) {
      result.isError = false;
      final responseData = jsonDecode(rs);
      if (responseData["Error"] == null) {
        result.data = convertToUploadedFile(responseData["Data"]);
      } else {
        result.isError = true;
        result.error = responseData["Error"];
      }
    } else {
      result.isError = true;
      result.error = rs;
    }

    return result;
  }

  Future<ApiResponse<UploadedFile>> uploadFile(File file) async {
    final url = Uri.parse("${baseUrl}Inbox/UploadFile/UploadFile");
    var headers = {"Authorization": "Bearer ${token}"};

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();

    final statusCode = response.statusCode;

    ApiResponse<UploadedFile> result = ApiResponse<UploadedFile>(
      code: 0,
      isError: true,
      data: UploadedFile(OriginalName: "", Filename: ''),
      error: '',
    );
    result.code = statusCode;

    var rs = await response.stream.bytesToString();
    if (statusCode == 200) {
      result.isError = false;
      final responseData = jsonDecode(rs);
      if (responseData["Error"] == null) {
        result.data = convertToUploadedFile(responseData["Data"]);
      } else {
        result.isError = true;
        result.error = responseData["Error"];
      }
    } else {
      result.isError = true;
      result.error = rs;
    }

    return result;
  }

  Future<ApiResponse<List<Channel>>> getChannelList() async {
    final url = Uri.parse("${baseUrl}Services/Master/Channel/List");
    final headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json"
    };
    final data = jsonEncode({
      "ColumnSelection": 1,
      "IncludeColumns": ["Id", "Nm"]
    });

    final response = await http.post(url, headers: headers, body: data);
    final statusCode = response.statusCode;

    ApiResponse<List<Channel>> result = ApiResponse<List<Channel>>(
      code: 0,
      isError: true,
      data: [],
      error: '',
    );
    result.code = statusCode;

    if (statusCode == 200) {
      result.isError = false;
      final responseData = jsonDecode(response.body);
      if (responseData["Error"] == null) {
        result.data = convertToChannelList(responseData["Entities"]);
      } else {
        result.isError = true;
        result.error = responseData["Error"];
      }
    } else {
      result.isError = true;
      result.error = response.body;
    }

    return result;
  }

  Future<ApiResponse<List<Account>>> getAccountList() async {
    final url = Uri.parse("${baseUrl}Services/Nobox/Account/List");
    final headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json"
    };
    final data = jsonEncode({
      "ColumnSelection": 1,
      "IncludeColumns": ["Id", "Name", "Channel"]
    });

    final response = await http.post(url, headers: headers, body: data);
    final statusCode = response.statusCode;

    ApiResponse<List<Account>> result = ApiResponse<List<Account>>(
      code: 0,
      isError: true,
      data: [],
      error: '',
    );
    result.code = statusCode;

    if (statusCode == 200) {
      result.isError = false;
      final responseData = jsonDecode(response.body);
      if (responseData["Error"] == null) {
        result.data = convertToAccountList(responseData["Entities"]);
      } else {
        result.isError = true;
        result.error = responseData["Error"];
      }
    } else {
      result.isError = true;
      result.error = response.body;
    }

    return result;
  }

  Future<ApiResponse<List<Link>>> getLinkList({int channelId = 0}) async {
    final url = Uri.parse("${baseUrl}Services/Chat/Chatlinkcontacts/List");
    final headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json"
    };
    final data = jsonEncode({
      "ColumnSelection": 1,
      "IncludeColumns": ["Id", "IdExt", "Name"],
      'EqualityFilter': {
        if (channelId != 0) 'ChId': channelId,
      },
    });

    final response = await http.post(url, headers: headers, body: data);
    final statusCode = response.statusCode;

    ApiResponse<List<Link>> result = ApiResponse<List<Link>>(
      code: 0,
      isError: true,
      data: [],
      error: '',
    );
    result.code = statusCode;

    if (statusCode == 200) {
      result.isError = false;
      final responseData = jsonDecode(response.body);
      if (responseData["Error"] == null) {
        result.data = convertToLinkList(responseData["Entities"]);
      } else {
        result.isError = true;
        result.error = responseData["Error"];
      }
    } else {
      result.isError = true;
      result.error = response.body;
    }

    return result;
  }

  Future<ApiResponse<List<Type>>> getTypeList() async {
    final bodyTypes = [
      Type(text: 'Text', value: 1),
      Type(text: 'Audio', value: 2),
      Type(text: 'Image', value: 3),
      Type(text: 'Sticker', value: 7),
      Type(text: 'Video', value: 4),
      Type(text: 'File', value: 5),
      Type(text: 'Location', value: 9),
      Type(text: 'Order', value: 10),
      Type(text: 'Product', value: 11),
      Type(text: 'VCARD', value: 12),
      Type(text: 'VCARD_MULTI', value: 13),
    ];

    ApiResponse<List<Type>> result = ApiResponse<List<Type>>(
      code: 0,
      isError: true,
      data: [],
      error: '',
    );
    result.code = 200;
    result.isError = false;
    result.data = bodyTypes;

    return result;
  }
}

// Example usage
// final token = "your_token";
// final nobox = Nobox(token);

// Send Inbox Message
// final linkId = 123;
// final channelId = 456;
// final accountIds = "abc,def,ghi";
// final bodyType = 1;
// final body = "Hello, world!";
// final attachment = "path/to/file";
// final inboxResponse = await nobox.sendInboxMessage(linkId, channelId, accountIds, bodyType, body, attachment);
// print("Send Inbox Message Response: $inboxResponse");

// Get Channel List
// final channelListResponse = await nobox.getChannelList();
// print("Channel List Response: $channelListResponse");

// Generate Token
// final username = "your_username";
// final password = "your_password";
// final tokenResponse = await nobox.generateToken(username, password);
// print("Token Response: $tokenResponse");
