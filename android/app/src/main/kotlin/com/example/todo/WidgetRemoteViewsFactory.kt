package com.example.todo

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import org.json.JSONArray
import org.json.JSONObject

class WidgetRemoteViewsFactory(
    private val context: Context,
    intent: Intent
) : RemoteViewsService.RemoteViewsFactory {

    private var tasks = mutableListOf<TaskData>()

    data class TaskData(
        val title: String,
        val description: String,
        val isCompleted: Boolean,
        val priority: Int
    )

    override fun onCreate() {
        // Initialize
    }

    override fun onDataSetChanged() {
        // Load tasks from SharedPreferences
        loadTasks()
    }

    private fun loadTasks() {
        tasks.clear()
        
        try {
            val prefs = context.getSharedPreferences(
                "HomeWidgetPreferences",
                Context.MODE_PRIVATE
            )
            val tasksJson = prefs.getString("widget_tasks", "[]") ?: "[]"
            
            android.util.Log.d("TodoWidget", "Loading tasks from SharedPrefs: $tasksJson")
            
            val jsonArray = JSONArray(tasksJson)
            for (i in 0 until jsonArray.length()) {
                val taskObj = jsonArray.getJSONObject(i)
                tasks.add(
                    TaskData(
                        title = taskObj.getString("title"),
                        description = taskObj.getString("description"),
                        isCompleted = taskObj.getBoolean("isCompleted"),
                        priority = taskObj.getInt("priority")
                    )
                )
            }
            
            android.util.Log.d("TodoWidget", "Loaded ${tasks.size} tasks")
        } catch (e: Exception) {
            android.util.Log.e("TodoWidget", "Error loading tasks", e)
            e.printStackTrace()
        }
    }

    override fun onDestroy() {
        tasks.clear()
    }

    override fun getCount(): Int = tasks.size

    override fun getViewAt(position: Int): RemoteViews {
        return try {
            val views = RemoteViews(context.packageName, R.layout.item_task)
            
            if (position >= tasks.size) {
                android.util.Log.w("TodoWidget", "Position $position >= tasks.size ${tasks.size}")
                return views
            }

            val task = tasks[position]
            android.util.Log.d("TodoWidget", "Rendering task at position $position: ${task.title}")

            // Set task title
            views.setTextViewText(R.id.task_title, task.title)

            // Set task description
            views.setTextViewText(R.id.task_description, 
                if (task.description.isEmpty()) "No description" else task.description)

            // Set priority color
            val priorityColor = when (task.priority) {
                2 -> Color.parseColor("#F44336") // High - Red
                1 -> Color.parseColor("#FF9800") // Medium - Orange
                else -> Color.parseColor("#4CAF50") // Low - Green
            }
            views.setInt(R.id.priority_indicator, "setBackgroundColor", priorityColor)

            // Set checkbox status
            val checkboxColor = if (task.isCompleted) {
                Color.parseColor("#4CAF50") // Green for completed
            } else {
                Color.parseColor("#E0E0E0") // Gray for incomplete
            }
            views.setInt(R.id.task_status, "setBackgroundColor", checkboxColor)

            // Apply strikethrough if completed
            if (task.isCompleted) {
                views.setTextColor(R.id.task_title, Color.parseColor("#999999"))
                views.setTextColor(R.id.task_description, Color.parseColor("#CCCCCC"))
            } else {
                views.setTextColor(R.id.task_title, Color.parseColor("#1A1A1A"))
                views.setTextColor(R.id.task_description, Color.parseColor("#666666"))
            }

            android.util.Log.d("TodoWidget", "Successfully rendered task at position $position")
            views
        } catch (e: Exception) {
            android.util.Log.e("TodoWidget", "Error in getViewAt for position $position", e)
            RemoteViews(context.packageName, R.layout.item_task)
        }
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}
