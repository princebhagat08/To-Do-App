package com.example.todo


import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService

class TaskRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var tasks: List<String> = listOf()
    private val TAG = "TaskRemoteViewsFactory"

    override fun onCreate() {
        Log.d(TAG, "onCreate")
        loadTasks()
    }

    override fun onDataSetChanged() {
        Log.d(TAG, "onDataSetChanged called")
        loadTasks()
        Log.d(TAG, "Loaded ${tasks.size} tasks")
    }

    private fun loadTasks() {
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val tasksString = prefs.getString("flutter.tasks", "")
        Log.d(TAG, "Loading tasks from prefs: $tasksString")
        tasks = tasksString?.split(",")?.filter { it.isNotEmpty() } ?: emptyList()
    }

    override fun onDestroy() {
        // No cleanup needed
    }

    override fun getCount(): Int = tasks.size

    override fun getViewAt(position: Int): RemoteViews {
        return RemoteViews(context.packageName, R.layout.task_item).apply {
            setTextViewText(R.id.task_text, tasks[position])
        }
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}