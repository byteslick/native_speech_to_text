import 'package:native_speech_to_text/native_speech_to_text_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class NativeSpeechToTextPlatform extends PlatformInterface {
  NativeSpeechToTextPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeSpeechToTextPlatform _instance = MethodChannelNativeSpeechToText();

  static NativeSpeechToTextPlatform get instance => _instance;

  static set instance(NativeSpeechToTextPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> resetTranscript();
  Future<void> startTranscribing();
  Future<void> stopTranscribing();
  Stream<String> get transcriptUpdates;
}
