
import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charset_converter/charset_converter.dart';
import 'dart:typed_data';

import 'package:npc/models/item.dart';
import 'package:npc/config.dart';

// 示例：将 GBK 编码的文本转换为 UTF-8
Future<String> decodeGbkToUtf8(Uint8List gbkBytes, String type) async {
  String utf8String = await CharsetConverter.decode(type, gbkBytes);
  return utf8String;
}

// 示例：将 GBK 编码的文本转换为 UTF-8
Future<Uint8List> encodeGbkToUtf8(String input, String type) async {
  Uint8List encoded = await CharsetConverter.encode(type, input);
  return encoded;
}

Future<List<Item>> fetchItems() async {
  final response = await http.get(
    Uri.parse('${Config.baseUrl}${Config.todoList}?pageNum=1&pageSize=999&startTime=2024-02-23T16:00:00.000Z&endTime=2024-02-24T16:00:00.000Z'),
    // 添加请求头
    headers: {
      'Authorization': 'yf',
      'Content-Type': 'application/json;charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // 假设后台使用GBK编码，先转换编码
    // String gbkString = await decodeGbkToUtf8(response.bodyBytes, "GBK");
    // String utf8String = utf8.decode(gbkString.bodyBytes);
    // 现在utf8String是解码后的字符串，可以正常解析为JSON
    // String utf8String = await decodeGbkToUtf8(Uint8List.fromList(utf8.encode(gbkString)), "GBK");

    print(response);
    String decodedData = utf8.decode(response.bodyBytes);
    Map<String, dynamic> data = json.decode(decodedData)['data'];
    
    // final data = json.decode(response.body)['data'];
    if (data == null) {
      throw Exception('Data field is missing');
    }
    final records = data['records'] as List?;
    if (records == null) {
      throw Exception('Records field is missing');
    }
    return records.map<Item>((data) => Item.fromJson(data as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load items from API');
  }
}
