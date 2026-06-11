// DeepSeek API 客户端（V4.0）
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/ai_response.dart';
import '../config/constants.dart';
import 'system_prompt.dart';

class AiService {
  final Dio _dio;
  static const String _baseUrl = 'https://api.deepseek.com/v1/chat/completions';

  AiService() : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: AppDurations.aiTimeoutSeconds),
    receiveTimeout: const Duration(seconds: AppDurations.aiTimeoutSeconds),
    sendTimeout: const Duration(seconds: AppDurations.aiTimeoutSeconds),
    headers: {'Content-Type': 'application/json'},
  ));

  Future<AiResponse> parseVoiceText(String text, String apiKey) async {
    if (apiKey.isEmpty) {
      throw AiException('API Key 未配置，请在设置中配置');
    }

    try {
      final response = await _dio.post(
        _baseUrl,
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
        data: {
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': text},
          ],
          'temperature': 0.1,
          'max_tokens': 500,
          'stream': false,
        },
      );

      final choices = response.data['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        throw AiException('AI 响应格式异常');
      }

      final content = choices.first['message']?['content'] as String?;
      if (content == null || content.isEmpty) {
        throw AiException('AI 响应为空');
      }

      return AiResponse.fromJson(_extractJson(content));
    } on AiException {
      rethrow;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        throw AiException('API Key 无效，请在设置中重新配置');
      } else if (statusCode == 429) {
        throw AiException('请求太频繁，请稍后重试');
      } else if (statusCode != null && statusCode >= 500) {
        throw AiException('AI 服务异常，请稍后重试');
      }
      throw AiException('网络不可用，请稍后重试');
    } catch (e) {
      throw AiException('AI 解析失败，请重试');
    }
  }

  Map<String, dynamic> _extractJson(String content) {
    final start = content.indexOf('{');
    final end = content.lastIndexOf('}');
    if (start == -1 || end == -1 || start >= end) {
      throw AiException('AI 响应格式异常');
    }
    final jsonStr = content.substring(start, end + 1);
    try {
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      throw AiException('AI 响应 JSON 解析失败');
    }
  }
}

class AiException implements Exception {
  final String message;
  const AiException(this.message);

  @override
  String toString() => message;
}
