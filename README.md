#  Flutter ToDo App

A simple, fast, and offline-first **ToDo List application built with Flutter** that helps users create, manage, prioritize, and get reminded about their daily tasks.  
The app uses **GetX** for state management, **Hive** for local storage, and **flutter_local_notifications** for reminders and task expiration alerts.

---

##  Features

- Create, edit, and delete tasks  
-  Each task includes:
  - Title  
  - Description  
  - Priority (Low / Medium / High)  
  - Due date & time  
-  Set reminders for upcoming tasks  
-  Push notifications when tasks are about to expire  
-  Search tasks by title or keyword  
-  Sort tasks by:
  - Priority  
  - Due date  
  - Creation date  
-  Offline support — data is saved locally and persists even after app restart  
- Fast and reactive UI using GetX  

---

##  Tech Stack

| Technology | Purpose |
|-----------|---------|
| Flutter | UI framework |
| GetX | State management & navigation |
| Hive | Local NoSQL database |
| flutter_local_notifications | Local push notifications |

---

##  App Architecture

- **GetX Controllers**
  - Handles task CRUD operations
  - Manages filters, sorting, and search

- **Hive Database**
  - Stores tasks locally on the device
  - Ensures data persistence even after app restart

- **Notification Service**
  - Schedules reminders
  - Triggers notifications on task expiration

---

##  Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_local_notifications: ^17.0.0
  timezone: ^0.9.2

```

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/14e1ba13-6a7f-4d02-955d-c0b3149808fe" width="220" />
  <img src="https://github.com/user-attachments/assets/6c9f7151-5509-4979-b0b7-28052b9f3912" width="220" />
  <img src="https://github.com/user-attachments/assets/8cf87323-7572-496f-83ca-3d150bf23ba7" width="220" />
  <img src="https://github.com/user-attachments/assets/d7c57d50-3a8d-4ce3-bc6d-f4b26c74fdda" width="220" />
</p>





