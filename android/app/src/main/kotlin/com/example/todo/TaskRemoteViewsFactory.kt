package com.example.todo

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import org.json.JSONArray
import org.json.JSONObject
import android.content.Intent

class TaskRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var tasks: List<WidgetTask> = listOf()
    private val TAG = "TaskRemoteViewsFactory"
    private val completeTaskAction = "com.example.todo.COMPLETE_TASK"
    private val openAppAction = "com.example.todo.OPEN_APP"
    private val taskIdExtra = "task_id"

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
        val tasksString = prefs.getString("flutter.widget_tasks", "[]")
        Log.d(TAG, "Loading tasks from prefs: $tasksString")
        tasks = try {
            val jsonArray = JSONArray(tasksString ?: "[]")
            List(jsonArray.length()) { index ->
                WidgetTask.fromJson(jsonArray.getJSONObject(index))
            }
                .filter { it.title.isNotBlank() && !it.isCompleted }
                .sortedWith(
                    compareByDescending<WidgetTask> { it.priorityIndex }
                        .thenBy { it.dueAtMillis }
                )
        } catch (e: Exception) {
            Log.e(TAG, "Failed to parse widget task list", e)
            emptyList()
        }
    }

    override fun onDestroy() {
        // No cleanup needed
    }

    override fun getCount(): Int = tasks.size

    override fun getViewAt(position: Int): RemoteViews {
        val task = tasks[position]
        return RemoteViews(context.packageName, R.layout.task_item).apply {
            setTextViewText(R.id.task_text, task.title)
            setTextViewText(R.id.task_time, task.time)
            setTextViewText(R.id.task_priority, task.priority)

            val priorityBackground = when (task.priority.lowercase()) {
                "high" -> R.drawable.widget_priority_high
                "medium" -> R.drawable.widget_priority_medium
                else -> R.drawable.widget_priority_low
            }

            setImageViewResource(
                R.id.task_checkbox,
                if (task.isCompleted) {
                    R.drawable.widget_checkbox_checked
                } else {
                    R.drawable.widget_checkbox_unchecked
                }
            )
            setInt(R.id.task_priority, "setBackgroundResource", priorityBackground)

            val completeIntent = Intent().apply {
                action = completeTaskAction
                putExtra(taskIdExtra, task.id)
            }
            setOnClickFillInIntent(R.id.task_checkbox, completeIntent)

            val openIntent = Intent().apply {
                action = openAppAction
                putExtra(taskIdExtra, task.id)
            }
            setOnClickFillInIntent(R.id.task_item_root, openIntent)
        }
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true

    data class WidgetTask(
        val id: Int,
        val title: String,
        val time: String,
        val dueAtMillis: Long,
        val priority: String,
        val priorityIndex: Int,
        val isCompleted: Boolean
    ) {
        companion object {
            fun fromJson(json: JSONObject): WidgetTask {
                return WidgetTask(
                    id = json.optInt("id", -1),
                    title = json.optString("title"),
                    time = json.optString("time"),
                    dueAtMillis = json.optLong("dueAtMillis", Long.MAX_VALUE),
                    priority = json.optString("priority", "Low"),
                    priorityIndex = json.optInt("priorityIndex", 0),
                    isCompleted = json.optBoolean("isCompleted", false)
                )
            }
        }
    }
}
