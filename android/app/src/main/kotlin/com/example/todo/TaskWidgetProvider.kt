package com.example.todo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import android.widget.RemoteViews
import org.json.JSONArray

class TaskWidgetProvider : AppWidgetProvider() {
    private val TAG = "TaskWidgetProvider"
    private val updateAction = "com.example.todo.UPDATE_WIDGET"
    private val completeTaskAction = "com.example.todo.COMPLETE_TASK"
    private val openAppAction = "com.example.todo.OPEN_APP"
    private val widgetPrefsName = "FlutterSharedPreferences"
    private val widgetTasksKey = "flutter.widget_tasks"
    private val widgetCompletedIdsKey = "flutter.widget_completed_task_ids"
    private val taskIdExtra = "task_id"

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "onUpdate called with appWidgetIds: ${appWidgetIds.joinToString()}")
        for (appWidgetId in appWidgetIds) {
            Log.d(TAG, "Updating widget with ID: $appWidgetId")
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        Log.d(TAG, "updateWidget called for widget ID: $appWidgetId")

        val views = RemoteViews(context.packageName, R.layout.widget_layout)

        val serviceIntent = Intent(context, TaskWidgetService::class.java)
        serviceIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        serviceIntent.data = android.net.Uri.parse(serviceIntent.toUri(Intent.URI_INTENT_SCHEME))
        views.setRemoteAdapter(R.id.task_list_view, serviceIntent)
        views.setEmptyView(R.id.task_list_view, R.id.empty_view)

        val clickIntent = Intent(context, TaskWidgetProvider::class.java).apply {
            action = openAppAction
        }
        val clickPendingIntent = PendingIntent.getBroadcast(
            context,
            appWidgetId,
            clickIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setPendingIntentTemplate(R.id.task_list_view, clickPendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
        appWidgetManager.notifyAppWidgetViewDataChanged(intArrayOf(appWidgetId), R.id.task_list_view)
        Log.d(TAG, "Widget updated successfully for ID: $appWidgetId")
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d(TAG, "onReceive called with action: ${intent?.action}")
        super.onReceive(context, intent)

        if (context == null) {
            return
        }

        when (intent?.action) {
            completeTaskAction -> {
                val taskId = intent.getIntExtra(taskIdExtra, -1)
                if (taskId != -1) {
                    markTaskComplete(context, taskId)
                    refreshAllWidgets(context)
                }
            }
            openAppAction -> {
                val launchIntent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                context.startActivity(launchIntent)
            }
            updateAction, AppWidgetManager.ACTION_APPWIDGET_UPDATE -> {
                refreshAllWidgets(context)
            }
            else -> Log.d(TAG, "No custom action matched for intent")
        }
    }

    private fun refreshAllWidgets(context: Context) {
        Log.d(TAG, "Refreshing all widget instances")
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val componentName = android.content.ComponentName(context, TaskWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

        Log.d(TAG, "Found widget IDs to update: ${appWidgetIds.joinToString()}")
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }

        appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.task_list_view)
    }

    private fun markTaskComplete(context: Context, taskId: Int) {
        val prefs = context.getSharedPreferences(widgetPrefsName, Context.MODE_PRIVATE)
        val tasks = loadWidgetTasks(prefs).filterNot { it.optInt("id", -1) == taskId }
        val completedIds = loadPendingCompletedIds(prefs).toMutableSet()
        completedIds.add(taskId)

        prefs.edit()
            .putString(widgetTasksKey, JSONArray(tasks).toString())
            .putString(widgetCompletedIdsKey, JSONArray(completedIds.toList()).toString())
            .apply()
    }

    private fun loadWidgetTasks(prefs: SharedPreferences): List<org.json.JSONObject> {
        val raw = prefs.getString(widgetTasksKey, "[]") ?: "[]"
        val jsonArray = JSONArray(raw)
        return List(jsonArray.length()) { index -> jsonArray.getJSONObject(index) }
    }

    private fun loadPendingCompletedIds(prefs: SharedPreferences): List<Int> {
        val raw = prefs.getString(widgetCompletedIdsKey, "[]") ?: "[]"
        val jsonArray = JSONArray(raw)
        return List(jsonArray.length()) { index -> jsonArray.optInt(index) }
    }
}
