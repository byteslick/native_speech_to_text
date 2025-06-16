package com.yourcompany.native_speech_to_text

import android.app.Activity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.collect
import SpeechRecognizerManager

class NativeSpeechToTextPlugin: FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var speechManager: SpeechRecognizerManager? = null
    private var eventSink: EventChannel.EventSink? = null
    private var coroutineScope: CoroutineScope? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "native_speech_to_text")
        eventChannel = EventChannel(binding.binaryMessenger, "native_speech_to_text/transcripts")
        channel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(this)
        speechManager = SpeechRecognizerManager(binding.applicationContext as Activity)
        coroutineScope = CoroutineScope(Dispatchers.Main)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "resetTranscript" -> {
                speechManager?.resetTranscript()
                result.success(null)
            }
            "startTranscribing" -> {
                coroutineScope?.launch {
                    speechManager?.startTranscribing()?.collect { transcript ->
                        eventSink?.success(transcript)
                    }
                }
                result.success(null)
            }
            "stopTranscribing" -> {
                speechManager?.stopTranscribing()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        coroutineScope?.cancel()
    }
}
