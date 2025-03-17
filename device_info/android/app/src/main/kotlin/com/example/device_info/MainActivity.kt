package com.example.device_info

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader

class MainActivity : FlutterActivity() {
    private val CHANNEL = "sunmi/device_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSerialNumber") {
                val serialNumber = getSunmiSerialNumber()
                result.success(serialNumber)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSunmiSerialNumber(): String {
        return try {
            val process = Runtime.getRuntime().exec("getprop ro.sunmi.serial")
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val serial = reader.readLine()
            reader.close()
            serial ?: "Unknown"
        } catch (e: Exception) {
            e.printStackTrace()
            "Can not retrieve"
        }
    }
}
