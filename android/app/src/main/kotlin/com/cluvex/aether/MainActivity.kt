package com.cluvex.aether

import android.app.Activity
import android.content.Intent
import android.net.VpnService
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val VPN_CHANNEL = "com.cluvex.aether/vpn"
    private val CORE_CHANNEL = "com.cluvex.aether/core"
    private val LOG_EVENT_CHANNEL = "com.cluvex.aether/logs"

    private val VPN_REQUEST_CODE = 1819

    private lateinit var binaryManager: AetherBinaryManager
    private var logEventSink: EventChannel.EventSink? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binaryManager = AetherBinaryManager(applicationContext)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Logs streaming channel
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, LOG_EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    logEventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    logEventSink = null
                }
            }
        )

        // VPN Control MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VPN_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "prepareVpn" -> {
                    val intent = VpnService.prepare(this)
                    if (intent != null) {
                        startActivityForResult(intent, VPN_REQUEST_CODE)
                        result.success(false)
                    } else {
                        result.success(true)
                    }
                }
                "startVpn" -> {
                    val intent = Intent(this, AetherVpnService::class.java).apply {
                        action = AetherVpnService.ACTION_START
                    }
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(true)
                }
                "stopVpn" -> {
                    val intent = Intent(this, AetherVpnService::class.java).apply {
                        action = AetherVpnService.ACTION_STOP
                    }
                    startService(intent)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        // Core Binary MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CORE_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startCore" -> {
                    val protocol = call.argument<String>("protocol") ?: "masque"
                    val scan = call.argument<String>("scan") ?: "balanced"
                    val noise = call.argument<String>("noise") ?: "firewall"
                    val http2 = call.argument<Boolean>("http2") ?: false
                    val fragment = call.argument<Boolean>("fragment") ?: false
                    val fragmentSize = call.argument<String>("fragmentSize") ?: ""
                    val fragmentDelay = call.argument<String>("fragmentDelay") ?: ""
                    val quickReconnect = call.argument<Boolean>("quickReconnect") ?: true
                    val bindAddr = call.argument<String>("bind") ?: "127.0.0.1:1819"
                    val customPeer = call.argument<String>("peer") ?: ""

                    val success = binaryManager.startBinary(
                        protocol, scan, noise, http2, fragment,
                        fragmentSize, fragmentDelay, quickReconnect,
                        bindAddr, customPeer
                    ) { logLine ->
                        runOnUiThread {
                            logEventSink?.success(logLine)
                        }
                    }
                    result.success(success)
                }
                "stopCore" -> {
                    binaryManager.stopBinary()
                    result.success(true)
                }
                "isCoreRunning" -> {
                    result.success(binaryManager.isRunning())
                }
                "getAbi" -> {
                    result.success(binaryManager.getAbi())
                }
                "updateBinary" -> {
                    val binaryBytes = call.argument<ByteArray>("bytes")
                    if (binaryBytes != null && binaryBytes.isNotEmpty()) {
                        try {
                            val file = binaryManager.getExecutableFile()
                            file.writeBytes(binaryBytes)
                            file.setExecutable(true, false)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("UPDATE_FAILED", e.message, null)
                        }
                    } else {
                        result.error("INVALID_BYTES", "Binary payload empty", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode: Int, resultCode: Int, data: Intent?)
        if (requestCode == VPN_REQUEST_CODE) {
            val granted = (resultCode == Activity.RESULT_OK)
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, VPN_CHANNEL)
                .invokeMethod("onVpnPermissionResult", granted)
        }
    }
}
