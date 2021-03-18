# timesheet

A flutter application to enter timesheet

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Flutter Notes

## Widget <-> State

A widget may extend a StatefulWidget, or a StatelessWidget.

### StatefulWidget

 * It must override the `createState` method.
 * The `createState` method returns a *State which is of type State<>
 * From any method inside the *State, we can access the widget anytime using a `widget` property.
 * To change the launch icon, update the pubspec.yaml
 flutter_launcher_icons: ^0.8.1
 
 flutter_icons:
   image_path: "icons/ic_launcher.png"
 * Add icon to androind>app>src>main>res> drawble, update launch_background
  <item>
     <bitmap
         android:gravity="center"
         android:src="@drawable/ic_launcher" />
     </item>

