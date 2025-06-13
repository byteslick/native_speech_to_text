import 'dart:async';
import 'package:flutter/services.dart';
import 'native_speech_to_text_platform_interface.dart';

class MethodChannelNativeSpeechToText extends NativeSpeechToTextPlatform {
  static const _channel = MethodChannel('native_speech_to_text');
  static const _eventChannel = EventChannel('native_speech_to_text/transcripts');

  @override
  Future<void> resetTranscript() => _channel.invokeMethod('resetTranscript');

  @override
  Future<void> startTranscribing() => _channel.invokeMethod('startTranscribing');

  @override
  Future<void> stopTranscribing() => _channel.invokeMethod('stopTranscribing');

  @override
  Stream<String> get transcriptUpdates =>
      _eventChannel.receiveBroadcastStream().map((event) => event as String);
}
