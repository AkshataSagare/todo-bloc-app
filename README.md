# 📝 ToDo App

A modern Flutter-based **Task Manager Application** that helps users add, edit, delete, sort, and filter tasks efficiently with persistent local storage and a clean UI.

---

## 📱 Screenshots

| Task Screen | Calendar View |
|-------------|----------------|
| ![Task Screen](https://github.com/AkshataSagare/todo-bloc-app/raw/master/demo/task_screen.png) | ![Calendar Screen](https://github.com/AkshataSagare/todo-bloc-app/raw/master/demo/calendar_screen.png) |

| Create Task Dialog | Edit Task Dialog | Delete Task Dialog |
|--------------------|------------------|--------------------|
| ![Create Task](https://github.com/AkshataSagare/todo-bloc-app/raw/master/demo/create_new_task_dialog_box.png) | ![Edit Task](https://github.com/AkshataSagare/todo-bloc-app/raw/master/demo/edit_task_dialog_box.png) | ![Delete Task](https://github.com/AkshataSagare/todo-bloc-app/raw/master/demo/delete_task_dialog_box.png) |

| Sort Bottom Sheet | Filter Bottom Sheet | Task Completed |
|-------------------|---------------------|----------------|
| ![Sort Sheet](https://github.com/AkshataSagare/todo-bloc-app/raw/master/demo/sort_bottom_sheet.png) | ![Filter Sheet](https://github.com/AkshataSagare/todo-bloc-app/raw/master/demo/filter_bottom_sheet.png) | ![Completed Task](https://github.com/AkshataSagare/todo-bloc-app/raw/master/demo/complete_task.png) |

---

## 🧩 Features

- Add new tasks with priority and due date
- Edit existing tasks
- Delete tasks with confirmation
- Mark tasks as complete
- Sort tasks by date or priority
- Filter tasks by completion status
- View tasks in a calendar interface

---

## ⚙️ Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_bloc: ^9.1.1
  uuid: ^4.5.1
  shared_preferences: ^2.5.3
  equatable: ^2.0.7
  intl: ^0.20.2
  table_calendar: ^3.2.0
```

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/AkshataSagare/todo-bloc-app.git
cd flutter-task-manager
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart
│
├── core/
│   ├── app_themes/
│   │   └── app_themes.dart
│   └── utilities/
│       └── snackbars.dart
│
├── presentations/
│   ├── bloc/
│   │   ├── todo_bloc.dart
│   │   ├── todo_event.dart
│   │   └── todo_state.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── enums.dart
│   │   │   └── task_model.dart
│   │   └── repositories/
│   │       └── todo_repo.dart
│   │
│   ├── tabs/
│   │   ├── calendar/screens/
│   │   │   └── calendar_screen.dart
│   │   └── tasks/screens/
│   │       └── tasks_screen.dart
│   │
│   ├── widgets/
│   │   ├── delete_dialog_widget.dart
│   │   ├── dialog_widget.dart
│   │   ├── filter_bottom_sheet.dart
│   │   ├── sort_bottom_sheet.dart
│   │   └── task_tile_widget.dart
│   │
│   └── layout_screen.dart
```

---
## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile app development
- **Bloc Pattern**: State management
- **Shared Preferences**: Local data persistence
- **Table Calendar**: Calendar widget for task scheduling
- **UUID**: Unique identifier generation
- **Intl**: Internationalization and date formatting

---

## 📋 Key Features Explained

### Task Management
- Create tasks with title, description, priority level, and due date
- Edit existing tasks to update any field
- Delete tasks with confirmation dialog
- Mark tasks as complete/incomplete

### Organization
- Sort tasks by creation date, due date, or priority
- Filter tasks by completion status (all, pending, completed)
- Calendar view to visualize tasks by date

### Data Persistence
- All tasks are saved locally using SharedPreferences
- Data persists between app sessions
- Automatic loading of saved tasks on app startup

---

## 🎨 UI/UX Features

- Clean and intuitive Material Design interface
- Smooth animations and transitions
- Bottom sheets for sorting and filtering options
- Dialog boxes for task creation and editing
- Visual indicators for task priority levels
- Responsive design for different screen sizes

---

## 🔧 Configuration

### Android
No additional configuration required.

### iOS
No additional configuration required.

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📞 Support

If you have any questions or issues, please open an issue on GitHub.

---