import Flutter
import UIKit

public class NativeSpeechToTextPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    var speechRecognizer: SpeechRecognizer? = SpeechRecognizer()
    var eventSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "native_speech_to_text", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "native_speech_to_text/transcripts", binaryMessenger: registrar.messenger())
        let instance = NativeSpeechToTextPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "resetTranscript":
            speechRecognizer?.resetTranscript()
            result(nil)
        case "startTranscribing":
            speechRecognizer?.startTranscribing()
            _ = speechRecognizer?.receiveTranscriptUpdates { [weak self] transcript in
                self?.eventSink?(transcript)
            }
            result(nil)
        case "stopTranscribing":
            speechRecognizer?.stopTranscribing()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // Event channel handlers
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
