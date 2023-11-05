package com.example.qrcode_magic

import android.os.Environment
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import com.example.qrcode_magic.NativeAdFactoryMedium
import com.example.qrcode_magic.NativeAdFactorySmall

class MainActivity: FlutterActivity() {

    private val CHANNEL = "qrcode_magic"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getExternalStorageDirectory" -> result.success(Environment.getExternalStorageDirectory().absolutePath)
                else -> result.notImplemented()
            }
        }

        // TODO: Register the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "listTile",
                 NativeAdFactorySmall(getContext())
        );
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "listTileMedium",
                 NativeAdFactoryMedium(getContext())
        );
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine!!)

        // TODO: Unregister the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTileMedium")
    }

}

