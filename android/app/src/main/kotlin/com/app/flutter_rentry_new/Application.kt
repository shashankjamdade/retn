package com.app.flutter_rentry_new


import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
//        FlutterFirebaseMessagingService.setPluginRegistrant(this)

        /*Following will generate the hash code*/
        var appSignature = AppSignatureHelper(this)
        appSignature.appSignatures
    }

    override fun registerWith(registry: PluginRegistry) {
//        CustomPluginRegistrant.registerWith(registry)
    }
}