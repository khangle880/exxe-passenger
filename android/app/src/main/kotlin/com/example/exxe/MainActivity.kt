package com.exxe.passenger

import android.content.Intent
import android.util.Log
import android.view.View
import com.vnpay.authentication.VNP_AuthenticationActivity
import com.vnpay.authentication.VNP_SdkCompletedCallback
import android.os.Bundle
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import androidx.annotation.NonNull
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.maps.MapsInitializer
import com.google.android.gms.maps.MapsInitializer.Renderer
import com.google.android.gms.maps.OnMapsSdkInitializedCallback

class MainActivity : FlutterActivity(), OnMapsSdkInitializedCallback {
    private val VNPAY_CHANNEL_NAME = "passenger/vn_pay"
    private lateinit var _result: MethodChannel.Result

    private var vnPayChannel: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //Setup Channels
        setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)

    }

    override
    fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState);
        MapsInitializer.initialize(applicationContext, Renderer.LATEST, this)
    }

    override fun onMapsSdkInitialized(renderer: MapsInitializer.Renderer) {
        when (renderer) {
            Renderer.LATEST -> Log.d("NewRendererLog", "The latest version of the renderer is used.")
            Renderer.LEGACY -> Log.d("NewRendererLog", "The legacy version of the renderer is used.")
        }
    }

    override fun onDestroy() {
        teardownChannels()
        super.onDestroy()
    }

    private fun setupChannels(context: Context, messenger: BinaryMessenger) {
        vnPayChannel = MethodChannel(messenger, VNPAY_CHANNEL_NAME)
        vnPayChannel!!.setMethodCallHandler { call, result ->
            if (call.method == "open_sdk") {
                val arguments = call.arguments() as Map<String, String?>?

                val url = arguments?.get("url") ?: ""

                openSdk(url)

                result.success("success")
            } else {
                result.notImplemented()
            }
        }

    }

    private fun teardownChannels() {
        vnPayChannel!!.setMethodCallHandler(null)
    }

    private fun openSdk(url: String) {
        val intent = Intent(this, VNP_AuthenticationActivity::class.java)
        intent.putExtra("url", url) //bắt buộc, VNPAY cung cấp
        intent.putExtra("tmn_code", "EXXEAPP1") //bắt buộc, VNPAY cung cấp
        intent.putExtra("scheme", "exxe") //bắt buộc, scheme để mở lại app khi có kết quả thanh toán từ mobile banking
        intent.putExtra("is_sandbox", false) //bắt buộc, true <=> môi trường test, true <=> môi trường live
        VNP_AuthenticationActivity.setSdkCompletedCallback(VNP_SdkCompletedCallback { action ->
            {
                Log.wtf("SplashActivity", "action: $action")
            }
        } as VNP_SdkCompletedCallback?)
        startActivity(intent)
    }
}
