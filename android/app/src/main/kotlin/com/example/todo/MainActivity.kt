package com.example.todo

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.appwidget.AppWidgetManager
import android.content.ComponentName

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.todo/update_widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateWidget") {
                //log
                // Update your widget here
                updateWidget()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun updateWidget() {
        // Update widget data
        val appWidgetManager = AppWidgetManager.getInstance(applicationContext)
        val ids = appWidgetManager.getAppWidgetIds(
            ComponentName(applicationContext, TaskWidgetProvider::class.java)
        )

        // This is crucial - it triggers onDataSetChanged() in RemoteViewsFactory
        appWidgetManager.notifyAppWidgetViewDataChanged(ids, R.id.task_list_view)

        // Send broadcast to update widget
        val intent = Intent(applicationContext, TaskWidgetProvider::class.java)
        intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
        sendBroadcast(intent)
    }
}