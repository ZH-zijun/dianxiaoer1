// UI 状态管理（V4.0）
import 'package:flutter/material.dart';
import '../config/constants.dart';

class UIProvider extends ChangeNotifier {
  bool _isRecording = false;
  bool _isParsing = false;
  String? _toastMessage;
  bool _showReward = false;
  bool _showThanks = false;
  bool _showOnboarding = false;
  bool _isOffline = false;
  List<Map<String, dynamic>> _newProducts = [];
  int _recordingDurationMs = 0;

  bool get isRecording => _isRecording;
  bool get isParsing => _isParsing;
  String? get toastMessage => _toastMessage;
  bool get showReward => _showReward;
  bool get showThanks => _showThanks;
  bool get showOnboarding => _showOnboarding;
  bool get isOffline => _isOffline;
  List<Map<String, dynamic>> get newProducts => _newProducts;
  int get recordingDurationMs => _recordingDurationMs;

  void setRecording(bool value) {
    _isRecording = value;
    if (!value) _recordingDurationMs = 0;
    notifyListeners();
  }

  void updateRecordingDuration(int ms) {
    _recordingDurationMs = ms;
    notifyListeners();
  }

  void setParsing(bool value) {
    _isParsing = value;
    notifyListeners();
  }

  void showToast(String message) {
    _toastMessage = message;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: AppDurations.toastDurationMs), () {
      _toastMessage = null;
      notifyListeners();
    });
  }

  void setShowReward(bool value) {
    _showReward = value;
    notifyListeners();
  }

  void setShowThanks(bool value) {
    _showThanks = value;
    notifyListeners();
  }

  void setShowOnboarding(bool value) {
    _showOnboarding = value;
    notifyListeners();
  }

  void setOffline(bool value) {
    _isOffline = value;
    notifyListeners();
  }

  void setNewProducts(List<Map<String, dynamic>> products) {
    _newProducts = products;
    notifyListeners();
  }

  void clearNewProducts() {
    _newProducts = [];
    notifyListeners();
  }
}