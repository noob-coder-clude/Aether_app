package com.cluvex.aether

import android.content.Context
import android.os.Build
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream

class AetherBinaryManager(private val context: Context) {

    companion object {
        private const val TAG = "AetherBinaryManager"
        private const val BINARY_NAME = "aether"
    }

    private var process: Process? = null

    fun getAbi(): String {
        val abis = Build.SUPPORTED_ABIS
        for (abi in abis) {
            when (abi) {
                "arm64-v8a" -> return "arm64"
                "armeabi-v7a", "armeabi" -> return "armv7"
                "x86_64" -> return "x86_64"
            }
        }
        return "arm64"
    }

    fun getExecutableFile(): File {
        val binDir = File(context.filesDir, "bin")
        if (!binDir.exists()) binDir.mkdirs()
        return File(binDir, BINARY_NAME)
    }

    fun ensureBinaryExists(): Boolean {
        val file = getExecutableFile()
        if (file.exists() && file.length() > 1000) {
            file.setExecutable(true, false)
            return true
        }

        val abi = getAbi()
        val assetPath = "bin/aether-android-$abi"
        try {
            val inputStream: InputStream = context.assets.open(assetPath)
            val outputStream = FileOutputStream(file)
            inputStream.copyTo(outputStream)
            inputStream.close()
            outputStream.close()
            file.setExecutable(true, false)
            Log.i(TAG, "Successfully extracted binary for ABI: $abi")
            return true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to extract asset $assetPath: ${e.message}")
        }
        return false
    }

    fun startBinary(
        protocol: String,
        scan: String,
        noise: String,
        http2: Boolean,
        fragment: Boolean,
        fragmentSize: String,
        fragmentDelay: String,
        quickReconnect: Boolean,
        bindAddr: String,
        customPeer: String,
        onLogLine: (String) -> Unit
    ): Boolean {
        stopBinary()

        val binaryFile = getExecutableFile()
        if (!binaryFile.exists()) {
            if (!ensureBinaryExists()) {
                onLogLine("[App Error] Core binary missing and extraction failed.")
                return false
            }
        }
        binaryFile.setExecutable(true, false)

        val args = mutableListOf<String>()
        args.add(binaryFile.absolutePath)
        args.add("--bind")
        args.add(bindAddr)

        // Protocol flag
        when (protocol.lowercase()) {
            "masque" -> args.add("--masque")
            "wg", "wireguard" -> args.add("--wg")
            "gool" -> args.add("--gool")
            else -> args.add("--masque")
        }

        // Scan mode
        if (scan.isNotEmpty()) {
            args.add("--scan")
            args.add(scan)
        }

        // Noise profile
        if (noise.isNotEmpty()) {
            args.add("--noize")
            args.add(noise)
        }

        // MASQUE HTTP/2 & Fragmentation
        if (protocol.lowercase() == "masque") {
            if (http2) {
                args.add("--h2")
                if (fragment) {
                    args.add("--fragment")
                    if (fragmentSize.isNotEmpty()) {
                        args.add("--fragment-size")
                        args.add(fragmentSize)
                    }
                    if (fragmentDelay.isNotEmpty()) {
                        args.add("--fragment-delay")
                        args.add(fragmentDelay)
                    }
                }
            }
        }

        // Quick Reconnect
        if (quickReconnect) {
            args.add("--quick-reconnect")
        } else {
            args.add("--no-quick-reconnect")
        }

        // Custom Peer
        if (customPeer.isNotEmpty()) {
            args.add("--peer")
            args.add(customPeer)
        }

        try {
            val pb = ProcessBuilder(args)
            pb.directory(context.filesDir)
            pb.redirectErrorStream(true)

            Log.i(TAG, "Launching binary with command: ${args.joinToString(" ")}")
            onLogLine(">> Executing: ${args.joinToString(" ")}")

            process = pb.start()

            Thread {
                try {
                    val reader = process?.inputStream?.bufferedReader()
                    var line: String?
                    while (reader?.readLine().also { line = it } != null) {
                        line?.let {
                            Log.d(TAG, "[Core Output] $it")
                            onLogLine(it)
                        }
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error reading binary stream: ${e.message}")
                }
            }.start()

            return true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to launch binary: ${e.message}")
            onLogLine("[App Error] Failed to launch binary: ${e.message}")
            return false
        }
    }

    fun stopBinary() {
        try {
            process?.destroy()
            process = null
            Log.i(TAG, "Binary process stopped.")
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping binary process: ${e.message}")
        }
    }

    fun isRunning(): Boolean {
        return process?.isAlive == true
    }
}
