// 录音服务（V4.0）
import 'package:record/record.dart';

class RecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<bool> hasPermission() async {
    return _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    if (_isRecording) return;
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw RecorderException('没有录音权限');
    }
    try {
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc, sampleRate: 16000),
        path: '',
      );
      _isRecording = true;
    } catch (e) {
      throw RecorderException('录音启动失败');
    }
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) return null;
    try {
      final path = await _recorder.stop();
      _isRecording = false;
      return path;
    } catch (e) {
      _isRecording = false;
      throw RecorderException('录音停止失败');
    }
  }

  Stream<RecordState> get onStateChanged => _recorder.onStateChanged();

  Future<Amplitude> getAmplitude() async {
    return _recorder.getAmplitude();
  }

  Future<void> dispose() async {
    if (_isRecording) {
      await _recorder.stop();
    }
    _isRecording = false;
    await _recorder.dispose();
  }
}

class RecorderException implements Exception {
  final String message;
  const RecorderException(this.message);
}
