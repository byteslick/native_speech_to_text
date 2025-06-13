import 'native_speech_to_text_platform_interface.dart';

class NativeSpeechToText {
  /// Erases the transcript.
  static Future<void> resetTranscript() => NativeSpeechToTextPlatform.instance.resetTranscript();

  /// Starts live speech-to-text transcription.
  static Future<void> startTranscribing() => NativeSpeechToTextPlatform.instance.startTranscribing();

  /// Stops the transcription session.
  static Future<void> stopTranscribing() => NativeSpeechToTextPlatform.instance.stopTranscribing();

  /// Stream of live transcript updates.
  static Stream<String> get transcriptUpdates => NativeSpeechToTextPlatform.instance.transcriptUpdates;

}
